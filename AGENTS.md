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

Order when verifying: `lint:check → format:check → check → build`

## Content structure

```
src/content/docs/[year]/[semester]/[course-code]/
    course.json        # { code, name, professors[] }
    YYYY-MM-DD.md      # Individual lecture notes
```

- Sidebar is hardcoded in `astro.config.ts` (not auto-discovered)
- New courses require adding an `autogenerate` entry in the sidebar array
- Note frontmatter: `lang`, `title`, `prev` (Starlight fields)

## Math / KaTeX

- Rendered by KaTeX (not full LaTeX) – verify compatibility at
  https://github.com/KaTeX/KaTeX/raw/refs/heads/main/docs/support_table.md
- Custom macros defined in `astro.config.ts` under `rehypeKatex.macros`: `\dv`,
  `\dvn`, `\pdv`, `\pdvn`, `\C`, `\Re`, `\Im`, `\Z0`, `\arg`, `\fRectangle`,
  `\fThriangle`, `\fSign`, `\fStep`, `\fDelta`, `\fLog`, `\fLogn`, `\fLn`,
  `\fP`, `\fArctan`, `\fCos`, `\fSinc`, `\fSin`, `\fTan`, `\trFourierA`,
  `\trFourierB`, `\trLaplaceA`, `\trLaplaceB`
- The latex-review skill marks these as **deprecated** – prefer standard LaTeX
  equivalents when reviewing documents.
- Display math: `$$ ... $$`. Inline math: `$ ... $`.

## Tooling quirks

- **Two formatters**: Biome (JS/TS) + Prettier (`.astro`, `.md`). Run both.
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

- `document-content-review` – factual/logical errors
- `document-grammar-review` – grammar, spelling, style
- `document-latex-review` – KaTeX formatting, spacing, notation
- `document-description` – frontmatter title/description generation

## Language policy

Notes are written in the language of instruction (Italian for early courses,
English for later courses). Never translate notes between languages.
