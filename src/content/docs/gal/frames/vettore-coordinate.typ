#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-x = color.hsl(210deg, 60%, 50%)
  let c-y = color.hsl(150deg, 50%, 50%)
  let c-z = color.hsl(330deg, 50%, 50%)
  let c-v = color.hsl(30deg, 60%, 50%)

  let O = (0, 0, 0)
  let v = (4.5, 3, 3)
  let xy = (v.at(0), v.at(1), 0)

  f.axes3d(6, 5, 4, stroke: (paint: c-axis, thickness: 0.2pt))

  f.arrow(O, (v.at(0), 0, 0), stroke: (paint: c-x, thickness: 0.7pt))
  f.arrow((v.at(0), 0, 0), xy, stroke: (paint: c-y, thickness: 0.7pt))
  f.arrow(xy, v, stroke: (paint: c-z, thickness: 0.7pt))
  f.arrow(O, v, stroke: (paint: c-v, thickness: 1pt))

  f.label-at(
    (v.at(0) / 2, 0, 0),
    $v_1 bold(i)$,
    color: c-x,
    anchor: "north",
    padding: 0.1,
  )
  f.label-at(
    (v.at(0), v.at(1) / 2, 0),
    $v_2 bold(j)$,
    color: c-y,
    anchor: "north-west",
  )
  f.label-at(
    (v.at(0), v.at(1), v.at(2) / 2),
    $v_3 bold(k)$,
    color: c-z,
    anchor: "west",
    padding: 0.1,
  )
  f.label-at(v, $bold(v)$, color: c-v, anchor: "south-east", padding: 0.1)
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
