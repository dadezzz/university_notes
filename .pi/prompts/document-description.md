---
description: Generate title and description for document
argument-hint: <DOCUMENT>
---

You are an expert technical writer tasked with generating concise document title
and descriptions for academic notes in $1.

## Guidelines

- Write in the **same language** as the source document
- Focus on the **main arguments and topics** discussed
- Keep the title between 40 and 50 characters
- Keep the description between 150 and 160 characters
- Use clear, descriptive language suitable for navigation and search
- Avoid vague phrases like "notes on" or "introduction to"
- Prioritize specificity, mention key concepts, theorems, or frameworks
- **Do not use colons** anywhere in the title or description
- **Avoid LaTeX notation** such as R^n, Z*+, or similar mathematical symbols;
  write them out in plain text instead (e.g., "real numbers" instead of "R^n",
  "positive integers" instead of "Z*+")
- Capitalize only the first word and proper nouns

## Output

Write directly into the YAML frontmatter as `title` and `description` fields.
