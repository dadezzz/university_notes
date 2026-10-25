#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-edge = color.hsl(210deg, 50%, 50%)
  let c-base = color.hsl(210deg, 50%, 50%)
  let c-v = color.hsl(30deg, 60%, 50%)
  let c-w = color.hsl(150deg, 50%, 50%)
  let c-u = color.hsl(330deg, 50%, 50%)

  f.axes3d(5.5, 4.5, 4.2, stroke: (paint: c-axis, thickness: 0.2pt))

  let O = (0, 0, 0)
  let v = (3.0, 0, 0.4)
  let w = (0.8, 2.6, 0.3)
  let u = (0.4, 0.7, 2.4)
  let vw = f.vadd(v, w)
  let vu = f.vadd(v, u)
  let wu = f.vadd(w, u)
  let vwu = f.vadd(vw, u)

  // Bottom and top faces.
  f.plane(O, v, vw, w, fill: c-base)
  f.plane(u, vu, vwu, wu, fill: c-edge)

  // Vertical edges.
  line(O, u, stroke: (paint: c-edge, thickness: 0.4pt))
  line(v, vu, stroke: (paint: c-edge, thickness: 0.4pt))
  line(w, wu, stroke: (paint: c-edge, thickness: 0.4pt))
  line(vw, vwu, stroke: (paint: c-edge, thickness: 0.4pt))

  f.arrow(O, v, stroke: (paint: c-v, thickness: 0.9pt))
  f.arrow(O, w, stroke: (paint: c-w, thickness: 0.9pt))
  f.arrow(O, u, stroke: (paint: c-u, thickness: 0.9pt))

  f.label-at(v, $bold(v)$, color: c-v, anchor: "west", padding: 0.1)
  f.label-at(w, $bold(w)$, color: c-w, anchor: "north-east", padding: 0.1)
  f.label-at(u, $bold(u)$, color: c-u, anchor: "south", padding: 0.1)
  f.label-at(
    vu,
    $V = abs(bold(v) dot (bold(w) times bold(u)))$,
    color: c-edge,
    anchor: "north-west",
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
