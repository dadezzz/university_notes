#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-plane = color.hsl(210deg, 50%, 50%)
  let c-r = color.hsl(150deg, 50%, 50%)
  let c-rp = color.hsl(330deg, 50%, 50%)
  let c-pq = color.hsl(30deg, 60%, 50%)

  f.axes3d(5.5, 4.0, 3.4, stroke: (paint: c-axis, thickness: 0.2pt))

  let z0 = 1.2
  let P = (0.8, 1.2, z0)
  let Q = (2.6, 2.8, z0)
  let v = (1.4, 0.5, 0)
  let w = (1.2, -0.4, 0)

  f.plane(
    (0, 0, z0),
    (5, 0, z0),
    (5, 3.5, z0),
    (0, 3.5, z0),
    fill: c-plane,
  )

  line(f.vadd(P, f.vscale(-0.8, v)), f.vadd(P, f.vscale(2.2, v)), stroke: (
    paint: c-r,
    thickness: 0.9pt,
  ))
  line(f.vadd(Q, f.vscale(-0.8, w)), f.vadd(Q, f.vscale(1.8, w)), stroke: (
    paint: c-rp,
    thickness: 0.9pt,
  ))

  f.arrow(P, f.vadd(P, v), stroke: (paint: c-r, thickness: 0.8pt))
  f.arrow(Q, f.vadd(Q, w), stroke: (paint: c-rp, thickness: 0.8pt))
  f.arrow(P, Q, stroke: (paint: c-pq, thickness: 0.8pt))

  f.point(P, fill: c-r)
  f.point(Q, fill: c-rp)

  f.label-at(
    (P.at(0), P.at(1), z0),
    $P$,
    color: c-r,
    anchor: "south",
    padding: 0.2,
  )
  f.label-at(
    (Q.at(0), Q.at(1), z0),
    $Q$,
    color: c-rp,
    anchor: "north",
    padding: 0.2,
  )
  f.label-at(
    f.vadd(P, f.vscale(2.2, v)),
    $r$,
    color: c-r,
    anchor: "south",
    padding: 0.2,
  )
  f.label-at(
    f.vadd(Q, f.vscale(1.8, w)),
    $r'$,
    color: c-rp,
    anchor: "south",
    padding: 0.1,
  )
  f.label-at(
    f.vadd(P, f.vscale(1.2, v)),
    $bold(v)$,
    color: c-r,
    anchor: "north",
    padding: 0.1,
  )
  f.label-at(
    f.vadd(Q, f.vscale(1.2, w)),
    $bold(w)$,
    color: c-rp,
    anchor: "north",
    padding: 0.1,
  )
  f.label-at(
    (
      (P.at(0) + Q.at(0)) / 2,
      (P.at(1) + Q.at(1)) / 2,
      z0,
    ),
    $arrow(P Q)$,
    color: c-pq,
    anchor: "north-east",
    padding: 0.1,
  )
}

#starlight.frame(
  cetz.canvas(
    cetz.draw.perspective(
      y: 150deg,
      z: 180deg,
      x: -30deg,
      cetz.draw.on-xz(draw()),
    ),
  ),
)
