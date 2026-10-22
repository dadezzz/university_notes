#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  // ---- Helpers ----
  let polar(rad, t) = (rad * calc.cos(t), rad * calc.sin(t))
  let scale-pt(p, k) = (p.at(0) * k, p.at(1) * k)
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
  let dashed(from, to, c, thickness: 0.4pt) = line(
    from,
    to,
    stroke: (paint: c, thickness: thickness, dash: "dashed"),
  )
  // Angle arc centered at the origin, with its label at `label-radius`.
  let angle-arc(start, delta, radius, label-radius, c, body) = {
    arc(
      (0, 0),
      start: start,
      delta: delta,
      radius: radius,
      anchor: "origin",
      stroke: (paint: c, thickness: 0.7pt),
      mark: (end: ">", fill: c),
    )
    label-at(polar(label-radius, start + delta / 2), c, body)
  }

  // ---- Colors ----
  let c-axis = color.hsl(0deg, 0%, 50%) // gray:   original x, y axes
  let c-prime = color.hsl(210deg, 60%, 50%) // blue:   rotated x', y' axes
  let c-vec = color.hsl(10deg, 65%, 50%) // red:    vector ρ
  let c-point = color.hsl(150deg, 45%, 50%) // green:  point P and its coordinates
  let c-angle = color.hsl(280deg, 50%, 50%) // purple: angles α, θ

  // ---- Parameters ----
  let alpha_ang = 30deg
  let theta_ang = 60deg
  let rho_ang = 3.5
  let axis-len = 5

  // ---- Derived quantities ----
  let P = polar(rho_ang, theta_ang)
  let xp-dir = polar(1, alpha_ang)
  let yp-dir = polar(1, alpha_ang + 90deg)
  let xp-end = scale-pt(xp-dir, axis-len)
  let yp-end = scale-pt(yp-dir, axis-len)
  let foot-x = scale-pt(xp-dir, rho_ang * calc.cos(theta_ang - alpha_ang))
  let foot-y = scale-pt(yp-dir, rho_ang * calc.sin(theta_ang - alpha_ang))

  // ---- Original axes ----
  arrow((0, 0), (axis-len, 0), c-axis, 0.5pt)
  arrow((0, 0), (0, axis-len), c-axis, 0.5pt)
  label-at((axis-len, 0), c-axis, $x$, anchor: "west", padding: 0.1)
  label-at((0, axis-len), c-axis, $y$, anchor: "south", padding: 0.1)

  // ---- Rotated axes ----
  arrow((0, 0), xp-end, c-prime, 0.5pt)
  arrow((0, 0), yp-end, c-prime, 0.5pt)
  label-at(xp-end, c-prime, $x'$, anchor: "west", padding: 0.1)
  label-at(yp-end, c-prime, $y'$, anchor: "east", padding: 0.1)

  // ---- Dashed projections of P onto the original axes ----
  dashed((P.at(0), 0), P, c-axis)
  dashed((0, P.at(1)), P, c-axis)
  label-at((P.at(0), 0), c-axis, $p_x$, anchor: "north", padding: 0.12)
  label-at((0, P.at(1)), c-axis, $p_y$, anchor: "east", padding: 0.12)

  // ---- Dashed projections of P onto the rotated axes ----
  dashed(foot-x, P, c-prime)
  dashed(foot-y, P, c-prime)
  label-at(foot-x, c-prime, $p'_x$, anchor: "north-west", padding: 0.12)
  label-at(foot-y, c-prime, $p'_y$, anchor: "north-east", padding: 0.12)

  // ---- Vector ρ ----
  arrow((0, 0), P, c-vec, 1.2pt)
  label-at((0.55 * P.at(0), 0.6 * P.at(1)), c-vec, $rho$, anchor: "south-east")

  // ---- Angles ----
  angle-arc(0deg, alpha_ang, 1.0, 1.3, c-angle, $alpha$) // x → x'
  angle-arc(90deg, alpha_ang, 1.0, 1.3, c-angle, $alpha$) // y → y'
  angle-arc(0deg, theta_ang, 1.6, 1.8, c-angle, $theta$) // x → ρ

  // ---- Point P ----
  circle(P, radius: 0.1, fill: c-point, stroke: none)
  label-at(
    (P.at(0) + 0.15, P.at(1) + 0.15),
    c-point,
    $P$,
    anchor: "south-west",
  )
}

#figure(
  starlight.frame(
    cetz.canvas(draw()),
  ),
  numbering: none,
  caption: [Rotated frame in blue],
)
