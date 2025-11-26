module led_pendulum_tb;
  logic clk, resetn, en, led;

  /* toggle_period_clks calculation:
    - time-length = 1ms, clk = 10ns -> 100000 clks
    - oscillations = 10

    toggle period clks = ceil(100000 / (2 * 10)) = 5000
    bitwidth = 13
  */
  led_pendulum #(
    .toggle_period_clks(5000)
  ) DUT (
    .clk(clk),
    .resetn(resetn),
    .en(en),
    .led(led)
  );
  
  // 100 MHz clock generation
  initial begin
    clk = 0;
    forever begin
      #5ns clk = !clk;
    end
  end


  // test pendulum
  initial begin
    en = 0;
    do_reset();
    en = 1;
    #5ms;
    $finish();
  end

  task do_reset();
    resetn = 0;
    #20ns;
    resetn = 1;
    #20ns;
  endtask
endmodule

