/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/

//---------NOTITE---------

//task-ul consuma timp de simulare , functia nu. Task-ul nu returneaza nimic.

//---------NOTITE SFARSIT---------

  import instr_register_pkg::*;  // user-defined types are defined in instr_register_pkg.sv
  `include "first_class.svh"

module instr_register_test
  (
    tb_ifc.TEST lab2_ifc
  );

  //timeunit 1ns/1ns;


  initial begin

    first_class fs;
    fs=new(lab2_ifc);
    fs.run();

  end

endmodule: instr_register_test
