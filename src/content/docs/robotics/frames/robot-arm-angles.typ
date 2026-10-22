#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

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
  let dashed(from, to, c, thickness) = line(
    from,
    to,
    stroke: (paint: c, thickness: thickness, dash: "dashed"),
  )
  // Joint arc, with its label placed independently of the arc radius.
  let angle-arc(
    center,
    start,
    delta,
    radius,
    c,
    label-pos,
    body,
    anchor: "center",
    padding: 0,
  ) = {
    arc(
      center,
      start: start,
      delta: delta,
      radius: radius,
      anchor: "origin",
      stroke: (paint: c, thickness: 0.6pt),
      mark: (end: ">", fill: c),
    )
    label-at(label-pos, c, body, anchor: anchor, padding: padding)
  }

  // ---- Colors (all at lightness 50%) ----
  let c-axis = color.hsl(0deg, 0%, 50%) // gray:   coordinate axes & projections
  let c-link = color.hsl(210deg, 60%, 50%) // blue:   robot links
  let c-angle = color.hsl(20deg, 70%, 50%) // orange: joint angles q1, q2
  let c-point = color.hsl(140deg, 50%, 50%) // green:  end effector P and phi

  // ---- Kinematic parameters (edit these to move everything) ----
  let q1 = 20deg
  let q2 = 40deg
  let l1 = 3
  let l2 = 2.5

  let A = (0, 0)
  let B = polar(l1, q1)
  let P = add(B, polar(l2, q1 + q2))

  // ---- Axes ----
  arrow((0, 0), (7, 0), c-axis, 0.4pt)
  arrow((0, 0), (0, 5), c-axis, 0.4pt)
  label-at((7, 0), c-axis, $x$, anchor: "west", padding: 0.1)
  label-at((0, 5), c-axis, $y$, anchor: "south", padding: 0.1)

  // ---- Dashed projections to p_x and p_y ----
  dashed((0, P.at(1)), (P.at(0) + 2, P.at(1)), c-axis, 0.3pt)
  dashed((P.at(0), 0), (P.at(0), P.at(1)), c-axis, 0.3pt)
  label-at((0, P.at(1)), c-point, $p_y$, anchor: "east", padding: 0.15)
  label-at((P.at(0), 0), c-point, $p_x$, anchor: "north", padding: 0.15)

  // ---- Links ----
  line(A, B, name: "l1", stroke: (paint: c-link, thickness: 2pt))
  line(B, P, name: "l2", stroke: (paint: c-link, thickness: 2pt))

  // ---- Joints / end effector ----
  circle(A, radius: 0.1, fill: c-link, stroke: none)
  circle(B, radius: 0.1, fill: c-link, stroke: none)
  circle(P, radius: 0.1, fill: c-point, stroke: none)

  // ---- q1: from horizontal to link 1 ----
  angle-arc(A, 0deg, q1, 1, c-angle, polar(1.3, q1 / 2), $q_1$)

  // ---- q2: from link-1 direction (dashed) to link 2 ----
  let ext = 1.15
  dashed(B, add(B, polar(ext, q1)), c-angle, 0.4pt)
  angle-arc(
    B,
    q1,
    q2,
    1,
    c-angle,
    add(B, polar(1.3, q1 + q2 / 2)),
    $q_2$,
    padding: 0.1,
  )

  // ---- q1 + q2: from horizontal at P to link-2 direction ----
  angle-arc(
    P,
    0deg,
    q1 + q2,
    0.7,
    c-point,
    add(P, polar(1, q1 + q2 / 2)),
    $phi$,
    anchor: "west",
    padding: 0.1,
  )

  // ---- Link length labels ----
  label-at("l1", c-link, $l_1$, anchor: "south-east", padding: 0.1)
  label-at("l2", c-link, $l_2$, anchor: "south-east", padding: 0.1)

  // ---- Vectors on effector ----
  arrow(P, add(P, polar(ext, q1 + q2)), c-point, 0.4pt)
  arrow(P, add(P, polar(ext, q1 + q2 + 90deg)), c-point, 0.4pt)

  // ---- End effector label ----
  label-at(P, c-point, $P$, anchor: "north-west", padding: 0.15)
}

#starlight.frame(
  cetz.canvas(draw()),
)
