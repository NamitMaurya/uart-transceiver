# UART Transceiver

A complete UART transmitter and receiver implemented in Verilog.

---

## What is UART?

UART (Universal Asynchronous Receiver/Transmitter) sends data one bit at a time over a single wire. It's one of the most fundamental communication protocols in digital systems — found in everything from microcontrollers to FPGAs to your computer's serial port.

I'm building this from scratch to understand how serial communication actually works at the hardware level.

## UART Frame Format
Idle Start D0 D1 D2 D3 D4 D5 D6 D7 Stop Idle
1 0 b b b b b b b b 1 1

- **Idle:** Line stays HIGH
- **Start bit:** Always 0 (signals data is coming)
- **Data bits:** 8 bits, LSB first
- **Stop bit:** Always 1 (signals end of frame)

## Architecture
       ┌─----------------┐         ┌-------------┐     ┌---------------┐
	   |	Data in      |────────►│  UART TX    │────►|TX (serial out)|
	   |(8-bit parallel) │         | (PISO + FSM)│     └──--──────-────┘
	   └────────┬────────┘         └────────-────┘  
		        │
		┌───────▼───--┐
		│ Baud Rate   │
		│ Generator   │
		└────────┬──--┘
		         │
		┌────────▼────────┐  ┌------------------┐
		| RX (serial in)  │─►|   UART RX        │────► Data out
		│ (SIPO + FSM)    │  |(8-bit parallel)  |
		└─────────────────┘  └------------------┘ 
		

## Building Blocks

| Module         | Description                       | Status         |
|----------------|-----------------------------------|----------------|
| Baud Generator | Divides system clock to baud rate | ✅ Complete    |
| UART TX        | Transmitter (parallel to serial)  | ✅ Complete    |
| UART RX        | Receiver (serial to parallel)     | ✅ Complete    |
| Top Module     | Connects TX and RX                | ✅ Complete    |

## Project Structure
uart-transceiver/
├── src/ # Verilog source modules
├── sim/ # Testbenches
└── docs/ # Diagrams, protocol notes


## Design Parameters

| Parameter | Value |
|-----------|-------|
| System Clock | 100 MHz |
| Baud Rate | 9600 (configurable) |
| Data Bits | 8 |
| Stop Bits | 1 |
| Parity | None |

## Progress Log

- [x] Project setup
- [x] Baud rate generator
- [x] UART transmitter
- [x] UART receiver
- [x] Top-level integration
- [x] Simulation and testing
- [x] Documentation

## What I'm Learning

This project is helping me learn practical RTL design and digital communication concepts, including:

- Finite State Machine (FSM) design
- Parameterized Verilog modules
- Baud rate generation
- UART 8N1 protocol
- Serial-to-parallel and parallel-to-serial conversion
- Shift registers and counters
- Timing synchronization using baud ticks
- Start-bit validation using mid-bit sampling
- Writing reusable Verilog testbenches with tasks
- RTL verification using waveform analysis in Vivado
- Debugging timing and synchronization issues between interacting hardware modules
- Git and GitHub workflow for hardware projects

This section will continue to grow as I implement the UART receiver, integrate the complete transceiver, and explore more advanced digital design concepts.

---

*Part of my digital design portfolio | Namit Maurya | IIIT Pune*