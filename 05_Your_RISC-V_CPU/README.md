# 32-Bit RISC-V CPU Core - Phase 2: Full ISA Compliance 🛠️

Welcome to **Phase 2** of the RISC-V Processor Development. In this phase, we expand upon the foundational architecture established in Phase 1 to support the complete **RV32I (RISC-V 32-bit Integer)** instruction set standard.

This document records the step-by-step transformation of the core from a "simple summation engine" into a fully compliant processor.

---

## 🚀 Progress Report: Step-by-Step Development

Phase 2 development is executed through the following technical steps:

### Step 1: Upgrading the Test Environment (`m4_test_prog`)
We have replaced the custom "Sum 1 to 9" loop program from Phase 1 with the **Official RISC-V Test Suite**.
* **Change:** Removed manual `m4_asm` lines and instantiated the `m4_test_prog()` macro.
* **Objective:** To rigorously validate not just `ADD`, but every single instruction (SUB, XOR, JAL, Shift, etc.) in isolation.
* **Success Criteria:** Upon completion, all registers from `x5` to `x30` must contain the value **`1`**.

### Step 2: Expanding Decode Logic
To allow the processor to recognize the full RV32I set, we completely overhauled the **Decode Logic**. The core now identifies the following instruction groups:

* **Arithmetic & Logical (Immediate - I-Type):**
    * `ADDI`: Add Immediate.
    * `ANDI`, `ORI`, `XORI`: Logical AND, OR, XOR with constants.
    * `SLTI`, `SLTIU`: Set Less Than Immediate (Signed/Unsigned).

* **Arithmetic & Logical (Register - R-Type):**
    * `ADD`: Add Registers.
    * `SUB`: Subtract Registers (**New!**).
    * `AND`, `OR`, `XOR`: Logical operations between registers.
    * `SLT`, `SLTU`: Set Less Than (Signed/Unsigned).

* **Shift Operations:**
    * `SLL / SLLI`: Shift Left Logical.
    * `SRL / SRLI`: Shift Right Logical.
    * `SRA / SRAI`: Shift Right Arithmetic (preserves sign bit).

* **Jump & Upper Immediate:**
    * `LUI`: Load Upper Immediate.
    * `AUIPC`: Add Upper Immediate to PC.
    * `JAL`: Jump And Link (Function Call).
    * `JALR`: Jump And Link Register (Return/Computed Jump).

* **Branch (B-Type):**
    * `BEQ`, `BNE`: Branch if Equal / Not Equal.
    * `BLT`, `BGE`: Branch if Less Than / Greater Equal.

---

## 🛠️ Technical Details: How It Works

### Decode Logic
The decoder parses the incoming 32-bit `$instruction` signal to generate specific control flags (`$is_add`, `$is_jal`, `$is_lui`, etc.).
* **Method:** We utilize bit masking (`==?`) to check the Opcode, Funct3, and Funct7 fields against the RISC-V specifications.

### Verification Strategy
The new test program operates on the following logic:
1.  **Execute:** The CPU attempts to execute an instruction (e.g., `SUB x5, x6, x7`).
2.  **Compare:** The program calculates the result and XORs it with the *expected* result.
3.  **Validate:**
    * If the result is **Correct**, the program writes **`1`** to the destination register.
    * If **Incorrect**, it writes a different value.
4.  **Visual Check:** We inspect the Register File in the Makerchip Visualizer (VIZ). A column of green `1`s indicates a passing test suite.

---

## 📅 Next Steps (To-Do List)

Currently, the **Decode** (Recognition) logic is complete, but the **ALU** (Execution) logic does not yet support all these operations. The roadmap is as follows:

1.  [ ] **ALU Expansion:** Wire the newly decoded signals (`$is_sub`, `$is_and`, etc.) into the ALU multiplexer to perform the actual calculations.
2.  [ ] **Data Memory:** Implement `LW` (Load Word) and `SW` (Store Word) logic.
3.  [ ] **Final Verification:** Confirm that all test registers contain `1`.

---

## 📂 File Information

* **File:** `riscv_core.tlv`
* **Language:** TL-Verilog
* **Architecture:** RISC-V RV32I v2.2