# ICE Notes

Welcome to my collection of course notes from the **ICE (Information,
Communications and Electronics) engineering program** at the
[University of Trento](https://www.disi.unitn.it/). I'm currently in my second
year, documenting my academic journey as I progress through various courses.

These notes serve multiple purposes:

- **Personal reference** for exam preparation and concept review
- **Knowledge sharing** with fellow students
- **Community resource** for anyone interested in the topics covered

## Project structure

```
src/
├── content/
│   └── docs/
│       ├── _templates/         # Shared Typst helpers (never rendered as notes)
│       │   └── starlight.typ
│       └── [course]/           # One folder per course
│           ├── course.json     # Course metadata
│           ├── images/         # Images used by the notes
│           └── YYYY-MM-DD.typ  # Note content
├── pages/
│   ├── index.astro             # Homepage with course listings
│   └── [course]/
│       ├── index.astro         # Course page with the list of lessons
│       └── [date].astro        # Rendered lesson
├── components/                 # Reusable UI components
├── styles/                     # Global styles
└── fonts/                      # Fonts used by the rendered math
```

### Notes format

Notes are written in [Typst](https://typst.app/) (`.typ`), not Markdown. A
shared `_templates/starlight.typ` module provides the `setup` show rule (math
polyfills and Starlight overrides) plus the `note`/`tip`/`caution`/`danger`
helpers. Each note starts with an import and a metadata block, for example:

```typst
#import("../_templates/starlight.typ") as starlight

#show: starlight.setup

#metadata((
  lang: "it",
  title: "Segnali, tecnologie di implementazione e booleani",
  description: "...",
  prev: false,
))
```

The custom `typst` content loader in `src/content.config.ts` compiles every
`.typ` file to HTML with the `typst` CLI at build time (and on file changes in
dev mode). Math follows Typst syntax: inline math is `$x$`, display math is
`$ x $` (spaces around the expression).

## Contributing

I welcome contributions! If you find errors, have suggestions for improvements,
or would like to new features to the website, please help out.

If you want to upstream your changes:

1. **Request Access**:
   - Create an account on [git.zarantonello.dev](https://git.zarantonello.dev).
   - Send an email to [git@zarantonello.dev](mailto:git@zarantonello.dev) to
     request approval for the account.
2. **Make Changes**: Fork the repository and create a new branch.
3. **Submit Corrections**: Push your changes and open a pull request.

### Language policy

Most of the initial courses are taught in **Italian**, while later courses
transition to **English**. I keep the notes in their original language to
preserve technical accuracy and avoid translation errors.

### Development environment

For a consistent development experience, this project includes a devcontainer
setup. You can open the project in [VS Code](https://code.visualstudio.com) or
[Zed](https://zed.dev) to automatically get all required dependencies
configured.

Alternatively, follow the manual installation steps below.

#### Prerequisites

- [Node.js](https://nodejs.org/)
- [pnpm](https://pnpm.io/)
- [Typst](https://typst.app/) (v0.15+, required to compile the notes; already
  included in the devcontainer and CI images)

#### Installation

1. Clone the repository

   ```bash
   git clone https://git.zarantonello.dev/university/notes
   cd notes
   ```

2. Install dependencies

   ```bash
   pnpm install
   ```

3. Start the development server

   ```bash
   pnpm dev
   ```

4. Open your browser and visit `http://localhost:4321` to view the site locally.

#### Available scripts

| Command             | Description                              |
| ------------------- | ---------------------------------------- |
| `pnpm dev`          | Start development server with hot reload |
| `pnpm build`        | Build production site                    |
| `pnpm check`        | Type-check with Astro's built-in checker |
| `pnpm lint:check`   | Run Biome linter                         |
| `pnpm lint:fix`     | Auto-fix linting issues                  |
| `pnpm format:check` | Check code formatting                    |
| `pnpm format:fix`   | Auto-fix formatting issues               |
| `pnpm clean`        | Remove build artifacts                   |

### What you can help with

- Correcting typos and grammatical errors;
- Improving explanations and adding examples;
- Adding missing course notes;
- Suggesting new features or improvements;

## AI

Content is human-written and AI-reviewed. Review skills are located in
`.agents/skills/`:

- `document-content-review`: factual/logical errors
- `document-grammar-review`: grammar, spelling, style
- `document-description`: frontmatter title/description generation

## License

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/).
Feel free to share and adapt these notes for non-commercial purposes, provided
you give appropriate credit and license your contributions under identical
terms.

## Links

- DISI Department: [https://disi.unitn.it](https://disi.unitn.it)
- ICE Course:
  [https://corsi.unitn.it/en/computer-communications-and-electronic-engineering](https://corsi.unitn.it/en/computer-communications-and-electronic-engineering)
