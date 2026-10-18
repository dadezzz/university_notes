#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#let draw() = {
  import cetz.draw: *

  // ---- Helpers ----
  let polar(rad, t) = (rad * calc.cos(t), rad * calc.sin(t))
  let add(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))
  let label-at(pos, c, body, anchor: "center", padding: 0) = content(
    pos,
    anchor: anchor,
    padding: padding,
    text(fill: c, body),
  )
  let arrow(from, to, c, thickness) = line(
    from,
    to,
    stroke: (paint: c, thickness: thickness),
    mark: (end: ">", fill: c),
  )
  // Since every joint axis is parallel to the page normal, a frame's `z` axis
  // is marked with the usual "out of the page" circled dot.
  let z-out(
    origin,
    c,
    label,
    dir: (0.3, 0.3),
    anchor: "south-west",
  ) = {
    circle(origin, radius: 0.22, stroke: (paint: c, thickness: 0.6pt))
    label-at(add(origin, dir), c, label, anchor: anchor, padding: 0.05)
  }

  // ---- Colors ----
  let c-axis = color.hsl(0deg, 0%, 50%) // gray:   fixed base frame {0}
  let c-link = color.hsl(210deg, 60%, 50%) // blue:   robot links
  let c-frame = color.hsl(280deg, 55%, 50%) // purple: frames {1}, {2}
  let c-angle = color.hsl(20deg, 70%, 50%) // orange: joint angles q1, q2
  let c-point = color.hsl(140deg, 50%, 50%) // green:  end effector P

  // ---- Kinematic parameters (edit these to move everything) ----
  let q1 = 35deg
  let q2 = 45deg
  let a1 = 3.4
  let a2 = 2.6

  let O = (0, 0)
  let B = add(O, polar(a1, q1))
  let P = add(B, polar(a2, q1 + q2))

  // ---- Robot links ----
  line(O, B, name: "l1", stroke: (paint: c-link, thickness: 2.5pt))
  line(B, P, name: "l2", stroke: (paint: c-link, thickness: 2.5pt))

  // ---- Frames {0}, {1}, {2} ----
  // Frame 0: fixed base frame, x0 along the horizontal reference.
  arrow(O, add(O, polar(1.7, 0deg)), c-axis, 0.6pt)
  arrow(O, add(O, polar(1.5, 90deg)), c-axis, 0.6pt)
  z-out(O, c-axis, $z_0$, dir: (-0.32, 0.3), anchor: "south-east")
  label-at(
    add(O, polar(1.7, 0deg)),
    c-axis,
    $x_0$,
    anchor: "west",
    padding: 0.1,
  )
  label-at(
    add(O, polar(1.5, 90deg)),
    c-axis,
    $y_0$,
    anchor: "east",
    padding: 0.1,
  )

  // Frame 1: at joint 2, x1 along the common normal z0 -> z1.
  arrow(B, add(B, polar(1.4, q1)), c-frame, 0.6pt)
  arrow(B, add(B, polar(1.3, q1 + 90deg)), c-frame, 0.6pt)
  z-out(B, c-frame, $z_1$, dir: (0.52, -0.42), anchor: "north-west")
  label-at(
    add(B, polar(1.4, q1)),
    c-frame,
    $x_1$,
    anchor: "west",
    padding: 0.1,
  )
  label-at(
    add(B, polar(1.3, q1 + 90deg)),
    c-frame,
    $y_1$,
    anchor: "east",
    padding: 0.1,
  )

  // Frame 2: at the end effector, x2 along the common normal z1 -> z2.
  arrow(P, add(P, polar(1.4, q1 + q2)), c-frame, 0.6pt)
  arrow(P, add(P, polar(1.3, q1 + q2 + 90deg)), c-frame, 0.6pt)
  z-out(P, c-frame, $z_2$, dir: (0.34, -0.24), anchor: "north-west")
  label-at(
    add(P, polar(1.4, q1 + q2)),
    c-frame,
    $x_2$,
    anchor: "west",
    padding: 0.1,
  )
  label-at(
    add(P, polar(1.3, q1 + q2 + 90deg)),
    c-frame,
    $y_2$,
    anchor: "east",
    padding: 0.1,
  )

  // ---- Joints / end effector ----
  circle(O, radius: 0.12, fill: c-link, stroke: none)
  circle(B, radius: 0.12, fill: c-link, stroke: none)
  circle(P, radius: 0.12, fill: c-point, stroke: none)

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
  label-at(polar(1.2, q1 / 2), c-angle, $q_1$)
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
  label-at(add(B, polar(1.2, q1 + q2 / 2)), c-angle, $q_2$)

  // ---- Link lengths (the common normals) ----
  label-at(
    add(add(O, polar(a1 / 2, q1)), polar(0.55, q1 - 90deg)),
    c-link,
    $a_1$,
  )
  label-at(
    add(add(B, polar(a2 / 2, q1 + q2)), polar(0.8, q1 + q2 - 90deg)),
    c-link,
    $a_2$,
  )

  // ---- Origin labels ----
  label-at(O, c-axis, $O_0$, anchor: "north-west", padding: 0.15)
  label-at(B, c-frame, $O_1$, anchor: "north-west", padding: 0.15)
  label-at(P, c-point, $P$, anchor: "north", padding: 0.15)
}

#figure(
  starlight.frame(
    cetz.canvas(draw()),
  ),
  caption: [$z$ axes are perpendicular to the viewer, passing through the
    joints],
  numbering: none,
)

