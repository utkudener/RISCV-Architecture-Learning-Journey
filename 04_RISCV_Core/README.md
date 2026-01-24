# RISC-V CPU Core (Work in Progress 🚧)

This is the main directory for the 32-bit RISC-V processor implementation. The goal is to build a fully pipelined CPU compliant with the RV32I instruction set.

### 🛠️ Current Status
- [x] **Testbench Setup:** Sums numbers 1 to 9 using Assembly.
- [x] **Instruction Fetch (IF):** PC logic and Instruction Memory (IMem) implemented.
- [ ] **Instruction Decode (ID):** (Next Step)
- [ ] **ALU Implementation:**
- [ ] **Register File Interface:**
- [ ] **Pipelining Logic:**

## 🖥️ Visualization
The current implementation utilizes Makerchip's visualization features to debug the datapath:

### Block Diagram & Register File
![CPU Visualization](assets/cpu_viz.png)

### Signal Waveform
![CPU Signals](assets/cpu_wave.png)

---
**Acknowledgement:** This project is based on the "Building a RISC-V CPU Core" course by Steve Hoover.
