import { execSync } from "node:child_process";
import { CONTINUE, SKIP, visit } from "unist-util-visit";
import type { Element, Root, Text } from "hast";

// At the moment typst doesn't render overline/underline in mathml. So until
// https://github.com/typst/typst/issues/8509 is solved we use these.
const polyfill = `\
  #show math.overline: it => {
    // Uses the macron combining accent
    math.accent(it.body, "\u{0305}")
  }

  #show math.underline: it => {
    // Uses combining low line
    math.accent(it.body, "\u{0332}")
  }
`;

function typstToMathML(expression: string, display: boolean): Element {
  const typstCode = display ? `$ ${expression} $` : `$${expression.trim()}$`;

  try {
    const typstHtml = execSync(`typst compile - --features html --format html -`, {
      input: polyfill + typstCode,
      encoding: "utf-8",
      stdio: ["pipe", "pipe", "pipe"],
    });

    // Extract everything between the <p>...</p> inside the body.
    const math = typstHtml.match(/<math.*?<\/math>/is);

    if (math) {
      const mathXml = math[0];
      return {
        type: "element",
        tagName: display ? "div" : "span",
        properties: {
          // not-content disables starlight rules that made math render badly.
          className: ["typst-math", "not-content"],
        },
        children: [{ type: "raw", value: mathXml }],
      };
    } else {
      throw new Error("rendered math block not found, check that typst v0.15 or later is used");
    }
  } catch (error) {
    console.error(`Error while rendering '${expression}': ${error.message}`);

    return {
      type: "element",
      tagName: display ? "div" : "span",
      properties: {
        className: ["typst-math-error"],
        // Leave the error in the markup for easier debugging.
        "data-error": error.message,
      },

      children: [{ type: "text", value: expression }],
    };
  }
}

export function rehypeTypst() {
  return (tree: Root) => {
    visit(tree, "element", (node, index, parent) => {
      let isDisplay = false;
      let codeNode: Element | null = null;
      let textNode: Text | null = null;

      if (node.tagName === "pre") {
        isDisplay = true;

        const content = node.children.at(0);
        if (content?.type === "element") {
          codeNode = content;
        }
      } else {
        codeNode = node;
      }

      if (codeNode?.tagName === "code" && codeNode?.properties.className?.includes("language-math")) {
        const content = codeNode.children.at(0);
        if (content?.type === "text") {
          textNode = content;
        }
      }

      if (!textNode) {
        return CONTINUE;
      }

      if (parent && typeof index === "number") {
        const node = typstToMathML(textNode.value, isDisplay);
        parent.children[index] = node;
      }

      return SKIP;
    });
  };
}
