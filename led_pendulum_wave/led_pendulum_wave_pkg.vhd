library ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.general_utilities_pkg.all;

package led_pendulum_wave_pkg is
  -- Calculates the period inbetween toggles for a singular pendulum
  -- of a pendulum wave given the time length and number of desired
  -- oscillations.
  function calc_toggle_period(
    wave_time_length_clks        : natural;
    oscillations_per_time_length : natural
  ) return natural;
end led_pendulum_wave_pkg;

package body led_pendulum_wave_pkg is
  function calc_toggle_period(
    wave_time_length_clks        : natural;
    -- avoid unexpected divide-by-zero
    oscillations_per_time_length : natural range 1 to natural'high
  ) return natural is
    variable toggles_per_time_length : natural := 2 * oscillations_per_time_length;
    variable toggle_period_real      : real    := wave_time_length_clks / toggles_per_time_length;
    variable toggle_period_clks      : natural := natural(ceil(toggle_period_real));
  begin
    return toggle_period_clks;
  end function;

end led_pendulum_wave_pkg;
