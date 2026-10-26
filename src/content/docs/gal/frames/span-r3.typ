
#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-span = color.hsl(210deg, 50%, 50%)
  let c-v1 = color.hsl(150deg, 50%, 50%)
  let c-v2 = color.hsl(330deg, 50%, 50%)
  let c-combo = color.hsl(30deg, 60%, 50%)

  f.axes2d(6, 5, stroke: (paint: c-axis, thickness: 0.2pt))

  let O = (0, 0)
  let v1 = (3.0, 0.5)
  let v2 = (0.8, 2.6)
  let sum = f.vadd(v1, v2)

  f.plane(O, v1, sum, v2, fill: c-span)

  f.arrow(O, v1, stroke: (paint: c-v1, thickness: 0.9pt))
  f.arrow(O, v2, stroke: (paint: c-v2, thickness: 0.9pt))
  f.arrow(O, sum, stroke: (paint: c-combo, thickness: 0.9pt))

  f.label-at(v1, $bold(v)_1$, color: c-v1, anchor: "west", padding: 0.1)
  f.label-at(v2, $bold(v)_2$, color: c-v2, anchor: "south-east", padding: 0.1)
  f.label-at(
    sum,
    $lambda_1 bold(v)_1 + lambda_2 bold(v)_2$,
    color: c-combo,
    anchor: "south-west",
    padding: 0.1,
  )
  f.label-at(
    sum,
    $op("span")(bold(v)_1, bold(v)_2)$,
    color: c-span,
    anchor: "south-east",
    padding: 0.1,
  )
}

#starlight.frame(
  cetz.canvas(draw()),
)
