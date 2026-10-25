#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-line = color.hsl(210deg, 50%, 50%)
  let c-point = color.hsl(150deg, 50%, 50%)
  let c-dir = color.hsl(30deg, 60%, 50%)
  let c-q = color.hsl(330deg, 50%, 50%)

  f.axes3d(6, 5, 5, stroke: (paint: c-axis, thickness: 0.2pt))

  let A = (1.5, 1.5, 1.2)
  let v = (1.2, 0, 0.9)
  let Q = f.vadd(A, f.vscale(2.5, v))
  let start = f.vadd(A, f.vscale(-0.8, v))
  let end = f.vadd(A, f.vscale(3.0, v))

  line(start, end, stroke: (paint: c-line, thickness: 0.7pt))
  f.arrow(A, f.vadd(A, v), stroke: (paint: c-dir, thickness: 0.9pt))
  f.point(A, fill: c-point)
  f.point(Q, fill: c-q)

  f.label-at(A, $A$, color: c-point, anchor: "north-west", padding: 0.1)
  f.label-at(
    f.vadd(A, v),
    $bold(v)$,
    color: c-dir,
    anchor: "north-west",
    padding: 0.1,
  )
  f.label-at(Q, $Q$, color: c-q, anchor: "north-west", padding: 0.1)
  f.label-at(start, $r$, color: c-line, anchor: "south-east", padding: 0.1)
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
