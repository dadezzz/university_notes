#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  // ---- Helpers ----
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
  let axes2d(x-len, y-len, c) = {
    arrow((0, 0), (x-len, 0), c, 0.4pt)
    arrow((0, 0), (0, y-len), c, 0.4pt)
    label-at((x-len, 0), c, $x$, anchor: "west", padding: 0.1)
    label-at((0, y-len), c, $y$, anchor: "south", padding: 0.1)
  }

  // ---- Colors (all at lightness 50%) ----
  let c-axis = color.hsl(0deg, 0%, 50%) // gray: coordinate axes
  let c-ball = color.hsl(210deg, 60%, 50%) // blue: the open ball B(p0, r)
  let c-center = color.hsl(150deg, 40%, 50%) // green: center p0

  let p0 = (3.0, 2.5)
  let r = 2.0

  // ---- Axes ----
  axes2d(7, 5, c-axis)

  // ---- Ball B(p0, r): light fill + dashed boundary (open!) ----
  circle(
    p0,
    name: "ball",
    radius: r,
    fill: c-ball.transparentize(90%),
    stroke: (paint: c-ball, dash: "dashed"),
  )

  // ---- Center point ----
  circle("ball", radius: 0.1, fill: c-center, stroke: none)
  label-at((), c-center, $p_0$, anchor: "south-east", padding: 0.1)
  label-at("ball.north", c-ball, $B(p_0, r)$, anchor: "south", padding: 0.2)

  // ---- Annotation: boundary excluded ----
  line(
    "ball.north-east",
    (rel: (1, 1)),
    stroke: (paint: c-ball, thickness: 0.4pt),
  )
  label-at((), c-ball, "frontiera esclusa", anchor: "west", padding: 0.1)
}

#starlight.frame(
  cetz.canvas(draw()),
)
