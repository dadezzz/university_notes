#import "../_templates/starlight.typ" as starlight

#show: starlight.setup

#metadata((
  description: "Finite-state machines in C, queues and circular buffers, interrupt vector tables with weak default handlers, and the MSP432 microcontroller low-power modes.",
  lang: "en",
  title: "State machines, queues, interrupts and low power",
))

= Finite state machines

A typical function of an embedded system is reacting to inputs and sleeping when
unused. This reaction can be modeled in terms of the input received and the
current state of the system, i.e. as a finite-state machine (FSM).

```c
typedef enum {
  STATE_A,
  STATE_B,
  STATE_C,
  STATE_D,
  NUM_STATES,
} State_t;

typedef struct {
  State_t state;      // Defines the state.
  void (*func)(void); // Function to execute for each state.
} StateMachine_t;

// Define functions for each state.
// Each function should transition to another state.
void fn_StateA(void);
void fn_StateB(void);
void fn_StateC(void);
void fn_StateD(void);

// Select an initial state.
State_t cur_state = STATE_A;

StateMachine_t StateMachine[] = {
  {STATE_A, fn_StateA},
  {STATE_B, fn_StateB},
  {STATE_C, fn_StateC},
  {STATE_D, fn_StateD}
};

void run(void) {
  if (cur_state < NUM_STATES) {
    (*StateMachine[cur_state].func)();
  } else {
    // error
  }
}
```

= Queues

For data that arrives and departs at unpredictable times, queues are used;
otherwise circular buffers are preferred, since they do not reallocate memory.
Queues are typically implemented as linked lists.

The variable-rate output of one stage may become the variable-rate input of
another, so an embedded system usually contains several buffers and queues.

= Interrupts

The verbose way to define interrupts in C is to directly export the `.intvecs`
section, which holds the interrupt vector table:

```c
#pragma DATA_SECTION(interruptVectors, ".intvecs")
void (* const interruptVectors[])(void) = {
  (void (*)(void))((uint32_t)&__STACK_END), // Initial stack pointer
  reset_ISR, // Reset handler
  nmi_ISR, // NMI handler
  fault_ISR, // Hard fault handler
  mpu_ISR, // MPU fault handler
  busfault_ISR, // Bus fault handler
  // ...
};
```

And in the linker script:

```
SECTIONS {
  .intvecs : > 0x00000000
  .text : > MAIN
  .const : > MAIN
  /* ... */
}
```

An easier way is to set a default handler for all the interrupts, and then
individually override only the relevant ones:

```c
// The attribute tells the compiler that the function can be overridden in user
// code.
void Default_Handler(void) __attribute__((weak));

void Default_Handler(void) {
  // Fault trap exempt from ULP advisor.
  #pragma diag_push
  #pragma CHECK_ULP("-2.1")

  // Enter an infinite loop to leave the system in the failing state for
  // debugging.
  while(1) {
  }

  #pragma diag_pop
}

// Set the default handler for each interrupt, but allow overriding them.
// `extern` tells the compiler that the functions can be defined in other files.
extern void PORT1_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
extern void PORT2_IRQHandler(void) __attribute__((weak, alias("Default_Handler")));
```

= Low-power modes on the MSP432

Different power modes allow optimizing energy consumption for a given
application.

#table(
  columns: 4,
  table.header([*Mode*], [*Description*], [*Active subsystems*], [*Current*]),

  `Active`,
  [Active mode],
  [CPU and peripherals],
  $100 thick upright(mu A \/ M "Hz")$,

  `LPM0`, [Sleep], [Peripherals], $65 thick upright(mu A \/ M "Hz")$,

  `LPM3`,
  [Deep sleep, standby with RAM and RTC],
  [Some peripherals],
  $< 900 thick upright(n A)$,

  `LPM4`,
  [Standby with RAM],
  [No clocks, some peripherals],
  $< 900 thick upright(n A)$,

  `LPM3.5`, [Shutdown], [RTC without RAM], $< 670 thick upright(n A)$,
  `LPM4.5`, [Shutdown], [None], $< 100 thick upright(n A)$,
)
