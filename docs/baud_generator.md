# Baud Generator

## Purpose

Generates a single-cycle baud_tick pulse every DIVISOR clock cycles.

## Design

- Counter counts from 0 to DIVISOR-1.
- When terminal count is reached:
  - baud_tick asserted for one clock cycle.
  - Counter resets to 0.

## Parameters

- DIVISOR = CLK_FREQ / BAUD_RATE

Example:

100 MHz clock
9600 baud

DIVISOR ≈ 10417

## Verification

Verified in simulation using a reduced divisor value (8).

Observed:
- Counter increments correctly.
- baud_tick generated every 8 clock cycles.
- Pulse width = 1 clock cycle.