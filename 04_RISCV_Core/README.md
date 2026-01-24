# RISC-V CPU Core (Work in Progress 🚧)

This is the main directory for the 32-bit RISC-V processor implementation. The goal is to build a fully pipelined CPU compliant with the RV32I instruction set.

### 🛠️ Current Status
- [x] **Testbench Setup:** Sums numbers 1 to 9 using Assembly.
- [x] **Instruction Fetch (IF):** PC logic and Instruction Memory (IMem) implemented.
- [ ] **Instruction Decode (ID):** (Next Step)
- [ ] **ALU Implementation:**
- [ ] **Register File Interface:**
- [ ] **Pipelining Logic:**

## 📸 Simulation Results

### 1. Program Counter (PC) Logic
The waveform below demonstrates the sequential fetching logic. The Program Counter (`$pc`) increments by 4 bytes every cycle (`0`, `4`, `8`, `C`, `10`...) to fetch the next instruction correctly.

![PC Waveform](assets/RISC-V_Core_PCWaveform.png)

**Acknowledgement:** This project is based on the "Building a RISC-V CPU Core" course by Steve Hoover.
