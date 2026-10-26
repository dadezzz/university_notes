#import "@preview/cetz:0.5.3"

#let label-at(
  pos,
  body,
  color: black,
  anchor: "center",
  padding: 0,
) = cetz.draw.content(
  pos,
  anchor: anchor,
  padding: padding,
  text(fill: color, body),
)

#let arrow(from, to, stroke: (:)) = cetz.draw.line(
  from,
  to,
  stroke: stroke,
  mark: (end: ">", fill: stroke.paint),
)

#let axes2d(x-len, y-len, stroke: (:)) = {
  arrow((0, 0), (x-len, 0), stroke: stroke)
  arrow((0, 0), (0, y-len), stroke: stroke)
  label-at(
    (x-len, 0),
    $x$,
    color: stroke.paint,
    anchor: "west",
    padding: 0.1,
  )
  label-at(
    (0, y-len),
    $y$,
    color: stroke.paint,
    anchor: "east",
    padding: 0.1,
  )
}

#let axes3d(x-len, y-len, z-len, stroke: (:)) = {
  arrow((0, 0, 0), (x-len, 0, 0), stroke: stroke)
  arrow((0, 0, 0), (0, y-len, 0), stroke: stroke)
  arrow((0, 0, 0), (0, 0, z-len), stroke: stroke)
  label-at(
    (x-len, 0, 0),
    $x$,
    color: stroke.paint,
    anchor: "west",
    padding: 0.1,
  )
  label-at(
    (0, y-len, 0),
    $y$,
    color: stroke.paint,
    anchor: "east",
    padding: 0.1,
  )
  label-at(
    (0, 0, z-len),
    $z$,
    color: stroke.paint,
    anchor: "south",
    padding: 0.1,
  )
}

#let plane(
  ..vertices,
  fill: black,
  stroke: (:),
) = cetz.draw.line(
  ..vertices,
  close: true,
  fill: fill.transparentize(90%),
  stroke: (thickness: 0.4pt, ..stroke, paint: fill),
)

#let point(pos, fill: black) = cetz.draw.circle(
  pos,
  radius: 0.07,
  stroke: fill,
  fill: fill,
)

#let vadd(a, b) = a.zip(b).map(i => i.at(0) + i.at(1))
#let vscale(k, a) = a.map(i => k * i)
#let vsub(a, b) = vadd(a, vscale(-1, b))
#let vnorm(a) = calc.sqrt(a.map(i => calc.pow(i, 2)).sum())
#let vdot(a, b) = a.zip(b).map(i => i.at(0) * i.at(1)).sum()

#let vcross(a, b) = (
  a.at(1) * b.at(2) - a.at(2) * b.at(1),
  a.at(2) * b.at(0) - a.at(0) * b.at(2),
  a.at(0) * b.at(1) - a.at(1) * b.at(0),
)
