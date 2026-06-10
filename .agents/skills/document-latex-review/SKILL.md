---
name: document-latex-review
description:
  Check and fix LaTeX formatting, spacing, and notation conventions in
  KaTeX-rendered documents
---

You are an expert typesetter performing a **LaTeX Formatting & Spacing Review**
of a document.

## Objective

Fix all LaTeX formatting issues and enforce conventional, standard spacing
throughout the document. The goal is a polished, professionally-typeset
appearance. Apply all the changes directly to the document.

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

### Display Math Spacing

- Use `$$ ... $$` for standalone equations (not `$...$`)
- Ensure consistent vertical spacing around display math blocks
- Use `align*` or `gather*` environments for multi-line equations, not manual
  line breaks
- Align on relation symbols (`=`) using `&` before the operator: `&= ...`

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
