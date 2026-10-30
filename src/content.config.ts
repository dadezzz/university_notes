import { defineCollection } from "astro:content";
import { spawn } from "node:child_process";
import { cpus } from "node:os";
import path from "node:path";
import { text } from "node:stream/consumers";
import { docsSchema } from "@astrojs/starlight/schema";
import { glob, type LoaderContext } from "astro/loaders";
import { z } from "astro/zod";

const SRC_PATH = "./src";
const DOCS_PATH = `${SRC_PATH}/content/docs`;

const TYPST_ARGS = ["--root", DOCS_PATH, "--features=html"];
const TYPST_COMPILE_ARGS = [...TYPST_ARGS, "--format=html"];
const CPUS = cpus().length;

// Runs work on items of arr with limited concurrency.
async function parallelLimit<T>(workers: number, arr: T[], work: (v: T) => Promise<void>): Promise<void> {
  // Create an iterator from the array of items.
  const iter = arr.values();
  // Run concurrent workers. Work for each item is done only once since the
  // iterator returns an item only once.
  const jobs = new Array(workers).fill(iter).map(async (iter: ArrayIterator<T>) => {
    for (const v of iter) {
      await work(v);
    }
  });
  // Wait for workers to complete their job.
  await Promise.all(jobs);
}

// Generates the lesson id (the path on the website) from the file path.
function idFromRelPath(relPath: string): string {
  return path
    .relative(DOCS_PATH, relPath)
    .replace(/\.typ$/, "") // Remove '.typ' extension.
    .split(path.sep)
    .join("/"); // Ensure that paths are joined with '/' and not '\'.
}

// Checks if the path points to a typst file that needs to end up being a page,
// so it excludes imported files like frames and templates.
function isTypstPageFile(absOrRelPath: string): boolean {
  const relPath = path.relative(DOCS_PATH, absOrRelPath);
  const insideDocs = !relPath.startsWith(`..${path.sep}`);
  // Exclude templates and frames.
  const excludePatterns = /^(_templates\/.+)|(.+\/frames\/.+)/;
  return insideDocs && relPath.endsWith(".typ") && !relPath.match(excludePatterns);
}

// Removes some verbose logs that have been verified to be harmless.
function filterTypstLogs(logs: string): string {
  return logs
    .split("\n\n")
    .filter((g) => !g.startsWith("warning: html export is under active development and incomplete"))
    .filter((g) => !g.startsWith("warning: elem was ignored during paged export"))
    .filter(
      (g) =>
        !(
          g.startsWith("warning: elem may not occur inside of a paragraph and was ignored") &&
          g.includes('html.elem("span", attrs: (class: "not-content"), it)')
        ),
    )
    .join("\n\n");
}

// Map from dependency file to a list of files that depend on it.
// Stale set entries are not cleaned if removed, but it's a small price to pay
// for simplicity.
// Each file is also a dependency of itself to simplify reload logic.
const depsMap = new Map<string, Set<string>>();

function addDependentFiles(absOrRelPath: string, dependencyPath: string): void {
  const relPath = path.relative(".", absOrRelPath);
  const set = depsMap.getOrInsert(dependencyPath, new Set());
  set.add(relPath);
}

function getDependentFiles(absOrRelPath: string): string[] {
  const relPath = path.relative(".", absOrRelPath);
  const set = depsMap.get(relPath);
  return set?.values().toArray() ?? [];
}

function removeDependentFiles(absOrRelPath: string): void {
  for (const set of depsMap.values()) {
    set.delete(path.relative(".", absOrRelPath));
  }
}

// Letting typst download packages inside the parallelLimit loop resulted in:
//
// - duplicate work: if the cache wasn't populated and two or more files
//   required the same package then both would download it;
// - concurrency issues: after downloading the package, both processes would
//   write to the cache and the second one would fail;
//
// Solution: scan all files for dependencies and download them before.
async function typstWarmCache(context: LoaderContext, modules: (() => Promise<{ default: string }>)[]): Promise<void> {
  const { logger } = context;

  const deps = new Set<string>();
  const child = spawn("typst", ["compile", ...TYPST_COMPILE_ARGS, "-", "-"]);
  const REMOTE_DEPENDENCY_REGEX = /^#import "(@preview\/.+)"$/gm;

  await Promise.all(
    modules.map(async (m) => {
      const content = await m();
      const matches = content.default.matchAll(REMOTE_DEPENDENCY_REGEX);

      for (const m of matches) {
        deps.add(m[1]);
      }
    }),
  );

  logger.info("Warming typst package cache");

  const file = deps.values().reduce((a, b) => `${a}#import "${b}"\n`, "");
  child.stdin.write(file);
  child.stdin.end();

  const [stderr] = await Promise.all([text(child.stderr), new Promise((resolve) => child.once("close", resolve))]);

  const logs = filterTypstLogs(stderr);
  if (logs) {
    logger.warn(logs);
  }
}

