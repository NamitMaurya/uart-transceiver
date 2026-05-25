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
| Baud Generator | Divides system clock to baud rate | 🔲 Not started |
| UART TX        | Transmitter (parallel to serial)  | 🔲 Not started |
| UART RX        | Receiver (serial to parallel)     | 🔲 Not started |
| Top Module     | Connects TX and RX                | 🔲 Not started |

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
- [ ] Baud rate generator
- [ ] UART transmitter
- [ ] UART receiver
- [ ] Top-level integration
- [ ] Simulation and testing
- [ ] Documentation

## What I'm Learning

Will update as I build each module.

---

*Part of my digital design portfolio | Namit Maurya | IIIT Pune*