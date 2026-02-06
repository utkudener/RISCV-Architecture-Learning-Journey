\m4_TLV_version 1d: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/LF-Building-a-RISC-V-CPU-Core/risc-v_shell.tlv
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/LF-Building-a-RISC-V-CPU-Core/main/lib/risc-v_shell_lib.tlv'])



   //---------------------------------------------------------------------------------
	m4_test_prog()
   //---------------------------------------------------------------------------------
\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)
   /* verilator lint_on WIDTH */
\TLV
   
   $reset = *reset;
   
   
   // Program Counter (PC) Logic:
   // 1. Calculate Next PC: Increment current PC by 4 (since instructions are 4 bytes long).
   // 2. PC Register: On reset, start at address 0. Otherwise, take the next_pc value from the previous cycle.
   $pc[31:0] = >>1$next_pc;
   $next_pc[31:0] = $reset ? 0:
                    $taken_br ? $br_tgt_pc[31:0]:
                    $is_jal ? $br_tgt_pc[31:0]:
                    $is_jalr ? $jalr_tgt_pc[31:0]:
                    $pc[31:0] + 3'b100;

   // Instruction Memory (IMem):
   `READONLY_MEM($pc[31:0], $$instr[31:0])

   //Decode Logic:Instruction Type
   //U-type
   $is_u_instr = $instr[6:2] ==? 5'b0x101;
   //I-type
   $is_i_instr = $instr[6:2] ==? 5'b0000x ||
                 $instr[6:2] ==? 5'b001x0 ||
                 $instr[6:2] == 5'b11001;
   //S-type
   $is_s_instr = $instr[6:2] ==? 5'b0100x;
   //B-type
   $is_b_instr = $instr[6:2] == 5'b11000;
   //R-type
   $is_r_instr = $instr[6:2] ==? 5'b011x0 ||
                 $instr[6:2] ==  5'b01011 ||
                 $instr[6:2] ==  5'b10100;
   //J-type
   $is_j_instr = $instr[6:2] == 5'b11011;
  
   
   //Decode Logic:Instruction Fields
   $funct3[2:0] = $instr[14:12];
   $rs1[4:0] = $instr[19:15];
   $rs2[4:0] = $instr[24:20];
   $rd[4:0] = $instr[11:7];
   $opcode[6:0] = $instr[6:0];
   
   $funct3_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
   $rs1_valid = $is_r_instr || $is_i_instr || $is_s_instr || $is_b_instr;
   $rs2_valid = $is_r_instr || $is_s_instr || $is_b_instr;
   //$rd == 0 ? 0 this line is for avoid to change x0 register 
   $rd_valid = $rd == 0 ? 0:
               $is_r_instr || $is_i_instr || $is_u_instr || $is_j_instr;
   $imm_valid = $is_i_instr || $is_s_instr || $is_b_instr || $is_u_instr || $is_j_instr;
   
   $imm[31:0] = $is_i_instr ? {{21{$instr[31]}}, $instr[30:20]}:
                $is_s_instr ? {{21{$instr[31]}}, $instr[30:25], $instr[11:7]}:
                $is_b_instr ? {{20{$instr[31]}}, $instr[7], $instr[30:25], $instr[11:8], 1'b0}:
                $is_u_instr ? {{1{$instr[31]}}, $instr[30:20], $instr[19:12], 12'b0}:
                $is_j_instr ? {{11{$instr[31]}}, $instr[19:12], $instr[20], $instr[30:25], $instr[24:21], 1'b0}:
                32'b0;
                
   //Decode Logic: Instruction
   $dec_bits[10:0] = {$instr[30],$funct3,$opcode};
   
   //B-Type Instruction
   $is_beq = $dec_bits ==? 11'bx_000_1100011;
   $is_bne = $dec_bits ==? 11'bx_001_1100011;
   $is_blt = $dec_bits ==? 11'bx_100_1100011;
   $is_bge = $dec_bits ==? 11'bx_101_1100011;
   $is_bltu = $dec_bits ==? 11'bx_110_1100011;
   $is_bgeu = $dec_bits ==? 11'bx_111_1100011;
   
   //ADDI Instruction
   $is_addi = $dec_bits ==? 11'bx_000_0010011;
   
   //ADD Instruciton
   $is_add = $dec_bits ==? 11'b0_000_0110011;

   // Upper Immediate & Jumps
   $is_lui   = $dec_bits ==? 11'bx_xxx_0110111;
   $is_auipc = $dec_bits ==? 11'bx_xxx_0010111;
   $is_jal   = $dec_bits ==? 11'bx_xxx_1101111;
   $is_jalr  = $dec_bits ==? 11'bx_000_1100111; 

   // I-Type (Logical/Shift/Compare)
   $is_slti  = $dec_bits ==? 11'bx_010_0010011;
   $is_sltiu = $dec_bits ==? 11'bx_011_0010011;
   $is_xori  = $dec_bits ==? 11'bx_100_0010011;
   $is_ori   = $dec_bits ==? 11'bx_110_0010011;
   $is_andi  = $dec_bits ==? 11'bx_111_0010011;
   
   $is_slli  = $dec_bits ==? 11'b0_001_0010011;
   $is_srli  = $dec_bits ==? 11'b0_101_0010011;
   $is_srai  = $dec_bits ==? 11'b1_101_0010011; 
   
   // R-Type (All)
   $is_sub   = $dec_bits ==? 11'b1_000_0110011;
   $is_sll   = $dec_bits ==? 11'b0_001_0110011;
   $is_slt   = $dec_bits ==? 11'b0_010_0110011;
   $is_sltu  = $dec_bits ==? 11'b0_011_0110011;
   $is_xor   = $dec_bits ==? 11'b0_100_0110011;
   $is_srl   = $dec_bits ==? 11'b0_101_0110011;
   $is_sra   = $dec_bits ==? 11'b1_101_0110011;
   $is_or    = $dec_bits ==? 11'b0_110_0110011;
   $is_and   = $dec_bits ==? 11'b0_111_0110011;
   
   // Load Instruction (LW - Load Word)
   $is_load = $dec_bits ==? 11'bx_xxx_0000011;
   
   //SLTU and SLTI (set if less than, unsigned) results:
   $sltu_rslt[31:0] = {31'b0, $src1_value < $src2_value};
   $sltiu_rslt[31:0] = {31'b0, $src1_value < $imm};
   
   //SRA and SRAI (shift right, arithmetic) results:
   //   sign-extended src1
   $sext_src1[63:0] = {{32{$src1_value[31]}}, $src1_value};
   //   64-bit sign-extended results, to be truncated
   $sra_rslt[63:0] = $sext_src1 >> $src2_value[4:0];
   $srai_rslt[63:0] = $sext_src1 >> $imm[4:0];
   
   //ALU(Arithmetic Logic Unit)
   $result[31:0] = 
      // Arithmetic & Logic (Immediate)
      $is_andi ? $src1_value & $imm :
      $is_ori  ? $src1_value | $imm :
      $is_xori ? $src1_value ^ $imm :
      $is_addi ? $src1_value + $imm :
      
      // Shift Operations (Immediate)
      $is_slli ? $src1_value << $imm[5:0] :
      $is_srli ? $src1_value >> $imm[5:0] :
      
      // Arithmetic & Logic (Register)
      $is_and  ? $src1_value & $src2_value :
      $is_or   ? $src1_value | $src2_value :
      $is_xor  ? $src1_value ^ $src2_value :
      $is_add  ? $src1_value + $src2_value :
      $is_sub  ? $src1_value - $src2_value :
      
      // Shift Operations (Register)
      $is_sll  ? $src1_value << $src2_value[4:0] :
      $is_srl  ? $src1_value >> $src2_value[4:0] :
      
      // Compare (Unsigned)
      $is_sltu ? $sltu_rslt :
      $is_sltiu? $sltiu_rslt :
      
      // Upper Immediate & Jump (Link Register Value: PC + 4)
      $is_lui  ? {$imm[31:12], 12'b0} :
      $is_auipc? $pc + $imm :
      $is_jal  ? $pc + 4 :
      $is_jalr ? $pc + 4 :
      
      // Compare (Signed - Görseldeki özel mantık)
      $is_slt  ? ( ($src1_value[31] == $src2_value[31]) ? $sltu_rslt : {31'b0, $src1_value[31]} ) :
      $is_slti ? ( ($src1_value[31] == $imm[31])       ? $sltiu_rslt : {31'b0, $src1_value[31]} ) :
      
      // Arithmetic Shift Results
      $is_sra  ? $sra_rslt :
      $is_srai ? $srai_rslt :
      
      //Load Store Instructions
     ($is_load / $is_s_instr) ? $rs1 + $imm:
      
      // Default
      32'b0;
   
   //Branch Logic
   $taken_br = $is_beq ? ($src1_value == $src2_value):
               $is_bne ? ($src1_value != $src2_value):
               $is_blt ? (($src1_value < $src2_value) ^ ($src1_value[31] != $src2_value[31])):
               $is_bge ? (($src1_value >= $src2_value) ^ ($src1_value[31] != $src2_value[31])):
               $is_bltu ? ($src1_value < $src2_value):
               $is_bgeu ? ($src1_value >= $src2_value):
               1'b0;
               
   $br_tgt_pc[31:0] = $pc + $imm;
   $jalr_tgt_pc[31:0] = $src1_value + $imm;
   
   
   
   
   // Assert these to end simulation (before Makerchip cycle limit).
   //*passed = 1'b0;
   m4+tb()
   *failed = *cyc_cnt > M4_MAX_CYC;
   
   // Eğer Load işlemiyse hafızadan gelen veriyi ($ld_data), değilse ALU sonucunu ($result) yaz.
   m4+rf(32, 32, $reset, $rd_valid, $rd, $is_load ? $ld_data : $result[31:0], $rs1_valid, $rs1[4:0], $src1_value, $rs2_valid, $rs2[4:0], $src2_value)
   m4+dmem(32, 32, $reset, $result[6:2], $is_s_instr, $src2_value, $is_load, $ld_data)
   m4+cpu_viz()
\SV
   endmodule