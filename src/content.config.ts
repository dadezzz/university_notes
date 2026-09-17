import { defineCollection } from "astro:content";
import { docsSchema } from "@astrojs/starlight/schema";
import { glob, type Loader, type LoaderContext } from "astro/loaders";
import { z } from "astro/zod";
import * as child_process from "node:child_process";
import path from "node:path";
import { promisify } from "node:util";

const SRC_PATH = "./src";
const DOCS_PATH = `${SRC_PATH}/content/docs`;
const DOCS_ABS_PATH = path.resolve(DOCS_PATH);

const COMMON_TYPST_ARGS = ["--root", SRC_PATH, "--features", "html"];

// Captured HTML can get large because Typst inlines images as data URIs, so the
// default 1 MiB buffer of `execFile` is not enough.
const EXEC_OPTIONS = { maxBuffer: 64 * 1024 * 1024 };

const execFile = promisify(child_process.execFile);

function idFromAbsolutePath(absPath: string): string {
  const rel = path.relative(DOCS_ABS_PATH, absPath);
  return rel
    .replace(/\.typ$/, "")
    .split(path.sep)
    .join("/");
}

function isTypstFile(absPath: string): boolean {
  // Compare against the directory itself and its separator so that a sibling
  // such as `docs-extra/` is not mistaken for the docs directory.
  const insideDocs = absPath === DOCS_ABS_PATH || absPath.startsWith(DOCS_ABS_PATH + path.sep);
  return insideDocs && absPath.endsWith(".typ");
}

async function compileTypst(context: LoaderContext, filePath: string): Promise<string> {
  const { logger } = context;

  const { stderr, stdout } = await execFile(
    "typst",
    ["compile", ...COMMON_TYPST_ARGS, "--format", "html", filePath, "-"],
    EXEC_OPTIONS,
  );

  if (stderr) {
    logger.warn(stderr);
  }

  // Capture group avoids matching a <body> tag with attributes as "no match",
  // and extracts only the inner content so we don't nest <body> inside Starlight's.
  const match = stdout.match(/<body[^>]*>([\s\S]*?)<\/body>/i);
  if (!match) {
    throw new Error("typst cli didn't output expected html");
  }
  return match[1];
}

async function getMetadata(context: LoaderContext, filePath: string): Promise<Record<string, unknown>> {
  const { logger } = context;

  const { stderr, stdout } = await execFile(
    "typst",
    ["eval", ...COMMON_TYPST_ARGS, "--in", filePath, "query(metadata).map(it => it.value)"],
    EXEC_OPTIONS,
  );

  if (stderr) {
    logger.warn(stderr);
  }

  const metadataMerged = {};
  const metadataFragments = Array.from(JSON.parse(stdout));
  for (const fragment of metadataFragments) {
    Object.assign(metadataMerged, fragment);
  }

  return metadataMerged;
}

async function getImagePaths(context: LoaderContext, filePath: string): Promise<string[]> {
  const { logger } = context;

  const { stderr, stdout } = await execFile(
    "typst",
    ["eval", ...COMMON_TYPST_ARGS, "--in", filePath, "query(image).map(i => i.source)"],
    EXEC_OPTIONS,
  );

  if (stderr) {
    logger.warn(stderr);
  }

  try {
    const paths: string[] = JSON.parse(stdout);
    return paths.filter((p) => typeof p === "string" && !p.startsWith("http")).map((p) => path.relative(".", p));
  } catch {
    return [];
  }
}

export async function syncTypstDocEntry(context: LoaderContext, absPath: string): Promise<void> {
  const { store, parseData, logger } = context;
  const id = idFromAbsolutePath(absPath);

  // The `_templates` folder contains Typst modules that hold polyfills and HTML
  // overrides needed by the conversion, not documents, so they must not become
  // entries themselves.
  if (id.startsWith("_templates/")) {
    return;
  }

  try {
    const html = await compileTypst(context, absPath);
    const metadata = await getMetadata(context, absPath);
    const imagePaths = await getImagePaths(context, absPath);

    store.set({
      id,
      data: await parseData({ id, data: metadata }),
      filePath: path.relative(".", absPath),
      rendered: { html, metadata: { imagePaths } },
    });
  } catch (error) {
    logger.error(`failed to compile ${id}: ${error}`);
  }
}

export async function loadTypstDocs(context: LoaderContext): Promise<void> {
  const { store, watcher } = context;

  // Used purely to enumerate matching files: the module values are never
  // imported (eager: false), only the keys are used. Every entry point (initial
  // scan, change, add) then goes through the same `syncTypstDocEntry` path.
  const modules = import.meta.glob<string>("./**/*.typ", {
    query: "?raw",
    import: "default",
    eager: false,
    base: "/src/content/docs",
  });

  await Promise.all(
    Object.keys(modules).map((filePath) => {
      return syncTypstDocEntry(context, path.resolve(DOCS_ABS_PATH, filePath));
    }),
  );

  // Vite's dev-server watcher already covers the whole project tree by
  // default, so no explicit watcher.add() is needed here. Registering these
  // listeners naively on every load() is safe because context.watcher is the
  // Proxy-wrapped instance that detaches a previous run's listeners for us.
  watcher?.on("change", async (changedPath) => {
    if (isTypstFile(changedPath)) {
      await syncTypstDocEntry(context, changedPath);
    }
  });

  watcher?.on("add", async (addedPath) => {
    if (isTypstFile(addedPath)) {
      await syncTypstDocEntry(context, addedPath);
    }
  });

  watcher?.on("unlink", (removedPath) => {
    if (isTypstFile(removedPath)) {
      store.delete(idFromAbsolutePath(removedPath));
    }
  });
}

export function typstLoader(): Loader {
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
      lang: z.string(),
      professors: z.array(z.string().nonempty()),
    }),
  }),
  docs: defineCollection({
    loader: typstLoader(),
    schema: docsSchema({ extend: z.object({ lang: z.string() }) }),
  }),
};
