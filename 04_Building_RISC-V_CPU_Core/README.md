# 32-Bit RISC-V CPU Core Development 🚀

This repository documents the step-by-step construction of a 32-bit RISC-V processor core. The project is designed using **TL-Verilog** on the Makerchip platform and aims to build a fully functional processor compliant with the **RV32I Base Integer Instruction Set**.

The development process follows a "build-from-scratch" approach, starting from an empty shell and progressively adding logic stages such as Instruction Fetch, Decode, ALU, and Pipelining.

---

## 🛠️ Current Status: Stage 1 (Initialization & PC Logic)

We have successfully initialized the project environment and implemented the first critical component of the processor: the **Program Counter (PC)**.

| Stage | Status | Description |
| :--- | :---: | :--- |
| **1. Project Shell & PC Logic** | ✅ | **Project structure setup and basic Program Counter implementation.** |
| **2. Instruction Fetch** | ⏳ | Fetching instructions from memory. |
| **3. Decode Logic** | ⏳ | Parsing Opcodes and Instruction Types. |
| **4. ALU Operations** | ⏳ | Arithmetic and Logic computations. |
| **5. Branching & Control** | ⏳ | Control flow logic and decision making. |
| **6. Pipelining** | ⏳ | Parallel execution stages for performance. |

---

## 🧩 Implemented Logic Description

### 1. Project Shell Initialization
Before implementing any logic, a clean project structure was established. This "Shell" includes the necessary libraries, simulation parameters, and the base clock/reset signals required to drive the processor. It serves as the blank canvas for the architecture.

### 2. Program Counter (PC)
The Program Counter is the heartbeat of the processor, determining which instruction to execute next. The current implementation includes:
* **Reset Logic:** When the reset signal is active, the PC is forced to address `0`, ensuring the processor starts from the beginning of the program.
* **Next-PC Calculation:** In every clock cycle (where reset is not active), the PC increments by **4 bytes**. This is because standard RISC-V instructions are 32 bits (4 bytes) wide, so the processor moves to the immediate next instruction in memory.

---

## 📸 Simulation & Verification

The functionality of the core is verified using waveform simulations. Below are the results for the current stage.

### Initial Shell Setup
The image below shows the initial state of the project. Only the system clock and reset signals are present, confirming that the environment is ready for logic development.

![Shell Waveform](assets/Shell_waveform.png)

### Program Counter Verification
The waveform below demonstrates the Program Counter logic in action. As seen in the signal trace:
1.  **Reset:** The PC starts at `0`.
2.  **Increment:** The Next-PC signal (`$next_pc`) and current PC (`$pc`) increment by 4 on each rising edge of the clock (Hexadecimal sequence: `0, 4, 8, C, 10...`). This confirms the sequential logic is functioning correctly.

![PC Waveform](assets/PC_waveform.png)

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