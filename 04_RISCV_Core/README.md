# RISC-V CPU Core (Work in Progress 🚧)

This is the main directory for the 32-bit RISC-V processor implementation. The goal is to build a fully pipelined CPU compliant with the RV32I instruction set.

### 🛠️ Current Status
- [x] **Testbench Setup:** Sums numbers 1 to 9 using Assembly.
- [x] **Instruction Fetch (IF):** PC logic and Instruction Memory (IMem) implemented.
- [x] **Instruction Decode (ID):** Opcode decoding and Instruction Type identification working.
- [ ] **Field Decoding:** (Next Step - Extracting rs1, rs2, rd, imm)
- [ ] **ALU Implementation:**
- [ ] **Register File Interface:**
- [ ] **Pipelining Logic:**

## 📸 Simulation Results

### 1. Instruction Decode Logic 
The waveform below demonstrates the processor identifying instruction types based on Opcode. Notice how flags like `$is_i_instr` and `$is_r_instr` toggle High (1) depending on the fetched instruction (`$instr`).

![Instruction Decode Waveform](assets/Instruction_Decode_WaveForm.png)

### 2. Program Counter (PC) Logic
The Program Counter (`$pc`) increments by 4 bytes every cycle (`0`, `4`, `8`, `C`, `10`...) to fetch instructions sequentially.

![PC Waveform](assets/RISC-V_Core_PCWaveform.png)


---
**Acknowledgement:** This project is based on the "Building a RISC-V CPU Core" course by Steve Hoover.
