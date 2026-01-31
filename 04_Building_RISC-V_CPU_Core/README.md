# 32-Bit RISC-V CPU Core Development 🚀

This repository documents the step-by-step construction of a 32-bit RISC-V processor core. The project is designed using **TL-Verilog** on the Makerchip platform and aims to build a fully functional processor compliant with the **RV32I Base Integer Instruction Set**.

The development process follows a "build-from-scratch" approach, starting from an empty shell and progressively adding logic stages such as Instruction Fetch, Decode, ALU, and Pipelining.

---

## 🛠️ Current Status: Stage 2 (Instruction Fetch)

We have successfully implemented the Instruction Memory, allowing the processor to fetch instructions based on the Program Counter (PC).

| Stage | Status | Description |
| :--- | :---: | :--- |
| **1. Project Shell & PC Logic** | ✅ | **Project structure setup and basic Program Counter implementation.** |
| **2. Instruction Fetch** | ✅ | **Connecting PC to IMem and fetching instructions.** |
| **3. Decode Logic** | ⏳ | Parsing Opcodes and Instruction Types. |
| **4. ALU Operations** | ⏳ | Arithmetic and Logic computations. |
| **5. Branching & Control** | ⏳ | Control flow logic and decision making. |
| **6. Pipelining** | ⏳ | Parallel execution stages for performance. |

---

## 🧩 Implemented Logic Description

### 1. Project Shell & PC
The foundation of the processor. The **Program Counter (PC)** serves as the address pointer, resetting to `0` and incrementing by `4` bytes each cycle to traverse the instruction memory.

### 2. Instruction Memory (IMem)
The Instruction Memory acts as the bridge between the "address" (PC) and the "operation" (Instruction).
* **Implementation:** Utilized the `READONLY_MEM` macro to simulate a program memory.
* **Connectivity:** The `PC` signal is connected to the memory address input.
* **Output:** For every clock cycle, the memory outputs a 32-bit instruction (`$instr`) corresponding to the current PC address. This allows the processor to "read" the assembly program loaded into the shell.

---

## 📸 Simulation & Verification

The functionality of the core is verified using waveform simulations. Below are the results for the completed stages.

### Stage 1: Program Counter Verification
The waveform below demonstrates the Program Counter logic.
* **Observation:** The Next-PC signal (`$next_pc`) and current PC (`$pc`) increment by 4 on each rising edge of the clock (Hexadecimal: `0, 4, 8, C...`).

![PC Waveform](assets/PC_waveform.png)

### Stage 2: Instruction Fetch Verification
The waveform below confirms that instructions are being correctly fetched from memory.
* **Observation:** As the `$pc` (address) changes (e.g., `0`, `4`, `8`), the `$instr` (data) signal updates instantly with the corresponding machine code (e.g., `0000_0713`, `0613`...). This proves the link between the PC and Memory is active.

![IMem Waveform](assets/IMem_waveform.png)

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