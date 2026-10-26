#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-img = color.hsl(210deg, 50%, 50%)
  let c-ker = color.hsl(150deg, 50%, 50%)
  let c-v = color.hsl(30deg, 60%, 50%)
  let c-res = color.hsl(330deg, 50%, 50%)

  f.axes2d(5, 4, stroke: (paint: c-axis, thickness: 0.2pt))

  let O = (0, 0)
  let v = (2.2, 2.6)
  let fv = (2.2, 0)

  // Image: the x-axis. Kernel: the y-axis.
  line((-1, 0), (4.8, 0), stroke: (paint: c-img, thickness: 1.6pt))
  line((0, -1), (0, 3.8), stroke: (paint: c-ker, thickness: 1.6pt))

  f.arrow(O, v, stroke: (paint: c-v, thickness: 0.9pt))
  f.arrow(O, fv, stroke: (paint: c-res, thickness: 0.9pt))

  f.label-at(v, $bold(v)$, color: c-v, anchor: "south", padding: 0.1)
  f.label-at(fv, $f(bold(v))$, color: c-res, anchor: "north", padding: 0.1)
  f.label-at(
    (3.5, 0),
    $op("Im")(f)$,
    color: c-img,
    anchor: "south",
    padding: 0.1,
  )
  f.label-at(
    (0, 2.6),
    $ker(f)$,
    color: c-ker,
    anchor: "east",
    padding: 0.1,
  )
  f.label-at(
    (3.6, 3.6),
    $f(x, y) = (x, 0)$,
    color: c-axis,
    anchor: "west",
    padding: 0.1,
  )
}

#starlight.frame(
  cetz.canvas(draw()),
)
