---
description:
  Check document for critical content errors (non-sensical, wrong, or missing)
argument-hint: <DOCUMENT>
---

You are an expert technical reviewer performing a **Content Integrity Review**
of a document.

## Objective

Identify and flag **critical content errors** — things that are factually wrong,
logically inconsistent, or completely nonsensical. Do **not** fix grammar or
formatting yet; only surface issues that would make the document misleading or
broken.

## What to Check

### Factual & Logical Errors

- Statements that contradict each other within the same document
- Claims that are demonstrably false or nonsensical
- Equations or derivations that are mathematically incorrect (e.g., a step that
  doesn't follow from the previous one)
- Contradictory definitions or variable reuse with conflicting meanings

### Structural & Completeness Issues

- Sections that are empty, truncated, or obviously incomplete
- Headings with no content beneath them
- Abrupt endings or cut-off paragraphs

### Coherence

- Paragraphs or sentences that are gibberish or garbled
- Text that appears to be placeholder content (e.g., "TODO", "insert figure
  here" without a figure)
- Sentences that make no logical sense in context

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
