--  Module that emulates the swing of a pendulum via an led.
--
--  Pendulum period is parameterizable via:
--    - Number of clock periods per timelength
--    - Number of oscillations per timelength

library ieee;
use ieee.std_logic_1164.all;
use led_pendulum_wave_pkg.all;

entity led_pendulum is
  generic (
    TIMELENGTH_CLKS             : integer;
    OSCILLATIONS_PER_TIMELENGTH : integer
  );
  port (
    clk    : in std_logic;
    resetn : in std_logic;
    -- enable pendulum "swing"
    en     : in  std_logic;
    -- led drive
    led    : out std_logic
  );
end led_pendulum;

architecture rtl of led_pendulum is
  -- Each oscillation requires two toggles (off, on)
  constant TOGGLES_PER_TIMELENGTH : integer := OSCILLATIONS_PER_TIMELENGTH * 2;
  -- # of clock periods before toggling is computed via:
  --   # of clks in time-length  / # of toggles per time-length
  constant TOGGLE_PERIOD_CLKS     : integer := integer(floor(real(TIMELENGTH_CLKS) / real(TOGGLES_PER_TIMELENGTH)));
  -- counter register
  signal toggle_period_counter_r : unsigned(
begin
end rtl;


