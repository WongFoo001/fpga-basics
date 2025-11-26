module led_pendulum_wave_tb;
  logic clk, resetn, en;
  logic [15:0] led;

  led_pendulum_wave DUT (
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

