#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#starlight.frame(
  cetz.canvas({
    import cetz.draw: *

    // ---- Colors ----
    let c-axis = color.hsl(0deg, 0, 50%)
    let c-domain = color.hsl(150deg, 50%, 50%)
    let c-surface = color.hsl(210deg, 50%, 50%)
    let c-highlight = color.hsl(30deg, 50%, 50%)

    // ---- Projection ----
    let scale_x = 1
    let depth_x = 0.4
    let scale_y = -1
    let depth_y = 0.4
    let scale_z = 1
    let p3(x, y, z) = (
      scale_x * x + depth_x * scale_y * y,
      scale_z * z + depth_y * scale_y * y,
    )

    // ---- Function and Domain ----
    let f(x, y) = (2 + calc.sin(x) * calc.cos(y))
    let xmin = 1
    let xmax = 5
    let ymin = 1
    let ymax = 5

    // ---- Axes ----
    line(
      p3(0, 0, 0),
      p3(7, 0, 0),
      stroke: (paint: c-axis, thickness: 0.2pt),
      mark: (end: ">", fill: c-axis),
    )
    line(
      p3(0, 0, 0),
      p3(0, 7, 0),
      stroke: (paint: c-axis, thickness: 0.2pt),
      mark: (end: ">", fill: c-axis),
    )
    line(
      p3(0, 0, 0),
      p3(0, 0, 4),
      stroke: (paint: c-axis, thickness: 0.2pt),
      mark: (end: ">", fill: c-axis),
    )

    // Axis labels
    content(p3(7.1, 0, 0), text(fill: c-axis, $x$), anchor: "west")
    content(p3(0, 7.5, 0), text(fill: c-axis, $y$), anchor: "west")
    content(p3(0, 0, 4.1), text(fill: c-axis, $z$), anchor: "south")

    // ---- Domain A ----
    line(
      p3(xmin, ymin, 0),
      p3(xmax, ymin, 0),
      p3(xmax, ymax, 0),
      p3(xmin, ymax, 0),
      close: true,
      stroke: (paint: c-domain, thickness: 0.3pt),
      fill: c-domain.transparentize(90%),
    )
    content(
      p3(xmax + 0.5, ymax + 0.5, 0),
      text(fill: c-domain, $A$),
      anchor: "center",
    )

    // ---- Surface G_f ----
    for xi in range(0, 11) {
      let x = xmin + (xmax - xmin) * xi / 10
      let pts = ()
      for yi in range(0, 21) {
        let y = ymin + (ymax - ymin) * yi / 20
        pts.push(p3(x, y, f(x, y)))
      }
      line(..pts, stroke: (paint: c-surface, thickness: 0.3pt))
    }
    for yi in range(0, 11) {
      let y = ymin + (ymax - ymin) * yi / 10
      let pts = ()
      for xi in range(0, 21) {
        let x = xmin + (xmax - xmin) * xi / 20
        pts.push(p3(x, y, f(x, y)))
      }
      line(..pts, stroke: (paint: c-surface, thickness: 0.3pt))
    }
    content(
      p3(xmin - 0.2, ymax, f(xmin, ymax)),
      text(fill: c-surface, $G_f$),
      anchor: "east",
    )

    // ---- Highlighted Example ----
    let x0 = xmax * 0.7
    let y0 = ymax * 0.7
    let p0 = p3(x0, y0, 0)
    let p1 = p3(x0, y0, f(x0, y0))

    // Dashed projection line
    line(p0, p1, stroke: (paint: c-highlight, thickness: 0.8pt, dash: "dashed"))

    // Dots
    circle(p0, radius: 0.07, fill: c-highlight)
    circle(p1, radius: 0.07, fill: c-highlight)

    // Label for (x0, y0)
    let p0_lab = (p0.at(0) + 3, p0.at(1) + 0.2)
    line(p0_lab, p0, stroke: (paint: c-highlight, thickness: 0.5pt))
    content(
      (p0_lab.at(0) + 0.1, p0_lab.at(1)),
      text(fill: c-highlight, $(x_0, y_0)$),
      anchor: "west",
    )

    // Label for (x0, y0, f(x0, y0))
    let p1_lab = (p1.at(0) + 3, p1.at(1) + 0.2)
    line(p1_lab, p1, stroke: (paint: c-highlight, thickness: 0.5pt))
    content(
      (p1_lab.at(0) + 0.1, p1_lab.at(1)),
      text(fill: c-highlight, $(x_0, y_0, f(x_0, y_0))$),
      anchor: "west",
    )
  }),
)
