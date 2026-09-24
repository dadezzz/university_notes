#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Shows a circular buffer implementation for asynchronous I/O, guidelines for minimal interrupt handlers, and hardware like PIC, NVIC, and nested interrupts.",
  lang: "en",
  title: "Circular buffers and interrupt handling basics",
))

= Circular buffers

The program example from yesterday was inefficient since the main thread still
used polling.

Circular buffers are simple data structures that allow saving some of the
written data in memory, so that the main thread has time to wake up and process
it in batches.

```c
#define BUF_SIZE 8

char io_buf[BUF_SIZE]; /* character buffer */
int buf_head = 0, buf_tail = 0; /* current position in buffer */
int error = 0; /* set to 1 if buffer ever overflows */

int buffer_empty() { /* returns TRUE if buffer is empty */
    return buf_head == buf_tail;
}

int buffer_full() { /* returns TRUE if buffer is full */
    return (buf_tail+1) % BUF_SIZE == buf_head ;
}

int nchars() { /* returns the number of characters in the buffer */
    if (buf_tail >= buf_head)
        return buf_tail - buf_head;
    else
        return BUF_SIZE - buf_head + buf_tail;
}

void buffer_put(char achar) { /* add a character to the buffer tail */
    io_buf[buf_tail++] = achar;

    /* check pointer */
    if (buf_tail == BUF_SIZE)
        buf_tail = 0;
}

char buffer_get() { /* take a character from the buffer head */
    char achar;
    achar = io_buf[buf_head++];

    /* check pointer */
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

Interrupt handlers should do the minimal required amount of work, like capturing
or delivering the data and then returning.

Specifically, they must strive to clear the interrupt source before another
interrupt can be triggered.

Blocking calls and expensive loops should be avoided, and more expensive
processing should be done in the foreground (on the main thread) or be deferred.

== Hardware implementation

The CPU checks the interrupt request (IRQ) line at every instruction. If an
interrupt request has been asserted, the CPU puts the return address on a stack,
and sets the PC to the beginning of the corresponding interrupt handler.

Most systems have more than one I/O device, so multiple devices can interrupt at
the same time. Priorities can be given to ensure the CPU handles the most
important operations first.

The Programmable Interrupt Controller (PIC) allows prioritizing multiple
interrupt sources so that at any time the highest priority interrupt is
presented to the CPU core for processing.

The Cortex-M integrates this function in the NVIC.

== Nested interrupts

A higher priority interrupt source can preempt not only code running in the main
thread, but also the routine of a lower priority interrupt.

Pending status registers record which interrupt sources are awaiting service.

Non-maskable interrupts are interrupts that cannot be masked (disabled) by the
processor. Usually they are also the interrupts with the highest priority and
they are reserved for critical tasks.

== Overhead of interrupts

An interrupt causes a change in the program counter and the saving of some
registers, which incurs a branch penalty and the use of some extra clock cycles.

The interrupt response time is the time it takes the hardware to respond and
process the interrupt. It cannot be changed by the programmer.
