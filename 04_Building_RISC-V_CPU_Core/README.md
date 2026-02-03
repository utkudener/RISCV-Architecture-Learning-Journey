# 32-Bit RISC-V CPU Core Development 🚀

This repository documents the step-by-step construction of a 32-bit RISC-V processor core. The project is designed using **TL-Verilog** on the Makerchip platform and aims to build a fully functional processor compliant with the **RV32I Base Integer Instruction Set**.

The development process follows a "build-from-scratch" approach, starting from an empty shell and progressively adding logic stages such as Instruction Fetch, Decode, ALU, and Pipelining.

---

## 🛠️ Current Status: Stage 4 (Register File Read & Control Decoding)

We have successfully connected the **Register File** and verified the read operations. The processor can now use the decoded register indices (`rs1`, `rs2`) to retrieve values from the register file. Additionally, specific instruction decoding logic (`ADD`, `ADDI`, `Branch`) has been implemented.

| Stage | Status | Description |
| :--- | :---: | :--- |
| **1. Project Shell & PC Logic** | ✅ | **Project structure setup and basic Program Counter implementation.** |
| **2. Instruction Fetch** | ✅ | **Connecting PC to IMem and fetching instructions.** |
| **3. Decode Logic** | ✅ | **Instruction Type Parsing & Field Extraction.** |
| **4. Register File Read** | ✅ | **Reading data from Source Registers (rs1, rs2) & Control Signals.** |
| **5. ALU Operations** | ⏳ | Arithmetic and Logic computations. |
| **6. Pipelining** | ⏳ | Parallel execution stages for performance. |

---

## 🧩 Implemented Logic Description

### 1. Instruction Fetch & Decode
The processor fetches 32-bit instructions from memory and decodes them to identify:
* **Instruction Type:** (R, I, S, B, U, J)
* **Fields:** Opcode, Source Registers (`rs1`, `rs2`), Destination Register (`rd`), and Immediates (`imm`).
* **Control Signals:** Logic to detect specific instructions like `ADDI`, `ADD`, `BEQ`, `BNE`, etc.

### 2. Register File (Read Port)
The Register File is the processor's short-term memory array (32 x 32-bit).
* **Connectivity:** The decoded `$rs1` and `$rs2` indices are connected to the Register File's read inputs.
* **Read Enable:** The `$rs1_valid` and `$rs2_valid` signals ensure we only read from the register file when the instruction type requires it.
* **Output:** The Register File outputs `$src1_value` and `$src2_value`. These signals carry the actual numbers stored in the registers.

---

## 📸 Simulation & Verification

The functionality of the core is verified using waveform simulations.

### Field Extraction Verification
The waveform below validates that the processor correctly slices the instruction into its components.
* **Observation:** Signals like `$rs1`, `$rs2`, and `$imm` are correctly extracted from the instruction `$instr`.

![Field Extraction Waveform](assets/Decode_Logic_InstructionField_waveform.png)

### Register File Read Verification
The waveform below confirms that the Register File is correctly reading values based on the input indices.
* **Observation:** In the test environment, registers are initialized with values equal to their index (e.g., Reg x13 holds value 13). The waveform shows that when **`$rs1`** is `0d` (13), the output **`$src1_value`** correctly becomes `0000_000d`. Similarly, when **`$rs2`** is `0e` (14), **`$src2_value`** reads `0000_000e`. This proves the read ports are wired correctly.

![Register File Read Waveform](assets/Register_File_Read.png)

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