#import "../../_templates/starlight.typ" as starlight
#import "@preview/cetz:0.5.2"

#starlight.frame(
  cetz.canvas({
    import cetz.draw: *

    // ---- Colors ----
    let c-axis = color.hsl(0deg, 0%, 50%)
    let c-domain = color.hsl(150deg, 40%, 50%)
    let c-surface = color.hsl(210deg, 40%, 50%)
    let c-level = color.hsl(30deg, 60%, 50%)
    let c-otherlvl = color.hsl(0deg, 60%, 50%)

    // ---- Projection ----
    let scale_x = 1
    let depth_x = 0.4
    let scale_y = -1
    let depth_y = 0.25
    let scale_z = 1
    let p3(x, y, z) = (
      scale_x * x + depth_x * scale_y * y,
      scale_z * z + depth_y * scale_y * y,
    )

    // ---- Function and Domain ----
    let f(x, y) = (
      // Squatted gaussian.
      1 + 2.5 * calc.exp(-0.15 * (calc.pow(x - 3, 2) + calc.pow(y - 3, 2)))
    )
    let xmin = 1
    let xmax = 5
    let ymin = 1
    let ymax = 5

    let xc = 3
    let yc = 3

    // Level value and the radius of the corresponding circle in the domain.
    let t = 2.8
    let r_of(tt) = calc.sqrt(-calc.ln((tt - 1) / 2.5) / 0.15)
    let r_level = r_of(t)

    // ---- Axes ----
    line(
      p3(0, 0, 0),
      p3(7, 0, 0),
      stroke: (paint: c-axis, thickness: 0.3pt),
      mark: (end: ">", fill: c-axis),
    )
    line(
      p3(0, 0, 0),
      p3(0, 7, 0),
      stroke: (paint: c-axis, thickness: 0.3pt),
      mark: (end: ">", fill: c-axis),
    )
    line(
      p3(0, 0, 0),
      p3(0, 0, 4),
      stroke: (paint: c-axis, thickness: 0.3pt),
      mark: (end: ">", fill: c-axis),
    )
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
    for xi in range(0, 13) {
      let x = xmin + (xmax - xmin) * xi / 12
      let pts = ()
      for yi in range(0, 25) {
        let y = ymin + (ymax - ymin) * yi / 24
        pts.push(p3(x, y, f(x, y)))
      }
      line(..pts, stroke: (paint: c-surface, thickness: 0.3pt))
    }
    for yi in range(0, 13) {
      let y = ymin + (ymax - ymin) * yi / 12
      let pts = ()
      for xi in range(0, 25) {
        let x = xmin + (xmax - xmin) * xi / 24
        pts.push(p3(x, y, f(x, y)))
      }
      line(..pts, stroke: (paint: c-surface, thickness: 0.3pt))
    }
    content(
      p3(xmin - 0.3, ymax, f(xmin, ymax)),
      text(fill: c-surface, $G_f$),
      anchor: "east",
    )

    // ---- Additional level curves on the domain and surface ----
    let n = 72
    for tt in (2.4, 3.2) {
      let rr = r_of(tt)
      let pts_dom = ()
      let pts_srf = ()
      for i in range(0, n + 1) {
        let theta = 2 * calc.pi * i / n
        pts_dom.push(p3(
          xc + rr * calc.cos(theta),
          yc + rr * calc.sin(theta),
          0,
        ))
        pts_srf.push(p3(
          xc + rr * calc.cos(theta),
          yc + rr * calc.sin(theta),
          tt,
        ))
      }
      line(..pts_dom, stroke: (
        paint: c-otherlvl,
        thickness: 0.8pt,
        dash: "dashed",
      ))
      line(..pts_srf, stroke: (
        paint: c-otherlvl,
        thickness: 0.8pt,
        dash: "dashed",
      ))
    }

    // ---- Main level curve C_t (on domain and on surface) ----
    let pts_dom = ()
    let pts_srf = ()
    for i in range(0, n + 1) {
      let theta = 2 * calc.pi * i / n
      let x = xc + r_level * calc.cos(theta)
      let y = yc + r_level * calc.sin(theta)
      pts_dom.push(p3(x, y, 0))
      pts_srf.push(p3(x, y, t))
    }
    line(..pts_dom, stroke: (paint: c-level, thickness: 1pt))
    line(..pts_srf, stroke: (paint: c-level, thickness: 1pt))

    let ct = pts_dom.at(0)
    let ct_lab = (ct.at(0) + 2, ct.at(1) + 0.2)
    line(ct_lab, ct, stroke: (paint: c-level, thickness: 0.5pt))
    content(
      (ct_lab.at(0) + 0.1, ct_lab.at(1)),
      text(fill: c-level, $C_t$),
      anchor: "west",
    )

    // ---- Horizontal slice frame at z = t ----
    line(
      p3(xmin, ymin, t),
      p3(xmax, ymin, t),
      p3(xmax, ymax, t),
      p3(xmin, ymax, t),
      close: true,
      stroke: (paint: c-level, thickness: 0.3pt, dash: "dashed"),
    )
    content(
      p3(xmax + 0.5, ymax / 2, t),
      text(fill: c-level, $z = t$),
      anchor: "west",
    )

    // ---- Highlighted point on C_t ----
    let theta0 = calc.pi * 5 / 6
    let x0 = xc + r_level * calc.cos(theta0)
    let y0 = yc + r_level * calc.sin(theta0)
    let P0 = p3(x0, y0, 0)
    let P1 = p3(x0, y0, t)

    line(P0, P1, stroke: (paint: c-level, thickness: 0.8pt, dash: "dashed"))
    circle(P0, radius: 0.07, fill: c-level)
    circle(P1, radius: 0.07, fill: c-level)
  }),
)
