#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-v = color.hsl(210deg, 60%, 50%)
  let c-w = color.hsl(150deg, 50%, 50%)
  let c-sum = color.hsl(30deg, 60%, 50%)

  f.axes2d(6, 4, stroke: (paint: c-axis, thickness: 0.2pt))

  let O = (0, 0)
  let v = (4, 0.9)
  let w = (1.0, 2.4)
  let s = f.vadd(v, w)

  // Parallelogram rule: the same sum is reached from both tips.
  line(v, s, stroke: (paint: c-w, thickness: 0.6pt, dash: "dashed"))
  line(w, s, stroke: (paint: c-v, thickness: 0.6pt, dash: "dashed"))

  f.arrow(O, v, stroke: (paint: c-v, thickness: 0.8pt))
  f.arrow(O, w, stroke: (paint: c-w, thickness: 0.8pt))
  f.arrow(O, s, stroke: (paint: c-sum, thickness: 1pt))

  f.label-at(v, $bold(v)$, color: c-v, anchor: "north-west")
  f.label-at(w, $bold(w)$, color: c-w, padding: 0.1, anchor: "north-west")
  f.label-at(
    s,
    $bold(v) + bold(w)$,
    color: c-sum,
    padding: 0.1,
    anchor: "south-east",
  )
}

#starlight.frame(
  cetz.canvas(draw()),
)
