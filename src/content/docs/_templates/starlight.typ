#let setup(doc) = {
  show math.overline: it => {
    // Uses the macron combining accent
    math.accent(it.body, "\u{0305}")
  }

  show math.underline: it => {
    // Uses combining low line
    math.accent(it.body, "\u{0332}")
  }

  doc
}

#let aside(type: str, title: str, body) = {
  html.elem(
    "aside",
    attrs: (data-starlight-aside: type, data-starlight-aside-title: title),
    body,
  )
}

#let note(title: "", body) = aside(type: "note", title: title, body)
#let tip(title: "", body) = aside(type: "tip", title: title, body)
#let caution(title: "", body) = aside(type: "caution", title: title, body)
#let danger(title: "", body) = aside(type: "danger", title: title, body)

#let hr() = {
  html.hr()
}

#let img(source, alt: str) = {
  html.elem("div", attrs: (
    data-starlight-img-src: source,
    data-starlight-img-alt: alt,
  ))
}

#let frame(body) = {
  html.frame(body)
}
