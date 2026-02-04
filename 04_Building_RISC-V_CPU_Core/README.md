# 32-Bit RISC-V CPU Core Development 🚀

This repository documents the step-by-step construction of a 32-bit RISC-V processor core. The project is designed using **TL-Verilog** on the Makerchip platform and aims to build a fully functional processor compliant with the **RV32I Base Integer Instruction Set**.

The development process follows a "build-from-scratch" approach, starting from an empty shell and progressively adding logic stages such as Instruction Fetch, Decode, ALU, and Pipelining.

---

## 🛠️ Current Status: Stage 6 (Register File Write-Back)

We have successfully closed the loop! The processor now performs **Write-Back**, meaning the results calculated by the ALU are written back into the Register File. The processor can now execute sequential instructions where the result of one operation feeds into the next.

| Stage | Status | Description |
| :--- | :---: | :--- |
| **1. Project Shell & PC Logic** | ✅ | **Project structure setup and basic Program Counter implementation.** |
| **2. Instruction Fetch** | ✅ | **Connecting PC to IMem and fetching instructions.** |
| **3. Decode Logic** | ✅ | **Instruction Type Parsing & Field Extraction.** |
| **4. Register File Read** | ✅ | **Reading data from Source Registers (rs1, rs2).** |
| **5. ALU Operations** | ✅ | **Arithmetic computations (ADD, ADDI) & Result generation.** |
| **6. Register File Write** | ✅ | **Writing ALU results back to Destination Register (rd).** |
| **7. Pipelining** | ⏳ | Parallel execution stages for performance. |

---

## 🧩 Implemented Logic Description

### 1. Instruction Fetch & Decode
The processor fetches 32-bit instructions from memory and decodes them to identify the Operation Type, Source Registers, and Destination Register.

### 2. Register File (Read & Write)
The Register File is the central storage unit.
* **Read:** Retrieves values from source registers (`rs1`, `rs2`) to feed the ALU.
* **Write (New):** Takes the calculated result from the ALU and saves it back into the destination register (`rd`).
    * **Write Data:** Connected to the ALU `$result`.
    * **Write Enable:** Controlled by `$rd_valid`, ensuring only relevant instructions modify the memory.

### 3. Arithmetic Logic Unit (ALU)
Performs arithmetic operations (ADD, ADDI) and generates the `$result` signal, which is now wired back to the Register