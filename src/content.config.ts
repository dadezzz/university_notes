import { defineCollection } from "astro:content";
import * as child_process from "node:child_process";
import path from "node:path";
import { promisify } from "node:util";
import { docsSchema } from "@astrojs/starlight/schema";
import { glob, type Loader, type LoaderContext } from "astro/loaders";
import { z } from "astro/zod";

const execFile = promisify(child_process.execFile);

const SRC_PATH = "./src";
const DOCS_PATH = `${SRC_PATH}/content/docs`;

const COMMON_TYPST_ARGS = ["--root", DOCS_PATH, "--features", "html"];

// Captured HTML can get large because Typst inlines images as data URIs, so the
// default 1 MiB buffer of `execFile` is not enough.
const COMMON_EXEC_OPTIONS = { maxBuffer: 64 * 1024 * 1024 };

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
    ["compile", ...COMMON_TYPST_ARGS, "--format", "html", relPath, "-"],
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

  // Capture group avoids matching a <body> tag with attributes as "no match",
  // and extracts only the inner content so we don't nest <body> inside Starlight's.
  const json = JSON.parse(stdout);
  // Exclude packages downloaded automatically by typst.
  return Array.from<string>(json.inputs).filter((d) => typeof d === "string" && !d.includes("typst/packages/"));
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

function getDependentFiles(absOrRelPath: string): string[] {
  const relPath = path.relative(".", absOrRelPath);
  const set = depsMap.get(relPath);
  return set?.values().toArray() ?? [];
}

async function syncTypstDocEntry(context: LoaderContext, absOrRelPath: string): Promise<void> {
  const { logger, parseData, store, watcher } = context;
  const relPath = path.relative(".", absOrRelPath);
  const id = idFromRelPath(relPath);

  try {
    const html = await typstCompile(context, absOrRelPath);
    const deps = await typstGetDeps(context, absOrRelPath);
    const metadata = await typstGetMetadata(context, absOrRelPath);

    for (const dep of deps) {
      watcher?.add(path.resolve(dep));
      const set = depsMap.getOrInsert(dep, new Set());
      set.add(relPath);
    }

    store.set({
      id,
      data: await parseData({ id, data: metadata }),
      filePath: relPath,
      rendered: { html },
    });
  } catch (error) {
    logger.error(`failed to compile ${id}: ${error}`);
  }
}

async function loadTypstDocs(context: LoaderContext): Promise<void> {
  const { logger, store, watcher } = context;

  // Used purely to enumerate matching files: the module values are never
  // imported (eager: false), only the keys are used. Every entry point (initial
  // scan, change, add) then goes through the same `syncTypstDocEntry` path.
  const modules = import.meta.glob<string>("./src/content/docs/**/*.typ", { query: "?raw", eager: false, base: "/" });
  const typstPaths = Object.keys(modules).filter(isTypstFile);
  logger.info(`Compiling ${typstPaths.length} typst files`);

  // Using Promise.all resulted in errors due to too many processes/threads
  // created.
  for (const relPath of typstPaths) {
    await syncTypstDocEntry(context, relPath);
  }

  async function syncOnDepChange(absPath: string): Promise<void> {
    const deps = getDependentFiles(absPath);

    if (deps.length > 0) {
      logger.info(`Recompiling ${deps.length} files`);
    }

    for (const dep of deps) {
      await syncTypstDocEntry(context, dep);
    }
  }

  // Vite's dev-server watcher already covers the whole project tree by
  // default, so no explicit watcher.add() is needed here. Registering these
  // listeners naively on every load() is safe because context.watcher is the
  // Proxy-wrapped instance that detaches a previous run's listeners for us.
  watcher?.on("change", syncOnDepChange);
  watcher?.on("add", syncOnDepChange);

  watcher?.on("unlink", (absPath) => {
    if (isTypstFile(absPath)) {
      for (const set of depsMap.values()) {
        set.delete(path.relative(".", absPath));
      }

      store.delete(idFromRelPath(absPath));
    }
  });
}

function typstLoader(): Loader {
  return {
    name: "typst-starlight-loader",
    load: loadTypstDocs,
  };
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
    loader: typstLoader(),
    schema: docsSchema({ extend: z.object({ lang: z.enum(["en", "it"]) }) }),
  }),
};
