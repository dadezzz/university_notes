#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-plane = color.hsl(210deg, 50%, 50%)
  let c-point = color.hsl(150deg, 50%, 50%)
  let c-distance = color.hsl(330deg, 50%, 50%)
  let c-normal = color.hsl(30deg, 60%, 50%)

  f.axes3d(6, 5, 4.5, stroke: (paint: c-axis, thickness: 0.2pt))

  let z0 = 0.8
  let P = (3.0, 2.0, 3.0)
  let Q = (3.0, 2.0, z0)
  let R = (1.0, 3.5, z0)

  line(
    (0, 0, z0),
    (5, 0, z0),
    (5, 4, z0),
    (0, 4, z0),
    close: true,
    fill: c-plane.transparentize(90%),
    stroke: (paint: c-plane, thickness: 0.5pt),
  )
  f.label-at(
    (4.8, 3.8, z0),
    $pi$,
    color: c-plane,
    anchor: "north-east",
    padding: 0.1,
  )

  f.arrow(R, (R.at(0), R.at(1), z0 + 1.6), stroke: (
    paint: c-normal,
    thickness: 0.8pt,
  ))
  f.label-at(
    (R.at(0), R.at(1), z0 + 1.6),
    $bold(n)$,
    color: c-normal,
    anchor: "west",
    padding: 0.1,
  )

  line(P, Q, stroke: (paint: c-distance, thickness: 0.9pt, dash: "dashed"))
  f.point(P, fill: c-point)
  f.point(Q, fill: c-point)

  f.label-at(P, $P$, color: c-point, anchor: "east", padding: 0.2)
  f.label-at(Q, $Q$, color: c-point, anchor: "east", padding: 0.2)
  f.label-at(
    (P.at(0), P.at(1), (P.at(2) + Q.at(2)) / 2),
    $d(P, pi)$,
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
