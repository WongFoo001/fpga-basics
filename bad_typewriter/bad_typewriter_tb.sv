module bad_typewriter_tb;
  localparam CLK_HALF_PERIOD_NS = 5;
  logic clk, resetn, shift, dp;
  logic [7:0] char, an, cath;

  bad_typewriter DUT (
    .clk(clk),
    .resetn(resetn),
    .shift(shift),
    .dp(dp),
    .char(char),
    .an(an),
    .cath(cath)
  );

  // clock generation
  initial begin
    clk = 1;

    forever begin
      #(CLK_HALF_PERIOD_NS * 1ns); clk = !clk;
    end
  end

  // stimulus generation
  initial begin
    resetn = 1;
    shift = 0;
    dp = 0;
    char = 'h30;

    // initial reset
    do_reset();

    #1ms;
    char = 'h31;
    #1ms;
    char = 'h32;

    $finish();
  end

  initial begin
    #500us do_shift();
    #100us do_shift();
    #1ms do_shift();
  end

  task wait_num_clocks(int unsigned num);
    repeat(num) #(2 * CLK_HALF_PERIOD_NS * 1ns);
  endtask

  task do_reset();
    resetn = 0;
    wait_num_clocks(2);
    resetn = 1;
    wait_num_clocks(1);
  endtask

  task do_shift();
    shift = 1;
    wait_num_clocks(200001);
    shift = 0;
    wait_num_clocks(1);

  endtask
endmodule
