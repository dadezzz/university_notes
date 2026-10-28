#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  // Since every joint axis is parallel to the page normal, a frame's `z` axis
  // is marked with the usual "out of the page" circled dot.
  let z-out(
    origin,
    c,
    label,
    dir: (0.3, 0.3),
  ) = {
    circle(origin, radius: 0.22, stroke: (paint: c, thickness: 0.6pt))
    f.label-at(f.vadd(origin, dir), label, color: c)
  }

  let xy-axes(
    origin,
    angle,
    stroke: (:),
    labels: (origin: content, x: content, y: content),
  ) = {
    f.label-at(
      f.vadd(origin, f.polar(0.6, angle - 90deg)),
      labels.origin,
      color: stroke.paint,
    )
    f.arrow(
      origin,
      f.vadd(origin, f.polar(1.5, angle)),
      stroke: stroke,
    )
    f.arrow(
      origin,
      f.vadd(origin, f.polar(1.5, angle + 90deg)),
      stroke: stroke,
    )
    f.label-at(
      f.vadd(origin, f.polar(1.7, angle)),
      labels.x,
      color: stroke.paint,
    )
    f.label-at(
      f.vadd(origin, f.polar(1.7, angle + 90deg)),
      labels.y,
      color: stroke.paint,
    )
  }

  let c-axis = color.hsl(0deg, 0%, 50%) // gray:   fixed base frame {0}
  let c-link = color.hsl(210deg, 60%, 50%) // blue:   robot links
  let c-frame = color.hsl(280deg, 55%, 50%) // purple: frames {1}, {2}
  let c-angle = color.hsl(20deg, 70%, 50%) // orange: joint angles q1, q2
  let c-point = color.hsl(140deg, 50%, 50%) // green:  end effector P

  let q1 = 35deg
  let q2 = 45deg
  let a1 = 3.4
  let a2 = 2.6

  let O = (0, 0)
  let B = f.vadd(O, f.polar(a1, q1))
  let P = f.vadd(B, f.polar(a2, q1 + q2))

  // ---- Robot links ----
  line(O, B, name: "l1", stroke: (paint: c-link, thickness: 2.5pt))
  line(B, P, name: "l2", stroke: (paint: c-link, thickness: 2.5pt))

  // ---- Frames {0}, {1}, {2} ----
  // Frame 0: fixed base frame, x0 along the horizontal reference.
  xy-axes(
    O,
    0deg,
    stroke: (paint: c-axis, thickness: 0.6pt),
    labels: (origin: $O_0$, x: $x_0$, y: $y_0$),
  )
  z-out(O, c-axis, $z_0$, dir: (0.4, -0.4))

  // Frame 1: at joint 2, x1 along the common normal z0 -> z1.
  xy-axes(
    B,
    q1,
    stroke: (paint: c-axis, thickness: 0.6pt),
    labels: (origin: $O_1$, x: $x_1$, y: $y_1$),
  )
  z-out(B, c-axis, $z_1$, dir: (0.5, 0))

  // Frame 2: at the end effector, x2 along the common normal z1 -> z2.
  xy-axes(
    P,
    q1 + q2,
    stroke: (paint: c-axis, thickness: 0.6pt),
    labels: (origin: $O_2$, x: $x_2$, y: $y_2$),
  )
  z-out(P, c-axis, $z_2$, dir: (0.3, -0.4))

  // ---- Joints / end effector ----
  f.point(O, fill: c-link)
  f.point(B, fill: c-link)
  f.point(P, fill: c-point)

  // ---- Joint angles ----
  // q1 = theta_1: from x0 to x1 about z0.
  arc(
    O,
    start: 0deg,
    delta: q1,
    radius: 0.9,
    anchor: "origin",
    stroke: (paint: c-angle, thickness: 0.8pt),
    mark: (end: ">", fill: c-angle),
  )
  f.label-at(f.polar(1.2, q1 / 2), $q_1$, color: c-angle)
  // q2 = theta_2: from x1 to x2 about z1.
  arc(
    B,
    start: q1,
    delta: q2,
    radius: 0.9,
    anchor: "origin",
    stroke: (paint: c-angle, thickness: 0.8pt),
    mark: (end: ">", fill: c-angle),
  )
  f.label-at(f.vadd(B, f.polar(1.2, q1 + q2 / 2)), $q_2$, color: c-angle)

  // ---- Link lengths (the common normals) ----
  f.label-at(
    f.vscale(0.5, B),
    $a_1$,
    color: c-link,
    anchor: "south-east",
    padding: 0.2pt,
  )
  f.label-at(
    f.vadd(B, f.vscale(0.5, f.vsub(P, B))),
    $a_2$,
    color: c-link,
    anchor: "east",
    padding: 0.2,
  )

  f.label-at(P, $P$, color: c-point, anchor: "south-west", padding: 0.15)
}

#figure(
  starlight.frame(
    cetz.canvas(draw()),
  ),
  caption: [$z$ axes are perpendicular to the viewer, passing through the
    joints],
  numbering: none,
)

