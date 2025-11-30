module debouncer_tb;
  localparam CLK_HALF_PERIOD_NS = 5;
  logic clk, resetn;
  logic raw_in, debounced_out;

  // TODO: DUT instantiation here
  debouncer #(
    .debounce_period_clks(100)
  ) DUT (
    .clk(clk),
    .resetn(resetn),
    .raw_in(raw_in),
    .debounced_out(debounced_out)
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
    raw_in = 0;
    do_reset();

    // failed propagation
    raw_in = 1;
    wait_num_clocks(99);
    // successful propagation
    raw_in = 0;
    wait_num_clocks(1);
    raw_in = 1;
    wait_num_clocks(101);

    // now transition the other direction
    // failed propagation
    raw_in = 0;
    wait_num_clocks(99);
    // successful propagation
    raw_in = 1;
    wait_num_clocks(1);
    raw_in = 0;
    wait_num_clocks(101);
    $finish();
  end

  task wait_num_clocks(int unsigned num);
    repeat(num) #(2 * CLK_HALF_PERIOD_NS * 1ns);
  endtask

  task do_reset();
    resetn = 0;
    wait_num_clocks(3);
    resetn = 1;
    wait_num_clocks(1);
  endtask
endmodule

