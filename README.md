![Verilog](https://img.shields.io/badge/-Verilog-000000?style=flat-square&logo=verilog&logoColor=white)
![FPGA](https://img.shields.io/badge/-FPGA-003B5C?style=flat-square&logo=intel&logoColor=white)
![Quartus](https://img.shields.io/badge/-Quartus%20Prime-0078D4?style=flat-square)
![ModelSim](https://img.shields.io/badge/-ModelSim-006633?style=flat-square)

# 2025 Beijing University IC Design Competition — FPGA Digital Design

Two FPGA digital design problems solved for the 2025 Beijing University
Integrated Circuit Design Competition.

---

## Problems

### Problem 1: AXI-Stream Network Protocol Parser

Packet parser for IPv4/ICMP over AXI-Stream interface. Extracts header
fields and validates checksums in hardware.

- **Tech:** Verilog, AXI-Stream, IPv4, ICMP
- **Files:** `problem1/`

### Problem 3: 8-bit Single-Bus Processor

An 8-bit processor with single-bus architecture, supporting a custom
instruction set. Includes ALU, register file, and control FSM.

- **Tech:** Verilog, processor architecture, single-bus datapath
- **Files:** `problem3/`

## Platform

| Item | Detail |
|------|--------|
| **FPGA** | Cyclone IV E EP4CE55F23C8 |
| **Tools** | Quartus Prime + ModelSim |
| **Language** | Verilog / VHDL |
