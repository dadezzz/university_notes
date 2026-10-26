#import "../../_templates/frames.typ" as f
#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let draw() = {
  import cetz.draw: *

  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-p1 = color.hsl(210deg, 50%, 50%)
  let c-p2 = color.hsl(150deg, 50%, 50%)
  let c-p3 = color.hsl(330deg, 50%, 50%)
  let c-line = color.hsl(30deg, 60%, 50%)

  f.axes3d(6, 5, 5, stroke: (paint: c-axis, thickness: 0.2pt))

  let r_start = (3, 0, 2)
  let r_end = f.vadd(r_start, (0, 4, 0))
  let p_half_len = 2

  f.plane(
    f.vsub(r_start, (0, 0, p_half_len)),
    f.vadd(r_start, (0, 0, p_half_len)),
    f.vadd(r_end, (0, 0, p_half_len)),
    f.vsub(r_end, (0, 0, p_half_len)),
    fill: c-p1,
  )
  f.plane(
    f.vsub(r_start, (p_half_len, 0, 0)),
    f.vadd(r_start, (p_half_len, 0, 0)),
    f.vadd(r_end, (p_half_len, 0, 0)),
    f.vsub(r_end, (p_half_len, 0, 0)),
    fill: c-p2,
  )
  f.plane(
    f.vsub(r_start, (calc.sqrt(p_half_len), 0, -calc.sqrt(p_half_len))),
    f.vadd(r_start, (calc.sqrt(p_half_len), 0, -calc.sqrt(p_half_len))),
    f.vadd(r_end, (calc.sqrt(p_half_len), 0, -calc.sqrt(p_half_len))),
    f.vsub(r_end, (calc.sqrt(p_half_len), 0, -calc.sqrt(p_half_len))),
    fill: c-p3,
  )

  // Line r: intersection of pi_1 and pi_2.
  line(r_start, f.vadd(r_start, (0, 4, 0)), stroke: (
    paint: c-line,
    thickness: 1.2pt,
  ))
  f.label-at((3, 2, 2), $r$, color: c-line, anchor: "south", padding: 0.1)

  f.label-at(
    f.vadd(r_start, (0, 0, p_half_len)),
    $pi_1$,
    color: c-p1,
    anchor: "west",
    padding: 0.1,
  )
  f.label-at(
    f.vadd(r_start, (p_half_len, 0, 0)),
    $pi_2$,
    color: c-p2,
    anchor: "west",
    padding: 0.1,
  )
  f.label-at(
    f.vadd(r_start, (calc.sqrt(p_half_len), 0, -calc.sqrt(p_half_len))),
    $pi_3$,
    color: c-p3,
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
