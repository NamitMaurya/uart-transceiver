# UART Top Module (uart_top)

## Objective

The UART Top Module integrates the UART Transmitter and UART Receiver into a single UART transceiver. It serves as the top-level module responsible for connecting both submodules and exposing a unified interface to the outside world.

The top module itself contains no additional control logic or finite state machine. Its primary purpose is module integration and signal routing.

---

## Block Diagram

```text
                 +--------------------+
                 |      uart_top      |
                 |                    |
                 |   +------------+   |
data_in -------->|   |  UART TX   |---+----> tx
tx_start ------->|   +------------+   |
                 |                    |
rx ------------->|   +------------+   |
                 |   |  UART RX   |<--+
                 |   +------------+   |
                 |                    |
                 +--------------------+
                           |
                           |
                      data_out
```

During simulation, the transmitter output (`tx`) is connected to the receiver input (`rx`) within the testbench to perform loopback verification.

---

## Module Interface

### Inputs

| Signal         | Description                   |
| -------------- | ----------------------------- |
| `clk`          | System clock                  |
| `rst`          | Active-high synchronous reset |
| `tx_start`     | Starts a UART transmission    |
| `data_in[7:0]` | Parallel data to transmit     |
| `rx`           | Serial receive input          |

### Outputs

| Signal          | Description                   |
| --------------- | ----------------------------- |
| `tx`            | Serial transmit output        |
| `data_out[7:0]` | Received parallel byte        |
| `tx_done`       | Transmission complete pulse   |
| `rx_done`       | Reception complete pulse      |
| `tx_busy`       | Indicates transmitter is busy |
| `rx_busy`       | Indicates receiver is busy    |
| `framing_error` | Indicates invalid stop bit    |

---

## Internal Architecture

The top module instantiates:

* One UART Transmitter
* One UART Receiver

Both modules share the same system clock and reset signal while operating independently.

No additional processing is performed inside the top module.

---

## Verification

A dedicated top-level testbench was created to verify complete UART communication.

The testbench performs the following operations:

1. Generates a 100 MHz clock.
2. Applies synchronous reset.
3. Loads the transmitter with the byte `8'hB2`.
4. Pulses `tx_start` for one clock cycle.
5. Connects the transmitter output (`tx`) directly to the receiver input (`rx`) to create a loopback connection.
6. Waits for transmission and reception to complete.
7. Confirms that the receiver reconstructs the original transmitted byte.

---


## Integration Bug Encountered

During system-level verification, the receiver initially reconstructed an incorrect byte.

Investigation using Vivado waveforms showed that the transmitter held the start bit for two baud periods before transmitting the first data bit. As a result, the receiver sampled one baud period too early, causing every received bit to shift.

The issue was corrected by updating the transmitter output continuously during the DATA state while shifting the register only on each baud tick.

This ensured that each data bit remained on the transmission line for one complete baud period and aligned correctly with the receiver's sampling instants.

---

## Key Learning Outcomes

* Integrated multiple RTL modules into a complete hardware subsystem.
* Connected independent modules using a top-level design.
* Verified end-to-end UART communication through loopback simulation.
* Debugged a real timing alignment issue using waveform analysis.
* Understood the importance of timing relationships between transmitting and receiving hardware.
* Gained experience in system-level RTL verification.

---

## Status

* Top Module: ✅ Complete
* Loopback Verification: ✅ Passed
* End-to-End UART Communication: ✅ Verified
