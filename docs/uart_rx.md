# UART Receiver (uart_rx)

## Objective

The UART Receiver receives serial data from the `rx` line and reconstructs it into an 8-bit parallel byte. It validates the start bit, samples each data bit at the correct baud interval, verifies the stop bit, and outputs the received byte along with status signals indicating successful reception or framing errors.

---

## UART Frame Format

```
Idle | Start | D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7 | Stop
  1      0      LSB -----------------------------> MSB     1
```

* Idle line remains HIGH.
* Transmission begins with a LOW start bit.
* Eight data bits are transmitted LSB first.
* A HIGH stop bit marks the end of the frame.

---

## Module Interface

### Inputs

| Signal | Description                   |
| ------ | ----------------------------- |
| `clk`  | System clock                  |
| `rst`  | Active-high synchronous reset |
| `rx`   | UART serial input             |

### Outputs

| Signal          | Description                                     |
| --------------- | ----------------------------------------------- |
| `data_out[7:0]` | Received 8-bit parallel data                    |
| `rx_done`       | One-clock pulse indicating successful reception |
| `rx_busy`       | High while a frame is being received            |
| `framing_error` | Asserted if the stop bit is invalid             |

---

## Internal Architecture

The receiver consists of the following components:

* UART Receiver FSM
* Baud Generator
* Sample Counter
* Bit Counter
* Shift Register

### Sample Counter

When a falling edge is detected on the `rx` line, the receiver enters the START state and waits for half a baud period before sampling the line. If the line is still LOW, the start bit is considered valid; otherwise, the receiver returns to the IDLE state.

### Baud Generator

After confirming a valid start bit, the baud generator is enabled. It produces a baud tick every baud period, allowing the receiver to sample each incoming data bit at the center of its bit period.

### Shift Register

Each sampled bit is inserted into the MSB of the shift register while the existing contents shift right. After eight baud ticks, the shift register contains the reconstructed byte.

---

## FSM Description

### IDLE

* Waits for a falling edge on the `rx` line.
* Holds the baud generator in reset.

### START

* Waits for half a baud period.
* Samples the start bit.
* If the sampled value is LOW, reception begins.
* Otherwise, returns to the IDLE state.

### DATA

* Samples one data bit on every baud tick.
* Shifts the received bit into the shift register.
* Increments the bit counter.
* Transitions to the STOP state after eight bits have been received.

### STOP

* Waits one baud period.
* Samples the stop bit.
* If the stop bit is HIGH:

  * Copies the shift register into `data_out`.
  * Generates a one-clock `rx_done` pulse.
* Otherwise:

  * Sets the `framing_error` flag.

---

## Verification

The receiver was verified using a dedicated Verilog testbench.

The testbench performs the following operations:

* Generates a 100 MHz clock.
* Applies synchronous reset.
* Uses reusable Verilog tasks (`send_bit` and `send_byte`) to transmit UART frames.
* Sends the byte `8'hB2`.
* Verifies:

  * Correct FSM transitions.
  * Proper shift register operation.
  * Correct `data_out` value.
  * `rx_done` pulse generation.
  * No framing error during valid transmission.

---

## Simulation Results

### Figure 1

*Receiver FSM transitioning through IDLE → START → DATA → STOP → IDLE.*

*(Insert waveform screenshot here.)*

### Figure 2

*Shift register reconstructing the transmitted byte (`8'hB2`) and transferring it to `data_out` after successful stop-bit verification.*

*(Insert waveform screenshot here.)*

---

## Key Learning Outcomes

* Designed a UART receiver using a finite state machine.
* Implemented start-bit validation using mid-bit sampling.
* Performed serial-to-parallel conversion using a shift register.
* Integrated a reusable baud generator for timing.
* Developed reusable Verilog testbench tasks for UART verification.
* Verified RTL functionality using Vivado simulation.

---

## Status

* RTL Design: ✅ Complete
* Simulation: ✅ Verified
* Documentation: ✅ Complete
