#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-p = color.hsl(210deg, 50%, 50%)
  let c-fp = color.hsl(150deg, 50%, 50%)
  let c-angle = color.hsl(30deg, 60%, 50%)

  f.axes2d(4.5, 4.0, stroke: (paint: c-axis, thickness: 0.2pt))

  // ---- Rotation by alpha around the origin ----
  let O = (0, 0)
  let p = (3.0, 1.0)
  let rot = 35deg
  let fp = (
    p.at(0) * calc.cos(rot) - p.at(1) * calc.sin(rot),
    p.at(0) * calc.sin(rot) + p.at(1) * calc.cos(rot),
  )
  let angle-p = calc.atan2(p.at(0), p.at(1))
  let angle-fp = calc.atan2(fp.at(0), fp.at(1))

  circle(O, radius: 1.15, stroke: (
    paint: c-axis,
    thickness: 0.3pt,
    dash: "dotted",
  ))
  f.arrow(O, p, stroke: (paint: c-p, thickness: 0.9pt))
  f.arrow(O, fp, stroke: (paint: c-fp, thickness: 0.9pt))

  arc(
    O,
    start: angle-p,
    stop: angle-fp,
    radius: 1.15,
    anchor: "origin",
    stroke: (paint: c-angle, thickness: 0.7pt),
  )
  f.label-at(
    (
      1.4 * calc.cos((angle-p + angle-fp) / 2),
      1.4 * calc.sin((angle-p + angle-fp) / 2),
    ),
    $alpha$,
    color: c-angle,
  )

  f.label-at(p, $bold(p)$, color: c-p, anchor: "south-east", padding: 0.1)
  f.label-at(fp, $f(bold(p))$, color: c-fp, anchor: "north-west", padding: 0.1)
}

#starlight.frame(
  cetz.canvas(draw()),
)