// Compiles the typst document, returning the HTML output.
async function typstCompile(context: LoaderContext, relPath: string): Promise<string> {
  const { logger } = context;

  const child = spawn("typst", ["compile", ...TYPST_COMPILE_ARGS, relPath, "-"]);

  const [stdout, stderr] = await Promise.all([
    text(child.stdout),
    text(child.stderr),
    new Promise((resolve) => child.once("close", resolve)),
  ]);

  const logs = filterTypstLogs(stderr);
  if (logs) {
    logger.warn(logs);
  }

  // Capture group avoids matching a <body> tag with attributes as "no match",
  // and extracts only the inner content so we don't nest <body> inside Starlight's.
  const match = stdout.match(/<body[^>]*>([\s\S]*?)<\/body>/i);
  if (!match) {
    throw new Error("typst cli didn't output expected html");
  }
  return match[1];
}

// Gets local dependency paths of the given typst file.
async function typstGetLocalDeps(context: LoaderContext, relPath: string): Promise<string[]> {
  const { logger } = context;

  const child = spawn("typst", [
    "compile",
    ...TYPST_COMPILE_ARGS,
    relPath,
    "/dev/null",
    "--deps=-",
    "--deps-format=json",
  ]);

  const [stdout, stderr] = await Promise.all([
    text(child.stdout),
    text(child.stderr),
    new Promise((resolve) => child.once("close", resolve)),
  ]);

  const logs = filterTypstLogs(stderr);
  if (logs) {
    logger.warn(logs);
  }

  const stdoutParsed = JSON.parse(stdout);
  // Exclude packages downloaded automatically by typst.
  if (typeof stdoutParsed === "object" && Array.isArray(stdoutParsed?.inputs)) {
    return stdoutParsed.inputs.filter((d: unknown) => typeof d === "string" && !d.includes("typst/packages/"));
  } else {
    throw new Error("typst compile deps stdout malformed");
  }
}

// Extracts metadata from the typst file.
async function typstGetMetadata(context: LoaderContext, relPath: string): Promise<Record<string, unknown>> {
  const { logger } = context;

  const child = spawn("typst", ["eval", ...TYPST_ARGS, "--in", relPath, "query(metadata).map(it => it.value)"]);

  const [stdout, stderr] = await Promise.all([
    text(child.stdout),
    text(child.stderr),
    new Promise((resolve) => child.once("close", resolve)),
  ]);

  const logs = filterTypstLogs(stderr);
  if (logs) {
    logger.warn(logs);
  }

  const metadata = {};
  const stdoutParsed = JSON.parse(stdout);
  if (Array.isArray(stdoutParsed)) {
    for (const fragment of stdoutParsed) {
      Object.assign(metadata, fragment);
    }
  } else {
    throw new Error("typst metadata eval stdout malformed");
  }

  return metadata;
}

async function syncTypstDocEntry(context: LoaderContext, absOrRelPath: string): Promise<void> {
  const { logger, parseData, store, watcher } = context;
  const relPath = path.relative(".", absOrRelPath);
  const id = idFromRelPath(relPath);

  const html = await typstCompile(context, absOrRelPath);
  const dependenciesPaths = await typstGetLocalDeps(context, absOrRelPath);
  const metadata = await typstGetMetadata(context, absOrRelPath);

  for (const p of dependenciesPaths) {
    watcher?.add(path.resolve(p));
    addDependentFiles(absOrRelPath, p);
  }

  logger.info(`Compiled ${id}`);

  store.set({
    id,
    data: await parseData({ id, data: metadata }),
    filePath: relPath,
    rendered: { html },
  });
}

async function loadTypstDocs(context: LoaderContext): Promise<void> {
  const { logger, store, watcher } = context;

  const modules = import.meta.glob<{ default: string }>("./src/content/docs/**/*.typ", {
    query: "?raw",
    eager: false,
    base: "/",
  });

  // Download remote packages. Need to do it only at the start, since
  // recompiling on changes usually involves only one file and otherwise can be
  // retried.
  await typstWarmCache(context, Object.values(modules));

  // Compile the files, running them with Promise.all resulted in errors due to
  // too many programs spawned, so we limit concurrency now.
  const typstPagePaths = Object.keys(modules).filter(isTypstPageFile);
  logger.info(`Compiling ${typstPagePaths.length} typst files`);
  await parallelLimit(CPUS, typstPagePaths, (path) => syncTypstDocEntry(context, path));

  watcher?.on("change", async (absPath: string) => {
    await parallelLimit(CPUS, getDependentFiles(absPath), (path) => syncTypstDocEntry(context, path));
  });

  watcher?.on("add", async (absPath) => {
    if (isTypstPageFile(absPath)) {
      await syncTypstDocEntry(context, absPath);
    }
  });

  watcher?.on("unlink", (absPath) => {
    removeDependentFiles(absPath);
    store.delete(idFromRelPath(absPath));
  });
}

export const collections = {
  courses: defineCollection({
    // Courses are stored in a flat `[course]/course.json` layout. Deeper files
    // are remnants of the old `[year]/[semester]/[code]` structure and are
    // ignored until they are migrated.
    loader: glob({ pattern: "*/course.json", base: DOCS_PATH }),
    schema: z.object({
      code: z.string().length(6),
      name: z.string().nonempty(),
      lang: z.enum(["en", "it"]),
      professors: z.array(z.string().nonempty()),
    }),
  }),
  docs: defineCollection({
    loader: { name: "typst-starlight-loader", load: loadTypstDocs },
    schema: docsSchema({ extend: z.object({ lang: z.enum(["en", "it"]) }) }),
  }),
};
