#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-plane = color.hsl(210deg, 50%, 50%)
  let c-point = color.hsl(150deg, 50%, 50%)
  let c-v = color.hsl(30deg, 60%, 50%)
  let c-w = color.hsl(330deg, 50%, 50%)
  let c-q = color.hsl(270deg, 50%, 50%)

  f.axes3d(6.5, 5.0, 3.5, stroke: (paint: c-axis, thickness: 0.2pt))

  let A = (1.0, 1.0, 1.0)
  let B = (4.9, 1.0, 0.52)
  let C = (1.65, 4.25, 0.78)
  let D = f.vadd(B, f.vsub(C, A))
  let v = f.vsub(B, A)
  let w = f.vsub(C, A)
  let Q = f.vadd(A, f.vadd(f.vscale(0.7, v), f.vscale(0.6, w)))

  f.plane(A, B, D, C, fill: c-plane)

  f.arrow(A, B, stroke: (paint: c-v, thickness: 0.8pt))
  f.arrow(A, C, stroke: (paint: c-w, thickness: 0.8pt))
  f.arrow(A, Q, stroke: (paint: c-q, thickness: 0.8pt))

  f.point(A, fill: c-point)
  f.point(B, fill: c-point)
  f.point(C, fill: c-point)
  f.point(Q, fill: c-q)

  f.label-at(A, $A$, color: c-point, anchor: "south", padding: 0.2)
  f.label-at(B, $B$, color: c-point, anchor: "west", padding: 0.2)
  f.label-at(C, $C$, color: c-point, anchor: "east", padding: 0.2)
  f.label-at(Q, $Q$, color: c-q, anchor: "north-west", padding: 0.1)
  f.label-at(
    f.vadd(A, f.vscale(0.6, v)),
    $arrow(A B)$,
    color: c-v,
    anchor: "south",
    padding: 0.2,
  )
  f.label-at(
    f.vadd(A, f.vscale(0.6, w)),
    $arrow(A C)$,
    color: c-w,
    anchor: "south-east",
    padding: 0.1,
  )
  f.label-at(
    D,
    $pi$,
    color: c-plane,
    anchor: "north-west",
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
