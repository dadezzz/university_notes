#let setup(doc) = {
  show math.overline: it => {
    // Uses the macron combining accent
    math.accent(it.body, "\u{0305}")
  }

  show math.underline: it => {
    // Uses combining low line
    math.accent(it.body, "\u{0332}")
  }

  show math.equation: it => {
    // Disable starlight css customizations inside math, to avoid weird vertical
    // spacing.
    html.elem("span", attrs: (class: "not-content"), it)
  }

  doc
}

#let note(type: "note", title: "", body) = {
  html.elem(
    "aside",
    attrs: (data-starlight-aside: type, data-starlight-aside-title: title),
    body,
  )
}

#let tip(title: "", body) = note(type: "tip", title: title, body)
#let caution(title: "", body) = note(type: "caution", title: title, body)
#let danger(title: "", body) = note(type: "danger", title: title, body)

#let hr() = {
  html.hr()
}

#let img(path, alt: "") = {
  html.div(html.img(src: path, alt: alt))
}
