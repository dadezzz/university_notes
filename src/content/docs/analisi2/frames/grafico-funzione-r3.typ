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

  // ---- Colors ----
  let c-axis = color.hsl(0deg, 0, 50%)
  let c-domain = color.hsl(150deg, 50%, 50%)
  let c-surface = color.hsl(210deg, 50%, 50%)
  let c-highlight = color.hsl(30deg, 50%, 50%)

  // ---- Function and Domain ----
  let f(x, y) = (2 + calc.sin(x) * calc.cos(y))
  let xmin = 1
  let xmax = 5
  let ymin = 1
  let ymax = 5

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
  let nu = 10
  let nv = 20
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
  label-at(
    (xmin - 0.2, ymax, f(xmin, ymax)),
    c-surface,
    $G_f$,
    anchor: "east",
  )

  // ---- Highlighted Example ----
  let x0 = xmax * 0.7
  let y0 = ymax * 0.7
  let p0 = (x0, y0, 0)
  let p1 = (x0, y0, f(x0, y0))

  // Dashed projection line
  line(p0, p1, stroke: (paint: c-highlight, thickness: 0.8pt, dash: "dashed"))

  // Dots
  circle(p0, radius: 0.07, fill: c-highlight)
  circle(p1, radius: 0.07, fill: c-highlight)

  // Labels for the point on the domain and on the surface
  let p0_lab = (p0.at(0) + 3, p0.at(1), p0.at(2))
  line(p0_lab, p0, stroke: (paint: c-highlight, thickness: 0.5pt))
  label-at(
    p0_lab,
    c-highlight,
    $(x_0, y_0)$,
    anchor: "west",
    padding: 0.1,
  )

  let p1_lab = (p1.at(0) + 3, p1.at(1), p1.at(2))
  line(p1_lab, p1, stroke: (paint: c-highlight, thickness: 0.5pt))
  label-at(
    p1_lab,
    c-highlight,
    $(x_0, y_0, f(x_0, y_0))$,
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
