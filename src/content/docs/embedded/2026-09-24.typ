#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Circular buffers for asynchronous I/O, guidelines for minimal interrupt handlers, and interrupt hardware such as the PIC and NVIC, including nested interrupts.",
  lang: "en",
  title: "Circular buffers and interrupt handling basics",
))

= Circular buffers

The program example from the previous lecture was inefficient, since the main
thread still relied on polling.

Circular buffers are simple data structures that buffer the data written by the
handler in memory, so that the main thread has time to wake up and process it in
batches.

```c
#define BUF_SIZE 8

// Character buffer, reuses fixed memory.
char io_buf[BUF_SIZE];
// Current position in buffer.
int buf_head = 0, buf_tail = 0;
// Set to 1 if buffer ever overflows.
int error = 0;

// Returns TRUE if buffer is empty.
int buffer_empty() {
    return buf_head == buf_tail;
}

// Returns TRUE if buffer is full.
int buffer_full() {
    return (buf_tail + 1) % BUF_SIZE == buf_head;
}

// Add a character to the buffer tail.
void buffer_put(char achar) {
    io_buf[buf_tail++] = achar;

    if (buf_tail == BUF_SIZE)
        buf_tail = 0;
}

// Take a character from the buffer head.
char buffer_get() {
    char achar;
    achar = io_buf[buf_head++];

    if (buf_head == BUF_SIZE)
        buf_head = 0;

    return achar;
}

void input_handler(void) {
    uint8_t c = IN_DATA;

    if (buffer_full()) {
        error = 1;
    } else {
        bool was_empty = buffer_empty();
        buffer_put(c);
        if (was_empty) start_output();
    }

    IN_STATUS = ACK;
}

void output_handler(void) {
    OUT_STATUS = ACK;

    if (!buffer_empty()) {
        OUT_DATA = buffer_get();
        OUT_CONTROL = START;
    } else {
        stop_output();
    }
}
```

#starlight.caution([
  Using interrupt handlers means writing concurrent code, so precautions must be
  taken to protect the data currently being read or modified.
])

= Interrupt handlers

Interrupt handlers should do the minimum amount of work required, such as
capturing or delivering the data, and then return.

In particular, they should clear the interrupt source so that the same interrupt
is not triggered again.

Blocking calls and long loops should be avoided, and heavier processing should
be done in the foreground (on the main thread) or be deferred.

== Hardware implementation

The CPU samples the interrupt request (IRQ) line after each instruction. If an
interrupt request has been asserted, the CPU puts the return address on the
stack and sets the PC to the beginning of the corresponding interrupt handler.

Most systems have more than one I/O device, so multiple devices can request an
interrupt at the same time. Priorities can be assigned to ensure that the CPU
handles the most important operations first.

The Programmable Interrupt Controller (PIC) allows prioritizing multiple
interrupt sources, so that at any time the highest priority interrupt is
presented to the CPU core for processing.

The Cortex-M integrates this functionality into the Nested Vectored Interrupt
Controller (NVIC).

== Nested interrupts

A higher priority interrupt source can preempt not only code running in the main
thread, but also the routine of a lower priority interrupt.

Pending status registers record which interrupt sources are awaiting service.

Non-maskable interrupts are interrupts that cannot be masked (disabled) by the
processor. Usually they also have the highest priority and are reserved for
critical tasks.

== Overhead of interrupts

An interrupt causes a change in the program counter and the saving of some
registers, which incurs a branch penalty and the use of some extra clock cycles.

The interrupt response time is the time the hardware takes to respond to the
request and start executing the handler. It cannot be changed by the programmer.

= MSP432

The MSP432 is an embedded system development platform that provides a physical
board with an integrated programmer and debugger, along with a series of
software tools to aid the programmer.

#starlight.img("images/msp432-board.png", alt: "MSP432 physical board")

It features:

- an ARM Cortex M4F processor;
- a 100-pin microcontroller chip;
- a mixed-signal processor (MSP): analog + digital;
- $256 thick upright(k B)$ flash memory for instructions;
- $64 thick upright(k B)$ SRAM for data.
