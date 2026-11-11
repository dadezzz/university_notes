#import "../../_templates/starlight.typ" as starlight
#import "../../_templates/frames.typ" as f
#import "@preview/cetz:0.5.3"

// Buck (step-down) converter: the transistor is in series with the inductor and
// the freewheeling diode closes the circuit when it opens.
#let draw() = {
  import cetz.draw: *

  let c-wire = color.hsl(0deg, 0%, 50%)
  let c-comp = color.hsl(210deg, 60%, 50%)
  let c-logic = color.hsl(270deg, 40%, 50%)

  let wire(..pts) = line(
    ..pts,
    stroke: (paint: c-wire, thickness: 0.9pt),
  )
  let node(pos) = circle(pos, radius: 0.055, stroke: none, fill: c-wire)
  let ground(x, y) = {
    let w_len = 0.2
    wire((x, y), (x, y - w_len))
    line(
      (x + 0.24, y - w_len),
      (x - 0.24, y - w_len),
      stroke: (paint: c-wire, thickness: 0.9pt),
    )
    line(
      (x - 0.15, y - w_len - 0.1),
      (x + 0.15, y - w_len - 0.1),
      stroke: (paint: c-wire, thickness: 0.9pt),
    )
    line(
      (x - 0.07, y - w_len - 0.2),
      (x + 0.07, y - w_len - 0.2),
      stroke: (paint: c-wire, thickness: 0.9pt),
    )
  }

  // Source between the top rail and ground.
  let v_generator(top, bot, color) = {
    let xmid = (top.at(0) + bot.at(0)) / 2
    let ymid = (top.at(1) + bot.at(1)) / 2
    let r = (top.at(1) - bot.at(1)) / 2

    circle((xmid, ymid), radius: r, stroke: (paint: color, thickness: 0.9pt))
    line(
      (xmid, ymid - r),
      (xmid, ymid + r),
      stroke: (paint: color, thickness: 0.7pt),
      mark: (end: ">", fill: color, scale: 0.5),
    )
  }

  // N-MOSFET drawn horizontally: drain on the left, source on the right,
  // gate stub pointing down.
  let mosfet_horizontal(left, right, y, color) = {
    let cx = (left + right) / 2
    let s = (left - right) / 2
    // Coordinates are inverted since this was copied from the vertical mosfet.
    let at(p) = (cx + p.at(1) * s, y + p.at(0) * -s)
    line(
      at((0, 1)),
      at((0, 0.3)),
      at((-0.35, 0.3)),
      stroke: (paint: color, thickness: 0.9pt),
    )
    line(
      at((0, -1)),
      at((0, -0.3)),
      at((-0.35, -0.3)),
      stroke: (paint: color, thickness: 0.9pt),
    )
    for (a, b) in (
      ((-0.35, 0.18), (-0.35, 0.42)),
      ((-0.35, -0.12), (-0.35, 0.12)),
      ((-0.35, -0.42), (-0.35, -0.18)),
    ) {
      line(at(a), at(b), stroke: (paint: color, thickness: 1.1pt))
    }
    line(
      at((-0.51, -0.42)),
      at((-0.51, 0.42)),
      stroke: (paint: color, thickness: 0.9pt),
    )
    line(at((-0.51, 0)), at((-0.9, 0)), stroke: (
      paint: color,
      thickness: 0.9pt,
    ))
  }

  let inductor_horizontal(pos, color) = {
    let r = 0.25
    for i in range(4) {
      arc(
        (pos.at(0) + r + (2 * (r * i)), pos.at(1)),
        anchor: "origin",
        start: 0deg,
        stop: 180deg,
        radius: r,
        stroke: (paint: color, thickness: 0.9pt),
      )
    }
  }

  // Horizontal diode, anode on the left, cathode on the right.
  let diode_vertical(x, ytop, ybot, color) = {
    let ymid = (ytop + ybot) / 2
    let h = 0.26
    let w = 0.32
    wire((x, ytop), (x, ymid + h))
    wire((x, ymid - h), (x, ybot))
    f.plane(
      (x - w, ymid - h),
      (x + w, ymid - h),
      (x, ymid + h),
      fill: color,
      stroke: (thickness: 0.9pt),
    )
    line(
      (x - w, ymid + h),
      (x + w, ymid + h),
      stroke: (paint: color, thickness: 1.2pt),
    )
  }

  // Vertical capacitor.
  let capacitor_vertical(x, ytop, ybot, c) = {
    let ym = (ytop + ybot) / 2
    let g = 0.1
    wire((x, ytop), (x, ym + g))
    wire((x, ym - g), (x, ybot))
    line(
      (x - 0.4, ym + g),
      (x + 0.4, ym + g),
      stroke: (paint: c, thickness: 1.2pt),
    )
    line(
      (x - 0.4, ym - g),
      (x + 0.4, ym - g),
      stroke: (paint: c, thickness: 1.2pt),
    )
  }

  let ytop = 3
  let ybot = 0
  let ymid = (ytop - ybot) / 2

  v_generator((0, ymid + 0.5), (0, ymid - 0.5), c-wire)
  f.label-at(
    (0, ymid),
    [$V_("in")$],
    color: c-wire,
    anchor: "east",
    padding: 0.6,
  )

  wire((0, ymid), (0, ytop), (1, ytop))
  mosfet_horizontal(1, 3, ytop, c-comp)
  wire((3, ytop), (4, ytop))
  node((4, ytop))

  wire((4, ymid + 1), (4, ytop))
  wire((4, ymid - 1), (4, ybot), (0, ybot), (0, ymid - 0.3))

  wire((4, ytop), (5, ytop))
  inductor_horizontal((5, ytop), c-comp)
  wire((7, ytop), (8, ytop))

  diode_vertical(4, ytop, ybot, c-comp)
  node((8, ytop))
  capacitor_vertical(8, ytop, ybot, c-comp)
  wire((4, ybot), (8, ybot))

  // // Output terminal.
  wire((8, ytop), (9, ytop))
  f.label-at(
    (9, ytop + 0.1),
    $V_("out")$,
    anchor: "south",
    color: c-wire,
  )

  ground(4, ybot)

  // // Logic driving the gate.
  line(
    (2, ytop - 1.5),
    (2, ytop - 1),
    stroke: (paint: c-logic, thickness: 0.7pt, dash: "dashed"),
    mark: (end: ">", fill: c-logic),
  )
  rect(
    (1.4, ytop - 1.5),
    (2.6, ytop - 2),
    stroke: (paint: c-logic, thickness: 0.8pt),
    fill: c-logic.transparentize(90%),
  )
  f.label-at((2, ytop - 1.75), "logica", color: c-logic)
}

#starlight.frame(
  cetz.canvas(draw()),
)
