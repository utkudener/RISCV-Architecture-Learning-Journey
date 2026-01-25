\m4_TLV_version 1d: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/LF-Building-a-RISC-V-CPU-Core/risc-v_shell.tlv
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/LF-Building-a-RISC-V-CPU-Core/main/lib/risc-v_shell_lib.tlv'])

   //---------------------------------------------------------------------------------
   // /====================\
   // | Sum 1 to 9 Program |
   // \====================/
   //
   // Program to test RV32I
   // Add 1,2,3,...,9 (in that order).
   //
   // Regs:
   //  x12 (a2): 10
   //  x13 (a3): 1..10
   //  x14 (a4): Sum
   // 
   m4_asm(ADDI, x14, x0, 0)             // Initialize sum register a4 with 0
   m4_asm(ADDI, x12, x0, 1010)          // Store count of 10 in register a2.
   m4_asm(ADDI, x13, x0, 1)             // Initialize loop count register a3 with 0
   // Loop:
   m4_asm(ADD, x14, x13, x14)           // Incremental summation
   m4_asm(ADDI, x13, x13, 1)            // Increment loop count by 1
   m4_asm(BLT, x13, x12, 1111111111000) // If a3 is less than a2, branch to label named <loop>
   // Test result value in x14, and set x31 to reflect pass/fail.
   m4_asm(ADDI, x30, x14, 111111010100) // Subtract expected value of 44 to set x30 to 1 if and only iff the result is 45 (1 + 2 + ... + 9).
   m4_asm(BGE, x0, x0, 0) // Done. Jump to itself (infinite loop). (Up to 20-bit signed immediate plus implicit 0 bit (unlike JALR) provides byte address; last immediate bit should also be 0)
   m4_asm_end()
   m4_define(['M4_MAX_CYC'], 50)
   //---------------------------------------------------------------------------------

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
   /* verilator lint_on WIDTH */
\TLV
   
   $reset = *reset;
   
   // ============================================
   // STAGE 1: Instruction Fetch (IF)
   // ============================================
   
   // 1. Program Counter (PC) Logic
   // On reset, start at 0. Otherwise, take the next_pc value from the previous cycle (>>1).
   $pc[31:0] = $reset ? 0 : >>1$next_pc[31:0];
   
   // 2. Next PC Calculation (Sequential Fetching)
   // In RISC-V, instructions are 32-bits (4 Bytes) wide.
   // We increment the current PC by 4 to fetch the next instruction address.
   $next_pc[31:0] = $pc[31:0] + 4;
   
   // 3. Instruction Memory (IMem)
   // Fetches the 32-bit instruction from the calculated $pc address.
   // Output: $$instr[31:0]
   `READONLY_MEM($pc, $$instr[31:0])
   
   
// ============================================
   // STAGE 2: Instruction Decode (ID)
   // ============================================
   
   // Instruction Type Decoding
   // Based on the RISC-V Base Opcode Map (bits [6:2]), we identify the type of instruction.
   // We use '==?' operator for wildcard matching (where 'x' means don't care).

   // U-Type: LUI (01101), AUIPC (00101)
   $is_u_instr = $instr[6:2] ==? 5'b0x101;
   
   // I-Type: Load (00000), Op-Imm (00100), JALR (11001), System (11100 - covered by 001x0 logic partially or added if needed)
   $is_i_instr = $instr[6:2] ==? 5'b0000x || 
                 $instr[6:2] ==? 5'b001x0 || 
                 $instr[6:2] ==  5'b11001;
   
   // S-Type: Store (01000)
   $is_s_instr = $instr[6:2] ==? 5'b0100x;
   
   // R-Type: Op (01100), Op-32 (01110), AMO (01011), Op-FP (10100)
   $is_r_instr = $instr[6:2] ==? 5'b011x0 || 
                 $instr[6:2] ==  5'b01011 || 
                 $instr[6:2] ==  5'b10100;
   
   // B-Type: Branch (11000)
   $is_b_instr = $instr[6:2] ==  5'b11000;
   
   // J-Type: JAL (11011)
   $is_j_instr = $instr[6:2] ==  5'b11011;
   
   // ============================================
   // STAGE 3: Field Extraction & Validity
   // ============================================

   // 1. Instruction Fields Extraction
   // Extracting standard fields from the 32-bit instruction.
   $rs1[4:0]    = $instr[19:15];  // Source Register 1
   $rs2[4:0]    = $instr[24:20];  // Source Register 2
   $rd[4:0]     = $instr[11:7];   // Destination Register
   $funct3[2:0] = $instr[14:12];  // Function 3 (Sub-opcode)
   $opcode[6:0] = $instr[6:0];    // Opcode
   
   // 2. Validity Logic
   // Determining which fields are valid based on the instruction type.
   
   // rs1 is valid for R, I, S, and B types.
   $rs1_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
   
   // rs2 is valid for R, S, and B types.
   $rs2_valid = $is_r_instr || $is_s_instr || $is_b_instr;
   
   // rd is valid for R, I, U, and J types (JAL writes return address to rd).
   $rd_valid  = $is_r_instr || $is_i_instr || $is_u_instr || $is_j_instr;
   
   // funct3 is valid for R, I, S, and B types (U and J types do not have funct3).
   $funct3_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
   
   // imm is valid for all types except R-Type.
   $imm_valid = $is_i_instr || $is_s_instr || $is_b_instr || $is_u_instr || $is_j_instr;
   
   // Suppress warnings for unused signals (until we implement the ALU/RegFile).
   `BOGUS_USE($rd $rd_valid $rs1 $rs1_valid $rs2 $rs2_valid $funct3 $funct3_valid $imm_valid $opcode)
   
   // 3. Immediate Generation
   // Constructing the 32-bit immediate value based on instruction type.
   $imm[31:0] = $is_i_instr ? { {21{$instr[31]}}, $instr[30:20] } :
                $is_s_instr ? { {21{$instr[31]}}, $instr[30:25], $instr[11:7] } :
                $is_b_instr ? { {20{$instr[31]}}, $instr[7], $instr[30:25], $instr[11:8], 1'b0 } :
                $is_u_instr ? { $instr[31:12], 12'b0 } :
                $is_j_instr ? { {12{$instr[31]}}, $instr[19:12], $instr[20], $instr[30:21], 1'b0 } :
                              32'b0; // Default case
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = 1'b0;
   *failed = *cyc_cnt > M4_MAX_CYC;
   
   //m4+rf(32, 32, $reset, $wr_en, $wr_index[4:0], $wr_data[31:0], $rd_en1, $rd_index1[4:0], $rd_data1, $rd_en2, $rd_index2[4:0], $rd_data2)
   //m4+dmem(32, 32, $reset, $addr[4:0], $wr_en, $wr_data[31:0], $rd_en, $rd_data)
   m4+cpu_viz()
\SV
   endmodule