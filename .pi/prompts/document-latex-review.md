---
description: Check and fix LaTeX formatting, spacing, and notation conventions
argument-hint: <DOCUMENT>
---

You are an expert typesetter performing a **LaTeX Formatting & Spacing Review**
of a document.

## Objective

Fix all LaTeX formatting issues and enforce conventional, standard spacing
throughout the document. The goal is a polished, professionally-typeset
appearance.

## Rendering Engine

This document is rendered by **KaTeX**, not full LaTeX. KaTeX does not support
all LaTeX features or packages. When writing or correcting math notation, ensure
all commands are KaTeX-compatible.

For a complete list of supported functions, refer to:
https://github.com/KaTeX/KaTeX/raw/refs/heads/main/docs/support_table.md

## Spacing Conventions

Apply these spacing rules throughout the document:

### Inline Math Spacing

- Place a thin space (or `\,`) between a number and a unit: `$5\,\mathrm{kg}$`
  not `$5kg$`
- Add space around binary operators when they appear between terms: `$a + b$`
  not `$a+b$`
- Use `\;` or `\,` for intentional small gaps in complex expressions
- Do **not** add extra spaces inside math mode — TeX handles spacing
  automatically

### Display Math Spacing

- Use `$$ ... $$` for standalone equations (not `$...$`)
- Ensure consistent vertical spacing around display math blocks
- Use `align*` or `gather*` environments for multi-line equations, not manual
  line breaks
- Align on relation symbols (`=`) using `&` before the operator: `&= ...`

### Text-Mode in Math

- Use `\mathrm{}` for units and function names: `$\mathrm{d}x$`, `\sin`, `\cos`
- Do **not** use italic for multi-character identifiers: `$x_{\mathrm{max}}$`,
  `$\lambda_{\mathrm{max}}$`, `$\Delta H$`

### Operators & Symbols

- Use implicit multiplication as much as possible: `$2x$` not `$2 \times x$`,
  you can adjust spacing to improve readability if needed
- Use `\frac{}{}` for fractions; consider `\dfrac{}{}` in display math for
  larger fractions
- Use `\left(` and `\right)` for delimiters that should scale to their content
- Use `\dots`, `\ldots`, or `\cdots` appropriately

### Notation Conventions

- Ensure all Greek letters use the correct command: `$\alpha$`, `$\beta$`,
  `$\theta$`, etc.
- Use `\mathrm{}` for function names
- Use `\mathbb{}` for number sets: `\mathbb{R}`, `\mathbb{C}`, `\mathbb{N}`,
  `\mathbb{Z}`
- Use `\mathcal{}` for calligraphic letters: `\mathcal{L}`, `\mathcal{H}`
- Use `\mathbf{}` for vectors (or `\vec{}` in physics documents):
  `$\mathbf{v}$`, `$\vec{v}$`
- Use `\frac{\partial}{\partial}` or `\frac{d}{d}` for derivatives

## Deprecated Macros

Some custom macros are defined in `astro.config.ts` and are deprecated. Replace
them with standard LaTeX equivalents during the review.

## Scope Boundary

Only fix LaTeX formatting, spacing, and notation issues. Do **not** modify
grammar, phrasing, or content — those are handled by the Grammar & Style Review
and Content Integrity Review respectively.

## Output Format

Apply all corrections directly to the document with the `edit` tool and report
each change in a table:

```
| Issue | Fix |
| ----- | --- |
| ...   | ... |
```

If no issues were found, respond only with `No issues found.`.

---

The file to review is $1.
