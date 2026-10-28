#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-s = color.hsl(210deg, 50%, 50%)
  let c-perp = color.hsl(150deg, 50%, 50%)

  f.axes2d(4.2, 4.0, stroke: (paint: c-axis, thickness: 0.2pt))

  // ---- S and its orthogonal complement S^perp ----
  let O = (0, 0)
  let s = (2.6, 1.0)
  let perp-dir = (-1.0, 2.6)
  let len-s = calc.sqrt(calc.pow(s.at(0), 2) + calc.pow(s.at(1), 2))
  let len-perp = calc.sqrt(
    calc.pow(perp-dir.at(0), 2) + calc.pow(perp-dir.at(1), 2),
  )
  let us = f.vscale(1 / len-s, s)
  let up = f.vscale(1 / len-perp, perp-dir)

  line(
    f.vscale(-1.0, s),
    f.vscale(1.1, s),
    stroke: (paint: c-s, thickness: 1.2pt),
  )
  line(
    f.vscale(-1.0, perp-dir),
    f.vscale(1.1, perp-dir),
    stroke: (paint: c-perp, thickness: 1.2pt),
  )

  f.arrow(O, s, stroke: (paint: c-s, thickness: 0.9pt))
  f.arrow(O, perp-dir, stroke: (paint: c-perp, thickness: 0.9pt))

  // Right angle between the two directions.
  let q1 = f.vscale(0.28, us)
  let q2 = f.vadd(q1, f.vscale(0.28, up))
  let q3 = f.vscale(0.28, up)
  line(q1, q2, q3, stroke: (paint: c-axis, thickness: 0.4pt))

  f.label-at(
    f.vscale(1.2, s),
    $S$,
    color: c-s,
  )
  f.label-at(
    f.vscale(1.2, perp-dir),
    $S^perp$,
    color: c-perp,
  )
  f.label-at(
    f.vscale(0.55, s),
    $bold(s)$,
    color: c-s,
    anchor: "south-east",
    padding: 0.1,
  )
  f.label-at(
    f.vscale(0.55, perp-dir),
    $bold(u)$,
    color: c-perp,
    anchor: "west",
    padding: 0.1,
  )
}

#starlight.frame(
  cetz.canvas(draw()),
)
