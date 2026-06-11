import starlight from "@astrojs/starlight";
import { defineConfig } from "astro/config";
import { unified } from "@astrojs/markdown-remark";
import rehypeKatex from "rehype-katex";
import remarkMath from "remark-math";

const sidebar = [
  {
    label: "First year",
    items: [
      {
        label: "First semester",
        items: [
          {
            label: "Analisi 1",
            collapsed: true,
            items: [{ autogenerate: { directory: "1/1/145403" } }],
          },
          {
            label: "Geometria e algebra lineare",
            collapsed: true,
            items: [{ autogenerate: { directory: "1/1/145405" } }],
          },
        ],
      },
      {
        label: "Second Semester",
        items: [
          {
            label: "Analisi 2",
            collapsed: true,
            items: [{ autogenerate: { directory: "1/2/140017" } }],
          },
          {
            label: "Calcolo delle probabilità e statistica",
            collapsed: true,
            items: [{ autogenerate: { directory: "1/2/145805" } }],
          },
        ],
      },
    ],
  },
  {
    label: "Second year",
    items: [
      {
        label: "First semester",
        items: [
          {
            label: "Elaborazione dei segnali",
            collapsed: true,
            items: [{ autogenerate: { directory: "2/1/146128-2" } }],
          },
          {
            label: "Fisica 2",
            collapsed: true,
            items: [{ autogenerate: { directory: "2/1/145821" } }],
          },
          {
            label: "Introduzione al machine learning",
            collapsed: true,
            items: [{ autogenerate: { directory: "2/1/146309-1" } }],
          },
          {
            label: "Reti",
            collapsed: true,
            items: [{ autogenerate: { directory: "2/1/146128-1" } }],
          },
          {
            label: "Reti Logiche",
            collapsed: true,
            items: [{ autogenerate: { directory: "2/1/146129-1" } }],
          },
        ],
      },
      {
        label: "Second Semester",
        items: [
          {
            label: "Calcolatori",
            collapsed: true,
            items: [{ autogenerate: { directory: "2/2/146309-2" } }],
          },
          {
            label: "Circuiti elettronici digitali",
            collapsed: true,
            items: [{ autogenerate: { directory: "2/2/146129-2" } }],
          },
          {
            label: "Operating systems",
            collapsed: true,
            items: [{ autogenerate: { directory: "2/2/146147" } }],
          },
          {
            label: "Organizzazione e gestione aziendale",
            collapsed: true,
            items: [{ autogenerate: { directory: "2/2/145822" } }],
          },
        ],
      },
    ],
  },
];

export default defineConfig({
  integrations: [
    starlight({
      customCss: [
        "katex/dist/katex.css",
        "./src/styles/code-blocks.css",
        "./src/styles/math-blocks.css",
        "./src/styles/list-markers.css",
      ],
      description:
        "Collection of course notes from the ICE (Information, Communications and Electronics) engineering program at the University of Trento.",
      editLink: {
        baseUrl: "https://git.zarantonello.dev/university/notes/_edit/main",
      },
      sidebar,
      head: [
        { tag: "link", attrs: { rel: "icon", type: "image/svg+xml", href: "/favicon.svg" } },
        { tag: "link", attrs: { rel: "icon", type: "image/png", sizes: "96x96", href: "/favicon-96x96.png" } },
        { tag: "link", attrs: { rel: "icon", type: "image/x-icon", href: "/favicon.ico" } },
        { tag: "link", attrs: { rel: "apple-touch-icon", type: "image/png", href: "/apple-touch-icon.png" } },
        { tag: "link", attrs: { rel: "manifest", href: "/site.webmanifest" } },
        { tag: "meta", attrs: { name: "theme-color", content: "f6f7f9", media: "(prefers-color-scheme: light)" } },
        { tag: "meta", attrs: { name: "theme-color", content: "23263f", media: "(prefers-color-scheme: dark)" } },
        { tag: "link", attrs: { rel: "sitemap", href: "/sitemap-index.xml" } },
        {
          // Umami metrics.
          tag: "script",
          attrs: {
            defer: true,
            src: "https://metrics.zarantonello.dev/script.js",
            "data-website-id": "cbc8ce81-6981-40c5-af36-08d8639742d5",
            // Use only when deployed.
            "data-domains": "ice-notes.zarantonello.dev",
          },
        },
      ],
      social: [
        {
          href: "https://git.zarantonello.dev/university/notes",
          icon: "seti:git",
          label: "Source code",
        },
      ],
      title: "ICE notes",
    }),
  ],
  markdown: {
    processor: unified({
      rehypePlugins: [
        [
          rehypeKatex,
          {
            macros: {
              // Shorthands.
              "\\dv": "\\frac{d #1}{d #2}", // First degree derivative.
              "\\dvn": "\\frac{d^{#1} #2}{d #3^{#1}}", // Arbitrary degree derivative.
              "\\pdv": "\\frac{\\partial #1}{\\partial #2}", // First degree partial derivative.
              "\\pdvn": "\\frac{\\partial^{#1} #2}{\\partial #3^{#1}}", // Arbitrary degree partial pure derivative.
              "\\C": "\\mathbb{C}", // Complex numbers set.
              // Various operators.
              "\\Re": "\\text{Re}\\left[#1\\right]", // Real part of complex number.
              "\\Im": "\\text{Im}\\left[#1\\right]", // Immaginary part of complex number.
              "\\Z0": "Z_0\\left[#1\\right]", // Response of a circuit.
              "\\arg": "\\text{arg}\\left(#1\\right)", // Argument of a complex number.
              // Various functions.
              "\\fRectangle": "\\Pi\\!\\left(#1\\right)", // Rectangle from signal processing.
              "\\fThriangle": "\\Lambda\\!\\left(#1\\right)", // Thriangle from signal processing.
              "\\fSign": "s\\!\\left(#1\\right)", // Sign function.
              "\\fStep": "\\theta\\!\\left(#1\\right)", // Step function.
              "\\fDelta": "\\delta\\!\\left(#1\\right)", // Dirac delta function.
              "\\fLog": "\\text{log}\\!\\left(#1\\right)", // Logarithm.
              "\\fLogn": "\\text{log}_{#1}\\!\\left(#2\\right)", // Logarithm.
              "\\fLn": "\\text{log}\\!\\left(#1\\right)", // Natural logarithm.
              "\\fP": "\\mathbb{P}\\!\\left(#1\\right)", // Probability.
              // Angular functions with adaptive parentheses.
              "\\fArctan": "\\text{arctan}\\!\\left(#1\\right)",
              "\\fCos": "\\text{cos}\\!\\left(#1\\right)",
              "\\fSinc": "\\text{sinc}\\!\\left(#1\\right)",
              "\\fSin": "\\text{sin}\\!\\left(#1\\right)",
              "\\fTan": "\\text{tan}\\!\\left(#1\\right)",
              // Transform notation with double arrow.
              "\\trFourierA": "\\xleftrightarrow{\\mathcal{F}}",
              "\\trFourierB": "\\mathcal{F}\\left\\{#1\\right\\}",
              "\\trLaplaceA": "\\xleftrightarrow{\\mathcal{L}}",
              "\\trLaplaceB": "\\mathcal{L}\\left\\{#1\\right\\}",
            },
          },
        ],
      ],
      remarkPlugins: [remarkMath],
    }),
  },
  site: "https://ice-notes.zarantonello.dev",
});
