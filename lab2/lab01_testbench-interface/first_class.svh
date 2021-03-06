class first_class;

  //int seed = 7777;
  int k = 0;
  parameter NUMBER_OF_TRANSACTIONS = 100; // parametrul ramane fix la compilare
  virtual tb_ifc.TEST lab2_ifc;

    function new( virtual tb_ifc ifc);
        lab2_ifc = ifc;
    endfunction

  //initial begin
    task run();
    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "***********************************************************");
    $display("FIRST HEADER");

    $display("\nReseting the instruction register...");
    lab2_ifc.cb.write_pointer  <= 5'h00;         // initialize write pointer
    lab2_ifc.cb.read_pointer   <= 5'h1F;         // initialize read pointer
    lab2_ifc.cb.load_en        <= 1'b0;          // initialize load control line
    lab2_ifc.cb.reset_n        <= 1'b0;          // assert reset_n (active low)
    repeat (2) @(posedge lab2_ifc.cb) ;          // hold in reset for 2 clock cycles
    lab2_ifc.cb.reset_n        <= 1'b1;          // deassert reset_n (active low)

    $display("\nWriting values to register stack...");
    @(posedge lab2_ifc.cb) lab2_ifc.cb.load_en <= 1'b1;  // enable writing to register
    repeat (NUMBER_OF_TRANSACTIONS) begin
      @(posedge lab2_ifc.cb) randomize_transaction;
      @(negedge lab2_ifc.cb) print_transaction;
    end
    @(posedge lab2_ifc.cb) lab2_ifc.cb.load_en <= 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
    for (int i=NUMBER_OF_TRANSACTIONS; i>=0; i--) begin
      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back
      k = $unsigned($random)%5;
      @(posedge lab2_ifc.cb) lab2_ifc.cb.read_pointer <= k;
      @(negedge lab2_ifc.cb) print_results;
    end

    @(posedge lab2_ifc.cb) ;
    $display("\n***********************************************************");
    $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");
    $finish;
  //end
  endtask

  function void randomize_transaction;
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    //
    static int temp = 0;
    lab2_ifc.cb.operand_a     <= $urandom%16;                 // between -15 and 15 // random genereaza valori random pe 32 de biti
    lab2_ifc.cb.operand_b     <= $unsigned($urandom)%16;            // between 0 and 15
    lab2_ifc.cb.opcode        <= opcode_t'($unsigned($urandom)%8);  // between 0 and 7, cast to opcode_t type
    lab2_ifc.cb.write_pointer <= temp++;
  endfunction: randomize_transaction

  function void print_transaction;
    $display("Writing to register location %0d: ", lab2_ifc.cb.write_pointer);
    $display("  opcode <= %0d (%s)", lab2_ifc.cb.opcode, lab2_ifc.cb.opcode.name);
    $display("  operand_a <= %0d",   lab2_ifc.cb.operand_a);
    $display("  operand_b <= %0d\n", lab2_ifc.cb.operand_b);
  endfunction: print_transaction

//functie de check_results daca se trec rezulatele print pass/failed

  function void print_results;
    $display("Read from register location %0d: ", lab2_ifc.cb.read_pointer);
    $display("  opcode <= %0d (%s)", lab2_ifc.cb.instruction_word.opc, lab2_ifc.cb.instruction_word.opc.name);
    $display("  operand_a <= %0d",   lab2_ifc.cb.instruction_word.op_a);
    $display("  operand_b <= %0d\n", lab2_ifc.cb.instruction_word.op_b);
  endfunction: print_results

  endclass 
