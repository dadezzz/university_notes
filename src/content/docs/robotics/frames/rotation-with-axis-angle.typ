#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.3"

#let in-frame(rz: 0deg, ry: 0deg, body) = cetz.draw.group({
  cetz.draw.rotate(z: rz)
  cetz.draw.rotate(y: ry)
  body
})

#let draw() = {
  import cetz.draw: *

  // ---- Colors ----
  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-frame1 = color.hsl(210deg, 60%, 50%)
  let c-k = color.hsl(280deg, 60%, 45%)
  let c-vec = color.hsl(10deg, 65%, 50%)
  let c-deriv = color.hsl(35deg, 80%, 55%)
  let c-angle = color.hsl(150deg, 45%, 45%)

  // ---- Parameters ----
  let a_ang = 40deg // alpha: rotation about z
  let b_ang = 38deg // beta: rotation about y
  let phi = 220deg // angle of v in the x1-y1 plane
  let t_ang = 60deg // theta
  let r = 3.0 // |v|
  let len0 = 6
  let len1 = 5
  let lenk = 4

  let O = (0, 0, 0)

  // ---- Polar helpers (local xy-plane) ----
  let polar(rad, t) = (rad * calc.cos(t), rad * calc.sin(t), 0)
  let arc-pts(rad, t0, t1) = range(25).map(i => polar(
    rad,
    t0 + (t1 - t0) * i / 24,
  ))

  let s0 = (paint: c-axis, thickness: 0.5pt)
  let m0 = (end: ">", fill: c-axis)
  let guide = (paint: c-deriv, thickness: 0.7pt, dash: "dotted")

  // ---- Frame 0 ----
  line(O, (len0, 0, 0), stroke: s0, mark: m0)
  line(O, (0, len0, 0), stroke: s0, mark: m0)
  line(O, (0, 0, len0), stroke: s0, mark: m0)
  content((len0, 0, 0), padding: 0.1, anchor: "west", text(fill: c-axis, $x$))
  content((0, len0, 0), padding: 0.1, anchor: "east", text(fill: c-axis, $y$))
  content((0, 0, len0), padding: 0.1, anchor: "south", text(fill: c-axis, $z$))

  // ---- alpha arc (frame 0, xy plane) ----
  let ar = 1.6
  line(
    ..arc-pts(ar, 0deg, a_ang),
    stroke: (paint: c-deriv, thickness: 0.8pt),
    mark: (end: ">", fill: c-deriv),
  )
  content(polar(ar * 1.3, a_ang / 2), anchor: "center", text(
    fill: c-deriv,
    $alpha$,
  ))

  // ---- Vertical plane through k: alpha applied, local xz-plane ----
  in-frame(rz: a_ang, {
    let kp = (lenk * calc.sin(b_ang), 0, 0) // projection of k on xy
    line(O, kp, stroke: guide)

    let br = 1.8
    line(
      ..range(21).map(i => {
        let t = b_ang * i / 20
        (br * calc.sin(t), 0, br * calc.cos(t))
      }),
      stroke: (paint: c-deriv, thickness: 0.9pt),
      mark: (end: ">", fill: c-deriv),
    )
    let bm = b_ang / 2
    content(
      (br * calc.sin(bm), 0.05, br * calc.cos(bm)),
      anchor: "south",
      padding: 0.2,
      text(fill: c-deriv, $beta$),
    )
  })

  // ---- Frame 1: z1 = k, everything below is in frame 1 coordinates ----
  in-frame(rz: a_ang, ry: b_ang, {
    // axes
    let s1 = (paint: c-frame1, thickness: 0.5pt, dash: "dashed")
    let m1 = (end: ">", fill: c-frame1)
    line(O, (len1, 0, 0), stroke: s1, mark: m1)
    line(O, (0, len1, 0), stroke: s1, mark: m1)
    line(O, (0, 0, len1), stroke: s1, mark: m1)
    content((len1, 0, 0), padding: 0.1, anchor: "north", text(
      fill: c-frame1,
      $x_1$,
    ))
    content((0, len1, 0), padding: 0.1, anchor: "east", text(
      fill: c-frame1,
      $y_1$,
    ))
    content((0, 0, len1), padding: 0.1, anchor: "south-east", text(
      fill: c-frame1,
      $z_1$,
    ))

    // k = z1
    line(
      O,
      (0, 0, lenk),
      stroke: (paint: c-k, thickness: 1.2pt),
      mark: (end: ">", fill: c-k),
    )
    content((0, 0, lenk), padding: 0.15, anchor: "east", text(
      fill: c-k,
      $bold(k)$,
    ))

    // rotation circle (faint)
    line(
      ..range(61).map(i => polar(r, 360deg * i / 60)),
      stroke: (
        paint: c-angle.transparentize(55%),
        thickness: 0.6pt,
        dash: "dashed",
      ),
    )

    // theta arc
    line(
      ..arc-pts(1.65, phi, phi + t_ang),
      stroke: (paint: c-angle, thickness: 1.2pt),
      mark: (end: ">", fill: c-angle),
    )
    content(polar(2.1, phi + t_ang / 2), anchor: "center", text(
      fill: c-angle,
      $theta$,
    ))

    // v and R_k(theta) v
    let v = polar(r, phi)
    let vp = polar(r, phi + t_ang)
    let sv = (paint: c-vec, thickness: 1.2pt)
    let mv = (end: ">", fill: c-vec)
    line(O, v, stroke: sv, mark: mv)
    line(O, vp, stroke: sv, mark: mv)
    content(v, padding: 0.15, anchor: "south-west", text(
      fill: c-vec,
      $bold(v)$,
    ))
    content(vp, padding: 0.15, anchor: "west", text(
      fill: c-vec,
      $bold(R)_bold(k)(theta) bold(v)$,
    ))
  })
}

#figure(
  starlight.frame(
    cetz.canvas(
      cetz.draw.perspective(
        y: 120deg,
        z: 180deg,
        x: -20deg,
        cetz.draw.on-xz(draw()),
      ),
    ),
  ),
  caption: [Frame 0 in gray and frame 1 in blue],
  numbering: none,
)
