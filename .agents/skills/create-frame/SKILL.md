---
name: create-frame
description: Create and verify Typst/Cetz visualization frames for course notes
---

You are creating **visualization frames** for the Typst course notes in
`src/content/docs/<course>/frames/`, then including them in the right lessons.

Run all commands from the repository root.

## Objective

For each concept that genuinely benefits from a diagram:

1. Create a standalone frame file.
2. Include it in the lesson next to the relevant explanation.
3. Compile and visually verify it in a real browser.
4. Format the Typst sources.

Do not add figures for purely algorithmic or symbolic content where a matrix or
formula is already clearer. Prefer diagrams for geometry, vectors, planes,
spans, projections, eigenspaces, etc.

## Frame file template

Create `src/content/docs/<course>/frames/<slug>.typ`:

```typst
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#let draw() = {
  import cetz.draw: *

  // ---- Helpers ----
  let label-at(pos, c, body, anchor: "center", padding: 0) = content(
    pos,
    anchor: anchor,
    padding: padding,
    text(fill: c, body),
  )
  let arrow(from, to, c, thickness) = line(
    from,
    to,
    stroke: (paint: c, thickness: thickness),
    mark: (end: ">", fill: c),
  )
  let axes2d(x-len, y-len, c) = {
    arrow((0, 0), (x-len, 0), c, 0.4pt)
    arrow((0, 0), (0, y-len), c, 0.4pt)
    label-at((x-len, 0), c, $x$, anchor: "west", padding: 0.1)
    label-at((0, y-len), c, $y$, anchor: "south", padding: 0.1)
  }

  // ---- Colors: always HSL with lightness 50% ----
  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-primary = color.hsl(210deg, 50%, 50%)
  let c-secondary = color.hsl(150deg, 50%, 50%)
  let c-highlight = color.hsl(30deg, 60%, 50%)

  // ... drawing ...
}

#starlight.frame(
  cetz.canvas(draw()),
)
```

For 3D:

```typst
#starlight.frame(
  cetz.canvas(
    cetz.draw.perspective(
      y: 150deg,
      z: 180deg,
      x: -15deg,
      cetz.draw.on-xz(draw()),
    ),
  ),
)
```

Frames are excluded from the content loader by the `frames/` path check, so they
are only rendered when included from a lesson.

## Include in the lesson

Use:

```typst
#include "frames/<slug>.typ"
```

- Put the include **after** the concept it illustrates is introduced.
- Do not put it inside a list, table, math block, or aside.
- Keep a blank line before and after.
- If a figure shows `op("pr")`, `ker`, `operatorname`-style notation, include it
  after that notation has been defined.
- The figure may use the lesson's exact notation and example values, but do not
  add unmentioned facts. If the figure is a generic example, keep labels
  generic.
- Use `starlight.frame(...)`, not `figure(...)`. Use a real Typst `figure` only
  when a caption is genuinely necessary.

## Context-fit checklist

Before writing the frame, read the surrounding section and check:

- The figure uses the **same notation** as the lesson (`bold(v)`, `arrow(A B)`,
  `ker(f)`, `op("Im")`, `op("pr")`, etc.).
- The figure does not introduce a fact, formula, or symbol that the text has not
  defined yet.
- If the figure uses the lesson's example values, they match the text; if they
  are generic, the labels stay generic and do not imply specific coordinates.
- The include is placed after the concept is introduced; if the figure uses
  `op("pr")` or `ker`, it belongs after those definitions.
- Labels do not simply duplicate a formula that is already directly below the
  figure.

If the figure would be clearer with a different example, use one but keep its
labels generic.

## Visual conventions

- All colors must use `color.hsl(hue, saturation, 50%)`; do not use other
  lightness values.
- Use one consistent color per role: axes gray, first object blue, second green,
  highlight orange, distance/dashed accent pink, etc.
- Use transparent fills for planes: `c.transparentize(90%)`.
- Use dashed/dotted lines for hidden or auxiliary objects, projections, and
  boundaries.
