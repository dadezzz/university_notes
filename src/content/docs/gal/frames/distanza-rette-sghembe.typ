#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-r1 = color.hsl(210deg, 50%, 50%)
  let c-r2 = color.hsl(150deg, 50%, 50%)
  let c-distance = color.hsl(330deg, 50%, 50%)
  let c-dir = color.hsl(30deg, 60%, 50%)

  f.axes3d(6, 5, 4.5, stroke: (paint: c-axis, thickness: 0.2pt))

  let P = (4.0, 1.0, 0.5)
  let Q = (4.0, 1.0, 3.0)

  // r1: direction (1, 0, 0)
  let r1 = (f.vsub(P, (3, 0, 0)), f.vadd(P, (1, 0, 0)))
  let r1v = (r1.at(0), f.vsub(r1.at(1), (2, 0, 0)))
  line(r1.at(0), r1.at(1), stroke: (paint: c-r1, thickness: 1pt))
  f.arrow(r1v.at(0), r1v.at(1), stroke: (paint: c-dir, thickness: 0.8pt))
  f.label-at(r1.at(1), $r_1$, color: c-r1, anchor: "north", padding: 0.1)

  // r2: direction (0, 1, 0)
  let r2 = (f.vsub(Q, (0, 1, 0)), f.vadd(Q, (0, 3, 0)))
  let r2v = (r2.at(0), f.vsub(r2.at(1), (0, 2, 0)))
  line(r2.at(0), r2.at(1), stroke: (paint: c-r2, thickness: 1pt))
  f.arrow(r2v.at(0), r2v.at(1), stroke: (paint: c-dir, thickness: 0.8pt))
  f.label-at(r2.at(1), $r_2$, color: c-r2, anchor: "north", padding: 0.1)

  // Common perpendicular segment.
  line(P, Q, stroke: (paint: c-distance, thickness: 0.9pt, dash: "dashed"))
  f.point(P, fill: c-distance)
  f.point(Q, fill: c-distance)

  // Direction vectors.
  f.label-at(
    (2.2, 1, 0.5),
    $bold(v)_1$,
    color: c-dir,
    anchor: "south",
    padding: 0.1,
  )
  f.label-at(
    (4, 2.1, 3),
    $bold(v)_2$,
    color: c-dir,
    anchor: "north",
    padding: 0.1,
  )

  f.label-at(P, $P$, color: c-distance, anchor: "south-west", padding: 0.1)
  f.label-at(Q, $Q$, color: c-distance, anchor: "north-west", padding: 0.1)
  f.label-at(
    (P.at(0), P.at(1), (P.at(2) + Q.at(2)) / 2),
    $d(r_1, r_2)$,
    color: c-distance,
    anchor: "west",
    padding: 0.2,
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
