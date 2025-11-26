library ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.general_utilities_pkg.all;

package led_pendulum_wave_pkg is
  -- Number of 'pendulums' to make up wave
  constant num_pendulums : natural := 16;
  -- Base number of oscillations per wavelength. Each consectutive
  -- pendulum will add 1 to the previous pendulum's oscillations.
  constant base_oscillations : natural := 1;
  -- Default time-length for osciallations in clock periods
  -- Desired time-length: 1s -> 1E8 10ns clock periods
  --constant wave_time_length_clks : natural := 100000000;
  constant wave_time_length_clks : natural := 10000;

  -- Calculates the period inbetween toggles for a singular pendulum
  -- of a pendulum wave given the time length and number of desired
  -- oscillations.
  function calc_toggle_period(
    wave_time_length_clks        : natural;
    oscillations_per_time_length : natural range 1 to natural'high
  ) return natural;
end led_pendulum_wave_pkg;

package body led_pendulum_wave_pkg is
  function calc_toggle_period(
    wave_time_length_clks        : natural;
    -- avoid unexpected divide-by-zero
    oscillations_per_time_length : natural range 1 to natural'high
  ) return natural is
    variable toggles_per_time_length : natural := 2 * oscillations_per_time_length;
  begin
    return wave_time_length_clks / toggles_per_time_length;
  end function;

end led_pendulum_wave_pkg;
