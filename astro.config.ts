import starlight from "@astrojs/starlight";
import { defineConfig } from "astro/config";

export default defineConfig({
  // Used to cache image optimization output to a volume.
  cacheDir: process.env.CI ? "/astro" : undefined,
  image: {
    responsiveStyles: true,
    layout: "constrained",
  },
  integrations: [
    starlight({
      customCss: ["./src/styles/code-blocks.css", "./src/styles/math-blocks.css", "./src/styles/list-markers.css"],
      description:
        "Collection of course notes from the ICE (Information, Communications and Electronics) engineering program at the University of Trento.",
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
  site: "https://ice-notes.zarantonello.dev",
});