- Label axes and important points/vectors. Avoid redundant labels:
  - Do not label both a set and all its elements if it becomes cluttered.
  - Do not repeat a formula in a crowded diagram when the surrounding text
    already states it.
- Make labels readable: offset them from markers, anchor them away from lines,
  and spread them along long geometry.
- For 3D, check the projection: axes ranges must contain the drawing and labels
  should not overlap after perspective.

### Important: math-symbol shadowing

Local variables shadow bare math symbols. For example:

```typst
let alpha = 35deg
label-at(..., $alpha$) // renders 35deg, not α
```

Avoid local names that are bare math symbols used in labels, including `alpha`,
`perp`, `pi`, `lambda`, etc. Rename them:

```typst
let rot = 35deg  // then $alpha$ still renders α
let perp-dir = (-1, 2.6) // then $S^perp$ still renders S^⊥
```

`$bold(v)$` is generally safe even if `v` is a local array because `bold` takes
content, but bare identifiers in superscripts/subscripts are evaluated.

## Verify

### 1. Format

```bash
typstyle --wrap-text --inplace src/content/docs/<course>
typstyle --wrap-text --check src/content/docs/<course>
```

### 2. Compile frames and lessons

Compile each frame standalone:

```bash
for f in src/content/docs/<course>/frames/*.typ; do
  typst compile --root src/content/docs --features html --format html "$f" /tmp/frame.html
done
```

Compile every lesson that includes frames:

```bash
for f in src/content/docs/<course>/*.typ; do
  typst compile --root src/content/docs --features html --format html "$f" /tmp/lesson.html
done
```

Warnings about `html export is under active development` are expected. Any error
must be fixed.

### 3. Browser verification

Do **not** trust paged PNG export or generic SVG rasterizers for Cetz frames:
they can misrender dashes, labels, and symbols. Verify in Chromium.

On Alpine, install Chromium and Playwright:

```bash
apk add --no-cache chromium

mkdir -p /tmp/browser-test
cd /tmp/browser-test
npm init -y >/dev/null 2>&1
npm install playwright >/dev/null 2>&1
```

No `npx playwright install chromium` is needed: use the system Chromium at
`/usr/bin/chromium`.

Compile all frames to HTML first, from the repo root:

```bash
mkdir -p /tmp/frames-html
for f in src/content/docs/<course>/frames/*.typ; do
  n=$(basename "$f" .typ)
  typst compile --root src/content/docs --features html --format html "$f" "/tmp/frames-html/$n.html"
done
```

Create `/tmp/browser-test/shots.mjs`:

```js
import fs from "fs";
import { chromium } from "playwright";

const dir = "/tmp/frames-html";
const out = "/tmp/frames-html/shots";
fs.mkdirSync(out, { recursive: true });

const files = fs
  .readdirSync(dir)
  .filter((f) => f.endsWith(".html"))
  .sort();
const browser = await chromium.launch({
  executablePath: "/usr/bin/chromium",
  args: ["--no-sandbox"],
});
const page = await browser.newPage({
  deviceScaleFactor: 2,
  viewport: { width: 1000, height: 800 },
});

for (const f of files) {
  const n = f.replace(/\.html$/, "");
  await page.goto(`file://${dir}/${f}`, { waitUntil: "load" });
  await page
    .locator("svg")
    .first()
    .screenshot({ path: `${out}/${n}.png` });
}

await browser.close();
console.log("done", files.length);
```

Run it:

```bash
cd /tmp/browser-test
node shots.mjs
```

Inspect the screenshots under `/tmp/frames-html/shots/`. Check specifically for:

- labels overlapping each other or markers;
- labels clipped outside the canvas;
- missing axes, arrows, fills, or dashed lines;
- wrong perspective (objects outside the intended axes range);
- labels showing raw numbers instead of math symbols (shadowing bug above);
- figures that no longer match the surrounding notation or example values.

Fix layout by:

- moving labels with anchors/offsets;
- scaling the geometry or axes range;
- splitting a crowded figure into simpler pieces;
- removing labels that duplicate the surrounding text.

Recompile and re-screenshot after every change.

### 4. Final build

```bash
pnpm build
```
