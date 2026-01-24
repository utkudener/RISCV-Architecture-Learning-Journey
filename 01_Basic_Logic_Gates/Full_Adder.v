\m5_TLV_version 1d: tl-x.org
\m5
   
   // ============================================
   // Welcome, new visitors! Try the "Learn" menu.
   // ============================================
   
   //use(m5-1.0)   /// uncomment to use M5 macro library.
\SV
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   $reset = *reset;
   
   //...
   
   /*$xor = (!$in1 || !$in2) && ($in1 || $in2);
   $and1 = $xor && $carry_in;
   $and2 = $in1 && $in2;
   $out = (!$xor || !$carry_in) && ($xor || $carry_in);
   $carry_out = $and1 || $and2;*/
   
   /*$out = (!((!$in1 || !$in2) && ($in1 || $in2)) || !$carry_in) && (((!$in1 || !$in2) && ($in1 || $in2)) || $carry_in);
   $carry_out = (((!$in1 || !$in2) && ($in1 || $in2))&&$carry_in)||($in1&&$in2);
   */
   
   $out = (($in1 ^ $in2) ^ $carry_in);
   $carry_out = (($in1 ^ $in2) && $carry_in) || ($in1 && $in2);
   
   // Assert these to end simulation (before the cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
