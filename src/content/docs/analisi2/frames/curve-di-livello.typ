#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

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
  let axes3d(x-len, y-len, z-len, c) = {
    arrow((0, 0, 0), (x-len, 0, 0), c, 0.2pt)
    arrow((0, 0, 0), (0, y-len, 0), c, 0.2pt)
    arrow((0, 0, 0), (0, 0, z-len), c, 0.2pt)
    label-at((x-len, 0, 0), c, $x$, anchor: "west", padding: 0.1)
    label-at((0, y-len, 0), c, $y$, anchor: "east", padding: 0.1)
    label-at((0, 0, z-len), c, $z$, anchor: "south", padding: 0.1)
  }
  // Points of the circle of radius `r` around `(cx, cy)` at height `z`.
  let circle-pts(cx, cy, r, z, n) = range(n + 1).map(i => {
    let theta = 2 * calc.pi * i / n
    (cx + r * calc.cos(theta), cy + r * calc.sin(theta), z)
  })

  // ---- Colors ----
  let c-axis = color.hsl(0deg, 0%, 50%)
  let c-domain = color.hsl(150deg, 40%, 50%)
  let c-surface = color.hsl(210deg, 40%, 50%)
  let c-level = color.hsl(30deg, 60%, 50%)
  let c-otherlvl = color.hsl(0deg, 60%, 50%)

  // ---- Function and Domain ----
  let f(x, y) = (
    // Squatted gaussian.
    1 + 2.5 * calc.exp(-0.15 * (calc.pow(x - 3, 2) + calc.pow(y - 3, 2)))
  )

  let xmin = 1
  let xmax = 5
  let ymin = 1
  let ymax = 5

  let xc = xmin + (xmax - xmin) / 2
  let yc = ymin + (ymax - ymin) / 2

  // Level value and the radius of the corresponding circle in the domain.
  let t = 2.8
  let r_of(tt) = calc.sqrt(-calc.ln((tt - 1) / 2.5) / 0.15)
  let r_level = r_of(t)

  // ---- Axes ----
  axes3d(7, 7, 4, c-axis)

  // ---- Domain A ----
  line(
    (xmin, ymin, 0),
    (xmax, ymin, 0),
    (xmax, ymax, 0),
    (xmin, ymax, 0),
    close: true,
    stroke: (paint: c-domain, thickness: 0.3pt),
    fill: c-domain.transparentize(90%),
  )
  label-at((xmax, ymax, 0), c-domain, $A$, anchor: "north-west")

  // ---- Surface G_f ----
  let nu = 12
  let nv = 24
  for xi in range(0, nu + 1) {
    let x = xmin + (xmax - xmin) * xi / nu
    line(
      ..range(0, nv + 1).map(yi => {
        let y = ymin + (ymax - ymin) * yi / nv
        (x, y, f(x, y))
      }),
      stroke: (paint: c-surface, thickness: 0.3pt),
    )
  }
  for yi in range(0, nu + 1) {
    let y = ymin + (ymax - ymin) * yi / nu
    line(
      ..range(0, nv + 1).map(xi => {
        let x = xmin + (xmax - xmin) * xi / nv
        (x, y, f(x, y))
      }),
      stroke: (paint: c-surface, thickness: 0.3pt),
    )
  }
  label-at((xmin - 0.3, ymax, f(xmin, ymax)), c-surface, $G_f$, anchor: "east")

  // ---- Additional level curves on the domain and surface ----
  let n = 72
  for tt in (2.4, 3.2) {
    let rr = r_of(tt)
    line(
      ..circle-pts(xc, yc, rr, 0, n),
      stroke: (paint: c-otherlvl, thickness: 0.8pt, dash: "dashed"),
    )
    line(
      ..circle-pts(xc, yc, rr, tt, n),
      stroke: (paint: c-otherlvl, thickness: 0.8pt, dash: "dashed"),
    )
  }

  // ---- Main level curve C_t (on domain and on surface) ----
  line(
    ..circle-pts(xc, yc, r_level, 0, n),
    stroke: (paint: c-level, thickness: 1pt),
  )
  line(
    ..circle-pts(xc, yc, r_level, t, n),
    stroke: (paint: c-level, thickness: 1pt),
  )

  let ct = circle-pts(xc, yc, r_level, 0, n).at(0)
  let ct_lab = (ct.at(0) + 2, ct.at(1) + 0.2)
  line(ct_lab, ct, stroke: (paint: c-level, thickness: 0.5pt))
  label-at((ct_lab.at(0) + 0.1, ct_lab.at(1)), c-level, $C_t$, anchor: "west")

  // ---- Horizontal slice frame at z = t ----
  line(
    (xmin, ymin, t),
    (xmax, ymin, t),
    (xmax, ymax, t),
    (xmin, ymax, t),
    close: true,
    stroke: (paint: c-level, thickness: 0.3pt, dash: "dashed"),
  )
  label-at((xmax + 0.5, ymax / 2, t), c-level, $z = t$, anchor: "west")

  // ---- Highlighted point on C_t ----
  let theta0 = calc.pi * 5 / 6
  let x0 = xc + r_level * calc.cos(theta0)
  let y0 = yc + r_level * calc.sin(theta0)
  let P0 = (x0, y0, 0)
  let P1 = (x0, y0, t)

  line(P0, P1, stroke: (paint: c-level, thickness: 0.8pt, dash: "dashed"))
  circle(P0, radius: 0.07, fill: c-level)
  circle(P1, radius: 0.07, fill: c-level)
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
