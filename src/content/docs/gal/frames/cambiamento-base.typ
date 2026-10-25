#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-a = color.hsl(210deg, 50%, 50%)
  let c-b = color.hsl(150deg, 50%, 50%)
  let c-v = color.hsl(30deg, 60%, 50%)

  f.axes2d(5.0, 4.4, stroke: (paint: c-axis, thickness: 0.2pt))

  // ---- The same vector v with respect to two different bases ----
  let O = (0, 0)
  let a1 = (2.6, 0.4)
  let a2 = (0.4, 2.4)
  let b1 = (1.0, 1.7)
  let b2 = (2, 0.6)

  // v = alpha1 a1 + alpha2 a2
  let alpha1 = 1.2
  let alpha2 = 0.8
  let v = f.vadd(f.vscale(alpha1, a1), f.vscale(alpha2, a2))

  // v = beta1 b1 + beta2 b2
  let det = b1.at(0) * b2.at(1) - b2.at(0) * b1.at(1)
  let beta1 = (v.at(0) * b2.at(1) - b2.at(0) * v.at(1)) / det
  let beta2 = (b1.at(0) * v.at(1) - v.at(0) * b1.at(1)) / det

  // Basis A = {a1, a2}.
  f.arrow(O, a1, stroke: (paint: c-a, thickness: 0.8pt))
  f.arrow(O, a2, stroke: (paint: c-a, thickness: 0.8pt))
  f.label-at(a1, $bold(a)_1$, color: c-a, anchor: "south", padding: 0.1)
  f.label-at(a2, $bold(a)_2$, color: c-a, anchor: "north-west", padding: 0.1)

  // Basis B = {b1, b2}.
  f.arrow(O, b1, stroke: (paint: c-b, thickness: 0.8pt))
  f.arrow(O, b2, stroke: (paint: c-b, thickness: 0.8pt))
  f.label-at(b1, $bold(b)_1$, color: c-b, anchor: "east", padding: 0.1)
  f.label-at(b2, $bold(b)_2$, color: c-b, anchor: "south-east", padding: 0.1)

  // Coordinates of v in the two bases.
  line(a1, v, stroke: (paint: c-a, thickness: 0.6pt, dash: "dotted"))
  line(a2, v, stroke: (paint: c-a, thickness: 0.6pt, dash: "dotted"))
  line(b1, v, stroke: (paint: c-b, thickness: 0.6pt, dash: "dotted"))
  line(b2, v, stroke: (paint: c-b, thickness: 0.6pt, dash: "dotted"))

  f.arrow(O, v, stroke: (paint: c-v, thickness: 1pt))
  f.label-at(v, $bold(v)$, color: c-v, anchor: "south-west", padding: 0.1)

  f.label-at((2.7, 4), $cal(A)$, color: c-a, anchor: "west", padding: 0.1)
  f.label-at((3.2, 4), $cal(B)$, color: c-b, anchor: "west", padding: 0.1)
}

#starlight.frame(
  cetz.canvas(draw()),
)
