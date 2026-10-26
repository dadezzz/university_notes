#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-plane = color.hsl(210deg, 50%, 50%)
  let c-normal = color.hsl(30deg, 60%, 50%)
  let c-point = color.hsl(150deg, 50%, 50%)

  f.axes3d(6, 5, 5, stroke: (paint: c-axis, thickness: 0.2pt))

  let P = (1.8, 1.8, 1.2)
  let u = (1.4, 0, -1.3)
  let w = (0, 2.0, -0.2)
  let normal = f.vcross(u, w)
  let n = f.vscale(2.2 / f.vnorm(normal), normal)

  let c1 = f.vsub(f.vsub(P, u), w)
  let c2 = f.vadd(f.vsub(P, w), u)
  let c3 = f.vadd(f.vadd(P, u), w)
  let c4 = f.vadd(f.vsub(P, u), w)

  line(
    c1,
    c2,
    c3,
    c4,
    close: true,
    fill: c-plane.transparentize(90%),
    stroke: (paint: c-plane, thickness: 0.5pt),
  )
  f.arrow(P, f.vadd(P, n), stroke: (paint: c-normal, thickness: 1pt))
  f.point(P, fill: c-point)

  f.label-at(c3, $pi$, color: c-plane, anchor: "north-east", padding: 0.1)
  f.label-at(P, $P$, color: c-point, anchor: "north-west", padding: 0.1)
  f.label-at(
    f.vadd(P, n),
    $bold(n)$,
    color: c-normal,
    anchor: "west",
    padding: 0.1,
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
