#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-area = color.hsl(210deg, 50%, 50%)
  let c-v = color.hsl(150deg, 50%, 50%)
  let c-w = color.hsl(330deg, 50%, 50%)

  f.axes2d(5, 4, stroke: (paint: c-axis, thickness: 0.2pt))

  let O = (0, 0)
  let v = (2.7, 0.7)
  let w = (0.9, 2.3)
  let sum = f.vadd(v, w)

  f.plane(
    O,
    v,
    sum,
    w,
    fill: c-area,
  )
  f.arrow(O, v, stroke: (paint: c-v, thickness: 0.9pt))
  f.arrow(O, w, stroke: (paint: c-w, thickness: 0.9pt))

  f.label-at(v, $bold(v)$, color: c-v, anchor: "south", padding: 0.1)
  f.label-at(w, $bold(w)$, color: c-w, anchor: "west", padding: 0.1)
  f.label-at(
    sum,
    $"Area" = abs(det(bold(A)))$,
    color: c-area,
    anchor: "west",
    padding: 0.1,
  )
}

#starlight.frame(
  cetz.canvas(draw()),
)
