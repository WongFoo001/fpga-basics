module led_toggle_tb;
  bit en, led;

  led_toggle DUT (
    .en(en),
    .led(led)
  );

  // randomly toggle en for some time
  initial begin
    drive_en_stimulus(.num_repeats(30));
  end

  task random_delay_ns(int unsigned upper_bound=20, int unsigned lower_bound=1);
    automatic int unsigned delay;
    
    if (!std::randomize(delay) with {delay >= lower_bound; delay <= upper_bound;}) begin
      $fatal("@(%0d) from 'random_delay_ns()': std::randomize() failed!");
    end

    #(delay) * 1ns;
  endtask

  task random_en_state();
    if (!std::randomize(en)) begin
      $fatal("@(%0d) from 'random_en_state()': std::randomize() failed!");
    end
  endtask

  task drive_en_stimulus(int unsigned num_repeats);
    repeat(num_repeats) begin
      random_en_state();
      random_delay_ns();
    end
  endtask
endmodule

