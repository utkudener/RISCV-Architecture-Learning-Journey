# 32-Bit RISC-V CPU Core Development 🚀

This repository documents the step-by-step construction of a 32-bit RISC-V processor core. The project is designed using **TL-Verilog** on the Makerchip platform and aims to build a fully functional processor compliant with the **RV32I Base Integer Instruction Set**.

The development process follows a "build-from-scratch" approach, starting from an empty shell and progressively adding logic stages such as Instruction Fetch, Decode, ALU, and Pipelining.

---

## 🛠️ Current Status: Stage 3 (Instruction Decode)

We have successfully implemented the Decode Logic, allowing the processor to identify the type of instruction (I-Type, R-Type, etc.) fetched from memory.

| Stage | Status | Description |
| :--- | :---: | :--- |
| **1. Project Shell & PC Logic** | ✅ | **Project structure setup and basic Program Counter implementation.** |
| **2. Instruction Fetch** | ✅ | **Connecting PC to IMem and fetching instructions.** |
| **3. Decode Logic** | ✅ | **Parsing opcodes to determine Instruction Type (I, R, S, B, U, J).** |
| **4. ALU Operations** | ⏳ | Arithmetic and Logic computations. |
| **5. Branching & Control** | ⏳ | Control flow logic and decision making. |
| **6. Pipelining** | ⏳ | Parallel execution stages for performance. |

---

## 🧩 Implemented Logic Description

### 1. Project Shell & PC
The foundation of the processor. The **Program Counter (PC)** serves as the address pointer, resetting to `0` and incrementing by `4` bytes each cycle to traverse the instruction memory.

### 2. Instruction Memory (IMem)
The Instruction Memory acts as the bridge between the "address" (PC) and the "operation" (Instruction). It fetches the 32-bit machine code corresponding to the current PC address.

### 3. Decode Logic
Once an instruction is fetched, the processor must understand "what" to do. The Decode Logic inspects specific bits of the instruction (primarily the Opcode) to classify it into one of the standard RISC-V formats:
* **R-Type:** Register-to-register operations (e.g., ADD, SUB).
* **I-Type:** Immediate operations (e.g., ADDI, LW).
* **S-Type:** Store operations (e.g., SW).
* **B-Type:** Branch operations (e.g., BEQ, BNE).
* **U-Type & J-Type:** Upper immediate and Jump operations.

This classification is crucial for enabling the correct data paths in subsequent stages.

---

## 📸 Simulation & Verification

The functionality of the core is verified using waveform simulations. Below are the results for the completed stages.

### Stage 1: Program Counter Verification
The waveform below demonstrates the Program Counter logic.
* **Observation:** The Next-PC signal (`$next_pc`) and current PC (`$pc`) increment by 4 on each rising edge of the clock (Hexadecimal: `0, 4, 8, C...`).

![PC Waveform](assets/PC_waveform.png)

### Stage 2: Instruction Fetch Verification
The waveform below confirms that instructions are being correctly fetched from memory.
* **Observation:** As the `$pc` (address) changes, the `$instr` (data) signal updates instantly with the corresponding machine code.

![IMem Waveform](assets/IMem_waveform.png)

### Stage 3: Decode Logic Verification
The waveform below shows the processor correctly identifying instruction types.
* **Observation:** Signals like `$is_i_instr`, `$is_r_instr`, and `$is_b_instr` toggle High (1) or Low (0) depending on the fetched `$instr`. For example, when an Immediate instruction is fetched, `$is_i_instr` becomes active, confirming the decoder is parsing the Opcode correctly.

![Decode Logic Waveform](assets/Decode_Logic_waveform.png)

---

## 📂 Project Structure

* **Core Source File:** The main TL-Verilog file containing the active processor logic.
* **Shell Source File:** The template file acting as the project skeleton.
* **Libraries:** External references for RISC-V macro definitions and assembler tools.

---

## 🚀 Development Tools

* **Language:** [TL-Verilog](https://www.redwoodeda.com/tl-verilog) (Transaction-Level Verilog)
* **IDE & Simulation:** [Makerchip](https://makerchip.com/)
* **Architecture:** [RISC-V](https://riscv.org/)