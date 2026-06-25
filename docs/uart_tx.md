# UART Transmitter

## Objective

The UART transmitter converts 8-bit parallel data into a serial bit stream following the UART 8N1 protocol.

Frame format:

```
Idle  Start  D0 D1 D2 D3 D4 D5 D6 D7  Stop  Idle
 1      0     b  b  b  b  b  b  b  b    1     1
```

- Idle line is HIGH
- Start bit is LOW
- 8 data bits are transmitted LSB first
- One stop bit is transmitted HIGH

---

## Inputs and Outputs

| Signal       | Direction            | Description                        |
|--------------|----------------------|------------------------------------|
| clk          | Input                | System clock                       |
| rst          | Input                | Active-high reset                  |
| tx_start     | Input                | Starts a transmission              |
| data_in[7:0] | Input                | Parallel byte to transmit          |
| tx           | Output               | Serial transmit line               |
| tx_busy      | Output               | Indicates transmitter is busy      |
| tx_done      | Output               | Pulses when transmission completes |

---

## Architecture

The transmitter consists of:

- Baud Generator
- Finite State Machine (FSM)
- 8-bit Shift Register
- 3-bit Bit Counter

```
           data_in
              │
              ▼
      ┌─────────────-─--┐
      │ Shift Register  │
      └──────┬─────---──┘
             │
             ▼
        UART FSM ─────────► tx
             ▲
             │
      Baud Generator
```

---

## FSM States

### IDLE

- TX line remains HIGH.
- Waits for `tx_start`.
- Loads `data_in` into the shift register.
- Resets the bit counter.
- Transitions to START.

---

### START

- Drives TX LOW.
- Holds the start bit for one baud period.
- Transitions to DATA.

---

### DATA

For every `baud_tick`:

1. Output `shift_reg[0]`.
2. Shift register right by one bit.
3. Increment bit counter.

After transmitting eight bits:

```
bit_count == 7
```

Transition to STOP.

---

### STOP

- Drives TX HIGH.
- Holds the stop bit for one baud period.
- Generates `tx_done`.
- Returns to IDLE.

---

## Shift Register Operation

The transmitter sends the Least Significant Bit (LSB) first.

Example:

```
data_in = 8'b10110010
```

Transmission order:

```
0
1
0
0
1
1
0
1
```

After each baud tick:

```
tx <= shift_reg[0]
shift_reg <= shift_reg >> 1
```

This exposes the next bit to be transmitted.

---

## Baud Timing

The transmitter advances only when a `baud_tick` is received from the baud generator.

Each state corresponding to a UART bit (START, DATA, STOP) is held for exactly one baud period.

---

## Simulation

Simulation verified:

- Correct state transitions.
- Correct LSB-first transmission.
- One start bit.
- Eight data bits.
- One stop bit.
- Proper assertion of `tx_busy` and `tx_done`.

---

## What I Learned

- Designing sequential hardware using an FSM.
- Using a shift register for serial transmission.
- Why UART transmits LSB first.
- Importance of baud timing for asynchronous communication.
- Interaction between counters, state machines, and non-blocking assignments.