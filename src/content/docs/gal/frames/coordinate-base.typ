#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-basis = color.hsl(210deg, 50%, 50%)
  let c-v = color.hsl(30deg, 60%, 50%)
  let c-comp = color.hsl(150deg, 50%, 50%)

  f.axes2d(4.8, 4.2, stroke: (paint: c-axis, thickness: 0.2pt))

  let O = (0, 0)
  let b1 = (2.2, 1.0)
  let b2 = (-0.8, 2.2)
  let lambda1 = 1.4
  let lambda2 = 0.7
  let v = f.vadd(f.vscale(lambda1, b1), f.vscale(lambda2, b2))

  f.arrow(O, b1, stroke: (paint: c-basis, thickness: 0.8pt))
  f.arrow(O, b2, stroke: (paint: c-basis, thickness: 0.8pt))
  f.arrow(O, v, stroke: (paint: c-v, thickness: 1pt))

  line(
    f.vscale(lambda1, b1),
    v,
    stroke: (paint: c-comp, thickness: 0.6pt, dash: "dashed"),
  )
  line(
    f.vscale(lambda2, b2),
    v,
    stroke: (paint: c-comp, thickness: 0.6pt, dash: "dashed"),
  )

  f.label-at(b1, $bold(b)_1$, color: c-basis, anchor: "south", padding: 0.1)
  f.label-at(b2, $bold(b)_2$, color: c-basis, anchor: "west", padding: 0.1)
  f.label-at(v, $bold(v)$, color: c-v, anchor: "north-east", padding: 0.1)

  f.label-at(
    f.vsub(v, f.vscale(lambda1 / 2, b1)),
    $lambda_1 bold(b)_1$,
    color: c-comp,
    anchor: "south",
    padding: 0.2,
  )
  f.label-at(
    f.vsub(v, f.vscale(lambda2 / 2, b2)),
    $lambda_2 bold(b)_2$,
    color: c-comp,
    anchor: "west",
    padding: 0.1,
  )
}

#starlight.frame(
  cetz.canvas(draw()),
)
