import { defineCollection } from "astro:content";
import * as child_process from "node:child_process";
import { cpus } from "node:os";
import path from "node:path";
import { promisify } from "node:util";
import { docsSchema } from "@astrojs/starlight/schema";
import { glob, type LoaderContext } from "astro/loaders";
import { z } from "astro/zod";

const execFile = promisify(child_process.execFile);

const SRC_PATH = "./src";
const DOCS_PATH = `${SRC_PATH}/content/docs`;

const COMMON_TYPST_ARGS = ["--root", DOCS_PATH, "--features", "html"];

// Captured HTML can get large because Typst inlines images as data URIs, so the
// default 1 MiB buffer of `execFile` is not enough.
const COMMON_EXEC_OPTIONS = { maxBuffer: 64 * 1024 * 1024 };
const CPUS = cpus().length;

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

function idFromRelPath(relPath: string): string {
  return path
    .relative(DOCS_PATH, relPath)
    .replace(/\.typ$/, "") // Remove '.typ' extension.
    .split(path.sep)
    .join("/"); // Ensure that paths are joined with '/' and not '\'.
}

function isTypstFile(absOrRelPath: string): boolean {
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

async function typstCompile(context: LoaderContext, relPath: string): Promise<string> {
  const { logger } = context;

  const { stderr, stdout } = await execFile(
    "typst",
    ["compile", ...COMMON_TYPST_ARGS, "--format=html", relPath, "-"],
    COMMON_EXEC_OPTIONS,
  );

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

async function typstGetDeps(context: LoaderContext, relPath: string): Promise<string[]> {
  const { logger } = context;

  const { stderr, stdout } = await execFile(
    "typst",
    ["compile", ...COMMON_TYPST_ARGS, "--format=html", relPath, "/dev/null", "--deps=-", "--deps-format=json"],
    COMMON_EXEC_OPTIONS,
  );

  const logs = filterTypstLogs(stderr);
  if (logs) {
    logger.warn(logs);
  }

  // Exclude packages downloaded automatically by typst.
  return Array.from<string>(JSON.parse(stdout).inputs).filter((d) => !d.includes("typst/packages/"));
}

async function typstGetMetadata(context: LoaderContext, relPath: string): Promise<Record<string, unknown>> {
  const { logger } = context;

  const { stderr, stdout } = await execFile(
    "typst",
    ["eval", ...COMMON_TYPST_ARGS, "--in", relPath, "query(metadata).map(it => it.value)"],
    COMMON_EXEC_OPTIONS,
  );

  const logs = filterTypstLogs(stderr);
  if (logs) {
    logger.warn(logs);
  }

  const metadataMerged = {};
  const metadataFragments = Array.from(JSON.parse(stdout));
  for (const fragment of metadataFragments) {
    Object.assign(metadataMerged, fragment);
  }

  return metadataMerged;
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

async function syncTypstDocEntry(context: LoaderContext, absOrRelPath: string): Promise<void> {
  const { logger, parseData, store, watcher } = context;
  const relPath = path.relative(".", absOrRelPath);
  const id = idFromRelPath(relPath);

  const html = await typstCompile(context, absOrRelPath);
  const dependenciesPaths = await typstGetDeps(context, absOrRelPath);
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

  // Used purely to enumerate matching files: the module values are never
  // imported (eager: false), only the keys are used. Every entry point (initial
  // scan, change, add) then goes through the same `syncTypstDocEntry` path.
  const modules = import.meta.glob<string>("./src/content/docs/**/*.typ", { query: "?raw", eager: false, base: "/" });
  const typstPaths = Object.keys(modules).filter(isTypstFile);

  // Compile the files, running them with Promise.all resulted in errors due to
  // too many programs spawned, so we limit concurrency now.
  logger.info(`Compiling ${typstPaths.length} typst files`);
  await parallelLimit(CPUS, typstPaths, (path) => syncTypstDocEntry(context, path));

  watcher?.on("change", async (absPath: string) => {
    await parallelLimit(CPUS, getDependentFiles(absPath), (path) => syncTypstDocEntry(context, path));
  });

  watcher?.on("add", async (absPath) => {
    if (isTypstFile(absPath)) {
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
