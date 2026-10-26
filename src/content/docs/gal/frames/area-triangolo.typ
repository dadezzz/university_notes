#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-par = color.hsl(210deg, 50%, 50%)
  let c-tri = color.hsl(150deg, 50%, 50%)
  let c-ab = color.hsl(30deg, 60%, 50%)
  let c-ac = color.hsl(330deg, 50%, 50%)
  let c-cross = color.hsl(270deg, 50%, 50%)

  f.axes3d(6.0, 5.0, 4.5, stroke: (paint: c-axis, thickness: 0.2pt))

  let A = f.vscale(2, (1, 0, 1))
  let B = f.vscale(2, (3, 1, 1))
  let C = f.vscale(2, (1, 1, 2))
  let AB = f.vsub(B, A)
  let AC = f.vsub(C, A)
  let D = f.vadd(A, f.vadd(AB, AC))
  let cross = f.vcross(AB, AC)

  // Complete parallelogram ABDC; the triangle is half of it.
  f.plane(A, B, D, C, fill: c-par, stroke: (dash: "dashed"))
  f.plane(A, B, C, fill: c-tri)

  f.arrow(A, B, stroke: (paint: c-ab, thickness: 0.8pt))
  f.arrow(A, C, stroke: (paint: c-ac, thickness: 0.8pt))
  f.arrow(A, f.vadd(A, f.vscale(0.3, cross)), stroke: (
    paint: c-cross,
    thickness: 0.9pt,
  ))

  f.point(A, fill: c-tri)
  f.point(B, fill: c-tri)
  f.point(C, fill: c-tri)

  f.label-at(A, $A$, color: c-tri, anchor: "north-east", padding: 0.1)
  f.label-at(B, $B$, color: c-tri, anchor: "west", padding: 0.1)
  f.label-at(C, $C$, color: c-tri, anchor: "east", padding: 0.1)
  f.label-at(
    f.vadd(A, f.vscale(0.3, cross)),
    $arrow(A B) times arrow(A C)$,
    color: c-cross,
    anchor: "west",
    padding: 0.1,
  )
}

#starlight.frame(
  cetz.canvas(
    cetz.draw.perspective(
      y: 150deg,
      z: 180deg,
      x: -15deg,
      cetz.draw.on-xz(draw()),
    ),
  ),
)
