#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-u = color.hsl(210deg, 50%, 50%)
  let c-v = color.hsl(30deg, 60%, 50%)
  let c-proj = color.hsl(150deg, 50%, 50%)

  f.axes2d(4.8, 4.0, stroke: (paint: c-axis, thickness: 0.2pt))

  // ---- Orthogonal projection of v onto u ----
  let O = (0, 0)
  let u = (3.2, 1.0)
  let v = (1.2, 2.6)
  let dot = u.at(0) * v.at(0) + u.at(1) * v.at(1)
  let scale = dot / (calc.pow(u.at(0), 2) + calc.pow(u.at(1), 2))
  let p = (scale * u.at(0), scale * u.at(1))

  f.arrow(O, u, stroke: (paint: c-u, thickness: 0.9pt))
  f.arrow(O, v, stroke: (paint: c-v, thickness: 0.9pt))
  f.arrow(O, p, stroke: (paint: c-proj, thickness: 0.9pt))

  line(v, p, stroke: (paint: c-proj, thickness: 0.6pt, dash: "dashed"))

  f.label-at(
    u,
    $bold(u)$,
    color: c-u,
    anchor: "south",
    padding: 0.1,
  )
  f.label-at(
    v,
    $bold(v)$,
    color: c-v,
    anchor: "south",
    padding: 0.1,
  )
  f.label-at(
    p,
    $op("pr")_bold(u)(bold(v))$,
    color: c-proj,
    anchor: "south-east",
    padding: 0.1,
  )
}

#starlight.frame(
  cetz.canvas(draw()),
)
