// TODO: custom testbench module name here
module testbench_tb;
  localparam CLK_HALF_PERIOD_NS = 5;
  logic clk, resetn;

  // TODO: custom port declarations here

  // TODO: DUT instantiation here

  // clock generation
  initial begin
    clk = 1;

    forever begin
      #(CLK_HALF_PERIOD_NS * 1ns); clk = !clk;
    end
  end

  // stimulus generation
  initial begin
    do_reset();

    // TODO: custom stimulus here
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

