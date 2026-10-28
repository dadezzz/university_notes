#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-l1 = color.hsl(210deg, 50%, 50%)
  let c-l2 = color.hsl(150deg, 50%, 50%)
  let c-v = color.hsl(30deg, 60%, 50%)
  let c-fv = color.hsl(330deg, 50%, 50%)

  // ---- f(x, y) = (y, x): a reflection across the line y = x ----
  let O = (0, 0)
  let v = (2.4, 0.8)
  let fv = (v.at(1), v.at(0))

  f.axes2d(4.0, 4.0, stroke: (paint: c-axis, thickness: 0.2pt))

  // Eigenspaces: y = x (lambda = 1) and y = -x (lambda = -1).
  line((-3.0, -3.0), (3.0, 3.0), stroke: (
    paint: c-l1,
    thickness: 0.7pt,
    dash: "dashed",
  ))
  line((-3.0, 3.0), (3.0, -3.0), stroke: (
    paint: c-l2,
    thickness: 0.7pt,
    dash: "dashed",
  ))

  f.arrow(O, (1.6, 1.6), stroke: (paint: c-l1, thickness: 0.9pt))
  f.arrow(O, (1.2, -1.2), stroke: (paint: c-l2, thickness: 0.9pt))

  f.arrow(O, v, stroke: (paint: c-v, thickness: 0.9pt))
  f.arrow(O, fv, stroke: (paint: c-fv, thickness: 0.9pt))

  f.label-at(
    (2.6, 2.4),
    $lambda_1 = 1$,
    color: c-l1,
    anchor: "west",
    padding: 0.1,
  )
  f.label-at(
    (2.6, -2.4),
    $lambda_2 = -1$,
    color: c-l2,
    anchor: "west",
    padding: 0.1,
  )

  f.label-at(v, $bold(v)$, color: c-v, anchor: "south-east", padding: 0.1)
  f.label-at(fv, $f(bold(v))$, color: c-fv, anchor: "north-west", padding: 0.1)
}

#starlight.frame(
  cetz.canvas(draw()),
)
