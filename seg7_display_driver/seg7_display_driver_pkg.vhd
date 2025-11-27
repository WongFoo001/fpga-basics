library ieee;
use ieee.numeric_std.all;

package seg7_display_driver_pkg is
  -- Number of digits in display, Nexys A7 has 8
  constant num_digits_in_display : natural := 8;

  -- Controller timing constants (assuming 100 MHz clock):
  --
  -- Documentation describes observable flicker at refresh
  -- rate of 45Hz (~22.2ms period)
  -- 
  -- Thus chosen refresh rate of 1kHz (1ms period)
  --   --> in 100Mhz (10ns) system clocks = 100000
  constant display_refresh_period_clks : natural := 100000;

  -- Controller divides up period into 'num_digits_in_display'
  -- sections - where in each it drives one digit's anode active
  constant digit_active_period_clks : natural := display_refresh_period_clks / num_digits_in_display;
end seg7_display_driver_pkg;

