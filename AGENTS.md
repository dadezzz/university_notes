# AGENTS.md

ICE Notes – Astro + Starlight docs site for university course notes.

## Commands

```
pnpm install          # Install deps
pnpm dev              # Dev server (hot reload, --host flag)
pnpm build            # Production build → dist/
pnpm check            # TypeScript type-check (astro check)
pnpm lint:check       # Biome lint
pnpm lint:fix         # Biome lint --fix
pnpm format:check     # Biome format + Prettier check
pnpm format:fix       # Biome format --fix + Prettier write
pnpm clean            # Remove .astro/, .pnpm-store/, dist/, node_modules/
```

## Content structure

```
src/content/docs/[year]/[semester]/[course-code]/
    course.json        # { code, name, professors[] }
    YYYY-MM-DD.md      # Individual lecture notes
```

- Sidebar is hardcoded in `astro.config.ts` (not auto-discovered)
- New courses require adding an `autogenerate` entry in the sidebar array
- Note frontmatter: `lang`, `title`, `prev` (Starlight fields)

## Math / Typst

- Math is rendered by **Typst** (via the custom `rehype-typst.ts` plugin), not
  KaTeX or LaTeX.
- The plugin shells out to the `typst` CLI (v0.15+) at build time to compile
  each expression to MathML; the CLI is included in the devcontainer and CI
  images.
- Notes use **Typst math syntax** (e.g. `sqrt(...)`, `bb(R)`, `cases(...)`,
  `op("rect")(...)`) instead of LaTeX commands.
- Display math: `$$ ... $$`. Inline math: `$ ... $`.
- Rendering errors are highlighted in red (`.typst-math-error`); CI fails on any
  `typst-error` class in `dist/`.

## Tooling quirks

- **Two formatters**: Biome (JS/TS) + Prettier (`.astro`, `.md`). If asked run
  both with `pnpm format:fix`.
- Prettier uses `proseWrap: "always"` for `.astro` and `.md`.
- Biome HTML formatting is **disabled** for `.astro` files (known issues).
- Biome has `noFloatingPromises` and `noMisusedPromises` as errors.
- `.astro` files: `noUnusedImports` is turned off in Biome.
- `pnpm-workspace.yaml` only sets `allowBuilds` – no workspace packages.

## Deployment

- Dockerfile builds with pnpm, serves `dist/` via Caddy.
- `docker-compose.yaml` deploys behind Traefik (not used locally).
- `.releaserc.json` uses semantic-release on `main` with `commit-analyzer`.

## Review skills

Located under `.agents/skills/`:

- `document-content-review`: factual/logical errors
- `document-grammar-review`: grammar, spelling, style
- `document-description`: frontmatter title/description generation

## Language policy

Notes are written in the language of instruction (Italian for early courses,
English for later courses). Never translate notes between languages.
