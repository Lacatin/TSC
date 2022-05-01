class first_test;
  // Number of transaction parameter
  int NR_OF_TRANSACTIONS;

  // Global error counter
  int err_cnt;

  // Interface declaration
  virtual tb_ifc.TEST lab2_ifc;

  covergroup func_cov;
    operand_a : coverpoint lab2_ifc.cb.operand_a {
      bins positive_numbers[] = {[1:15]};
      bins negative_numbers[] = {[-15:-1]};
      bins zero_value = {0};
    }
    operand_b : coverpoint lab2_ifc.cb.operand_b {
      bins positive_numbers[] = {[1:15]};
      bins zero_value = {0};
    }
    opcode : coverpoint lab2_ifc.cb.opcode {
      option.auto_bin_max = 8;
    }
    result : coverpoint lab2_ifc.cb.instruction_word.result {
      bins res_values[] = {[-225:225]};
    }
  endgroup

  // Constructor
  function new(virtual tb_ifc.TEST ifc);
    this.lab2_ifc = ifc;
    this.err_cnt = 0;
    func_cov = new();
  endfunction

  task init_sim();
    // Get the number of transactions
    if (!$value$plusargs("NR_OF_TRANS=%0d", NR_OF_TRANSACTIONS)) begin
      NR_OF_TRANSACTIONS = 5;
    end

    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "***********************************************************");

    $display("\nReseting the instruction register...");
    lab2_ifc.cb.write_pointer  <= 5'h00;         // initialize write pointer
    lab2_ifc.cb.read_pointer   <= 5'h1F;         // initialize read pointer
    lab2_ifc.cb.load_en        <= 1'b0;          // initialize load control line
    lab2_ifc.cb.reset_n        <= 1'b0;          // assert reset_n (active low)
    repeat (2) @(posedge lab2_ifc.cb) ;          // hold in reset for 2 clock cycles
    lab2_ifc.cb.reset_n        <= 1'b1;          // deassert reset_n (active low)

    $display("\nWriting values to register stack...");
    @(posedge lab2_ifc.cb) lab2_ifc.cb.load_en <= 1'b1;  // enable writing to register
    repeat (NR_OF_TRANSACTIONS) begin
      @(posedge lab2_ifc.cb) randomize_transaction;
      @(negedge lab2_ifc.cb) print_transaction;
      func_cov.sample();
    end
    @(posedge lab2_ifc.cb) lab2_ifc.cb.load_en <= 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
    for (int i = 0; i < NR_OF_TRANSACTIONS; i++) begin
      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back
      @(posedge lab2_ifc.cb) lab2_ifc.cb.read_pointer <= i;
      @(negedge lab2_ifc.cb) print_results;
      func_cov.sample();
    end

    @(posedge lab2_ifc.cb) ;
    $display("\n***********************************************************");
    $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");

    // Error evaluation
    if (this.err_cnt == 0) begin
      $display("TEST PASSED");
    end else if (this.err_cnt > 0) begin
      $display("TEST FAILED (%0d errors)", this.err_cnt);
    end

    $finish;
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
    lab2_ifc.cb.operand_a     <= $signed($urandom)%16;                       // between -15 and 15
    lab2_ifc.cb.operand_b     <= $unsigned($urandom)%16;            // between 0 and 15
    lab2_ifc.cb.opcode        <= opcode_t'($unsigned($urandom)%8);  // between 0 and 7, cast to opcode_t type
    lab2_ifc.cb.write_pointer <= temp++;
  endfunction: randomize_transaction

  function void print_transaction;
    $display("Writing to register location %0d: ", lab2_ifc.cb.write_pointer);
    $display("  opcode = %0d (%s)", lab2_ifc.cb.opcode, lab2_ifc.cb.opcode.name);
    $display("  operand_a = %0d",   lab2_ifc.cb.operand_a);
    $display("  operand_b = %0d\n", lab2_ifc.cb.operand_b);
  endfunction: print_transaction

  function void print_results;
    $display("Read from register location %0d: ", lab2_ifc.cb.read_pointer);
    $display("  opcode = %0d (%s)", lab2_ifc.cb.instruction_word.opc, lab2_ifc.cb.instruction_word.opc.name);
    $display("  operand_a = %0d",   lab2_ifc.cb.instruction_word.op_a);
    $display("  operand_b = %0d",   lab2_ifc.cb.instruction_word.op_b);
    $display("  result    = %0d\n", lab2_ifc.cb.instruction_word.result);
    case (lab2_ifc.cb.instruction_word.opc.name)
      "PASSA" : begin
        if (lab2_ifc.cb.instruction_word.result != lab2_ifc.cb.instruction_word.op_a) begin
          $error("PASSA operation error: Expected result = %0d Actual result = %0d\n", lab2_ifc.cb.instruction_word.op_a, lab2_ifc.cb.instruction_word.result);
          err_cnt += 1;
        end
      end
      "PASSB" : begin
        if (lab2_ifc.cb.instruction_word.result != lab2_ifc.cb.instruction_word.op_b) begin
          $error("PASSB operation error: Expected result = %0d Actual result = %0d\n", lab2_ifc.cb.instruction_word.op_b, lab2_ifc.cb.instruction_word.result);
          err_cnt += 1;
        end
      end
      "ADD" : begin
        if (lab2_ifc.cb.instruction_word.result != $signed(lab2_ifc.cb.instruction_word.op_a + lab2_ifc.cb.instruction_word.op_b)) begin
          $error("ADD operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_ifc.cb.instruction_word.op_a + lab2_ifc.cb.instruction_word.op_b), lab2_ifc.cb.instruction_word.result);
          err_cnt += 1;
        end
      end
      "SUB" : begin
        if (lab2_ifc.cb.instruction_word.result != $signed(lab2_ifc.cb.instruction_word.op_a - lab2_ifc.cb.instruction_word.op_b)) begin
          $error("SUB operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_ifc.cb.instruction_word.op_a - lab2_ifc.cb.instruction_word.op_b), lab2_ifc.cb.instruction_word.result);
          err_cnt += 1;
        end
      end
      "MULT" : begin
        if (lab2_ifc.cb.instruction_word.result != $signed(lab2_ifc.cb.instruction_word.op_a * lab2_ifc.cb.instruction_word.op_b)) begin
          $error("MULT operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_ifc.cb.instruction_word.op_a * lab2_ifc.cb.instruction_word.op_b), lab2_ifc.cb.instruction_word.result);
          err_cnt += 1;
        end
      end
      "DIV" : begin
        if (lab2_ifc.cb.instruction_word.result != $signed(lab2_ifc.cb.instruction_word.op_a / lab2_ifc.cb.instruction_word.op_b)) begin
          $error("DIV operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_ifc.cb.instruction_word.op_a / lab2_ifc.cb.instruction_word.op_b), lab2_ifc.cb.instruction_word.result);
          err_cnt += 1;
        end
      end
      "MOD" : begin
        if (lab2_ifc.cb.instruction_word.result != $signed(lab2_ifc.cb.instruction_word.op_a % lab2_ifc.cb.instruction_word.op_b)) begin
          $error("MOD operation error: Expected result = %0d Actual result = %0d\n", $signed(lab2_ifc.cb.instruction_word.op_a % lab2_ifc.cb.instruction_word.op_b), lab2_ifc.cb.instruction_word.result);
          err_cnt += 1;
        end
      end
    endcase
  endfunction: print_results

endclass