#import "../../_templates/starlight.typ" as starlight
#import "../../_templates/frames.typ" as f
#import "@preview/cetz:0.5.3"

// Boost (step-up) converter: the inductor sits between the input and the switch
// node, the diode carries the inductor current to the output capacitor.
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

  // N-MOSFET drawn vertically: drain on top, source at the bottom, gate stub
  // pointing to the left.
  let mosfet_vertical(x, top, bottom, color) = {
    let cy = (top + bottom) / 2
    let s = (top - bottom) / 2
    let at(p) = (x + p.at(0) * s, cy + p.at(1) * s)
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

  let inductor(pos, color) = {
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
  let diode_horizontal(xleft, xright, y, color) = {
    let xmid = (xleft + xright) / 2
    let h = 0.26
    let w = 0.32
    wire((xleft, y), (xmid - h, y))
    wire((xmid + h, y), (xright, y))
    f.plane(
      (xmid - h, y - w),
      (xmid - h, y + w),
      (xmid + h, y),
      fill: color,
      stroke: (thickness: 0.9pt),
    )
    line(
      (xmid + h, y - w),
      (xmid + h, y + w),
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
  inductor((1, ytop), c-comp)
  wire((3, ytop), (4, ytop))
  node((4, ytop))

  // // Switch from the inductor node to ground.
  wire((4, ymid + 1), (4, ytop))
  mosfet_vertical(4, ymid + 1, ymid - 1, c-comp)
  wire((4, ymid - 1), (4, ybot), (0, ybot), (0, ymid - 0.3))

  diode_horizontal(4, 6, ytop, c-comp)
  node((6, ytop))
  capacitor_vertical(6, ytop, ybot, c-comp)
  wire((4, ybot), (6, ybot))

  // // Output terminal.
  wire((6, ytop), (7, ytop))
  f.label-at(
    (7, ytop + 0.1),
    $V_("out")$,
    anchor: "south",
    color: c-wire,
  )

  ground(4, ybot)

  // // Logic driving the gate.
  line(
    (2.5, ymid),
    (3, ymid),
    stroke: (paint: c-logic, thickness: 0.7pt, dash: "dashed"),
    mark: (end: ">", fill: c-logic),
  )
  rect(
    (1.3, ymid + 0.25),
    (2.5, ymid - 0.25),
    stroke: (paint: c-logic, thickness: 0.8pt),
    fill: c-logic.transparentize(90%),
  )
  f.label-at((1.9, ymid), "logica", color: c-logic)
}

#starlight.frame(
  cetz.canvas(draw()),
)
