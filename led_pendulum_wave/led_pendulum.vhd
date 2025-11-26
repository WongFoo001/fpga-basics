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
    toggle_period_clks : natural
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
  -- counter register
  signal toggle_period_counter_r : unsigned(bitwidth(toggle_period_clks)-1 downto 0);
begin
end rtl;


