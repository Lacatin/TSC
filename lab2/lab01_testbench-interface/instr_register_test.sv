/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/

import instr_register_pkg::*;
`include "first_test.sv"

module instr_register_test
  import instr_register_pkg::*;  // user-defined types are defined in instr_register_pkg.sv
  (
    tb_ifc.TEST lab2_ifc
  );

  initial begin
    first_test ft;
    ft = new(lab2_ifc);

    // Run
    ft.init_sim();
  end

endmodule: instr_register_test
