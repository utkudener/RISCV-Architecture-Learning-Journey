# 32-Bit RISC-V CPU Core Development 🚀

This repository documents the construction of a 32-bit RISC-V processor core. The project is built from scratch using **TL-Verilog** on the Makerchip platform and implements a functional subset of the **RV32I Base Integer Instruction Set**.

The core is capable of executing a test program (Sum 1 to 9), performing arithmetic operations, memory access, and conditional branching.

---

## 🏆 Current Status: Core Logic Completed

We have successfully implemented the Control Flow (Branching) logic and verified the entire core using an automated testbench. The processor correctly executes the "Sum 1 to 9" assembly program and passes the verification check.

| Stage | Status | Description |
| :--- | :---: | :--- |
| **1. Project Shell & PC Logic** | ✅ | **PC Reset & Increment Logic.** |
| **2. Instruction Fetch** | ✅ | **Instruction Memory (IMem) Connection.** |
| **3. Decode Logic** | ✅ | **Type Parsing (R, I, S, B, U, J) & Field Extraction.** |
| **4. Register File Read** | ✅ | **Reading Source Operands (rs1, rs2).** |
| **5. ALU Operations** | ✅ | **Arithmetic Logic Unit (ADD, ADDI, Branch Checks).** |
| **6. Register File Write** | ✅ | **Write-Back Logic (Result -> rd).** |
| **7. Branching & Control** | ✅ | **Conditional Branching (BEQ, BNE, BLT...) & PC Updates.** |

---

## 🧩 Architecture Overview

### 1. Control Flow & Branching
The processor determines the next instruction address based on branch conditions:
* **Condition Check:** The ALU evaluates conditions (e.g., `x1 < x2` for `BLT`).
* **Target Calculation:** Computes `Target PC = Current PC + Immediate` value.
* **Next-PC Logic:** If the branch is taken (`$taken_br`), the PC updates to the Target PC; otherwise, it increments by 4.

### 2. Arithmetic Logic Unit (ALU)
Handles integer arithmetic and logical comparisons.
* **Operations:** ADD, ADDI.
* **Branch Support:** BEQ, BNE, BLT, BGE, BLTU, BGEU.

### 3. Register File (32x32-bit)
* **Read Ports:** Two asynchronous read ports for source operands.
* **Write Port:** Synchronous write-back for ALU results.

---

## 🧪 Verification & Testbench

The core functionality is verified using an embedded assembly program that sums numbers from 1 to 9.

### Automated Testbench (`m4+tb`)
We utilized the `m4+tb()` macro to assert pass/fail conditions automatically.
* **Success Condition:** The program calculates the sum (45), subtracts the expected value (44), and stores the result (1) in register `x30`.