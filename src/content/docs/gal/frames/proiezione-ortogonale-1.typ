#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-v = color.hsl(210deg, 60%, 50%)
  let c-w = color.hsl(150deg, 50%, 50%)
  let c-proj = color.hsl(330deg, 50%, 50%)

  f.axes2d(5, 4, stroke: (paint: c-axis, thickness: 0.2pt))

  let O = (0, 0)
  let v = (4.2, 0.7)
  let w = (1.7, 3)

  f.arrow(O, v, stroke: (paint: c-v, thickness: 0.8pt))
  f.arrow(O, w, stroke: (paint: c-w, thickness: 0.8pt))
  f.label-at(v, $bold(v)$, color: c-v, anchor: "south")
  f.label-at(w, $bold(w)$, color: c-w, anchor: "west")

  // Orthogonal projection of v onto w.
  let dot = f.vdot(v, w)
  let scale = dot / calc.pow(f.vnorm(w), 2)
  let p = f.vscale(w, scale)

  line(v, p, stroke: (paint: c-proj, thickness: 0.6pt, dash: "dashed"))
  f.arrow(O, p, stroke: (paint: c-proj, thickness: 0.8pt))
  f.label-at(
    p,
    $op("pr")_bold(w)(bold(v))$,
    color: c-proj,
    anchor: "south-east",
    padding: 0.1,
  )
}

#starlight.frame(
  cetz.canvas(draw()),
)
