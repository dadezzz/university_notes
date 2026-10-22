#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

// Applies a translation and a sequence of rotations to a drawing group, so the
// body can be written in the frame's own coordinates.
#let in-frame(
  t: (0, 0, 0),
  rz: 0deg,
  ry: 0deg,
  rx: 0deg,
  body,
) = cetz.draw.group({
  cetz.draw.translate(t)
  cetz.draw.rotate(z: rz)
  cetz.draw.rotate(y: ry)
  cetz.draw.rotate(x: rx)
  body
})

#let draw() = {
  import cetz.draw: *

  // ---- Helpers ----
  let mid(a, b, dz: 0) = (
    (a.at(0) + b.at(0)) / 2,
    (a.at(1) + b.at(1)) / 2,
    (a.at(2) + b.at(2)) / 2 + dz,
  )
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
  // Three axes of a frame located at `origin`, labelled with `labels`.
  let axes(origin, len, c, labels) = {
    let stroke = (paint: c, thickness: 0.4pt)
    let mark = (end: ">", fill: c)
    let x-end = (origin.at(0) + len, origin.at(1), origin.at(2))
    let y-end = (origin.at(0), origin.at(1) + len, origin.at(2))
    let z-end = (origin.at(0), origin.at(1), origin.at(2) + len)
    line(origin, x-end, stroke: stroke, mark: mark)
    line(origin, y-end, stroke: stroke, mark: mark)
    line(origin, z-end, stroke: stroke, mark: mark)
    label-at(x-end, c, labels.at(0), anchor: "west", padding: 0.1)
    label-at(y-end, c, labels.at(1), anchor: "east", padding: 0.1)
    label-at(z-end, c, labels.at(2), anchor: "south", padding: 0.1)
  }

  // ---- Colors ----
  let c-axis = color.hsl(0deg, 0%, 50%) // gray:   original axes
  let c-prime = color.hsl(210deg, 60%, 50%) // blue:   rotated axes
  let c-vec = color.hsl(10deg, 65%, 50%) // red:    vectors
  let c-point = color.hsl(150deg, 45%, 50%) // green:  point P and rigid body

  // ---- Points ----
  let O = (0, 0, 0)
  let O_prime = (6, 2, 3)
  let P = (3, 8, 3)

  // ---- Axes lengths ----
  let len_O = 7
  let len_O_prime = 3

  // ---- Relative rotation of O' ----
  // 40 degrees around z, then 30 degrees around x.
  let a = 40deg
  let b = 30deg

  // ---- Frame O ----
  axes(O, len_O, c-axis, ($x$, $y$, $z$))
  label-at(O, c-axis, $O$, anchor: "north-east", padding: 0.1)

  // ---- Frame O' ----
  in-frame(t: O_prime, rz: a, rx: b, {
    axes((0, 0, 0), len_O_prime, c-prime, ($x'$, $y'$, $z'$))
  })
  label-at(O_prime, c-prime, $O'$, anchor: "north-west", padding: 0.1)

  // ---- Vectors ----
  arrow(O, O_prime, c-vec, 1.0pt)
  label-at(mid(O, O_prime, dz: 0.2), c-vec, $bold(0)bold(0)'$, anchor: "south")

  arrow(O, P, c-vec, 1.0pt)
  label-at(mid(O, P, dz: 0.2), c-vec, $bold(p)$, anchor: "south-east")

  arrow(O_prime, P, c-vec, 1.0pt)
  label-at(mid(O_prime, P, dz: -0.1), c-vec, $bold(p)'$, anchor: "north-east")

  // ---- Point P and rigid body representation ----
  circle(P, radius: 0.2, fill: c-point, stroke: none)
  label-at((P.at(0), P.at(1), P.at(2) + 0.2), c-point, $P$, anchor: "south")
}

#figure(
  starlight.frame(
    cetz.canvas(
      cetz.draw.perspective(
        y: 170deg,
        z: 180deg,
        x: 10deg,
        cetz.draw.on-xz(draw()),
      ),
    ),
  ),
  caption: [Frame $O$, frame $O'$ and object $bold(p)$.],
  numbering: none,
)
