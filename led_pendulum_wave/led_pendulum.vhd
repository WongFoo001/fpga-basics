--  Module that emulates the swing of a pendulum via an led.
--
--  Pendulum period is parameterizable via:
--    - Number of clock periods per timelength
--    - Number of oscillations per timelength

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- use work.general_utilities_pkg.all;

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
  -- signal toggle_period_counter_r : unsigned(bitwidth(toggle_period_clks)-1 downto 0);
  signal toggle_period_counter_r : unsigned(12 downto 0);
begin
  toggle_period_counting : process(clk)
  begin
    if resetn = 0 then
      toggle_period_counter_r <= to_unsigned(toggle_period_clks, toggle_period_counter_r'length);
    else
      if en = 0 then
      -- swing disabled, acts as a soft reset of the swing pattern
        led <= 0;
        toggle_period_counter_r <= to_unsigned(toggle_period_clks, toggle_period_counter_r'length);
      else
      -- swing enabled, toggle led on counter reset/roll-over
        if toggle_period_counter_r = 0 then
        -- counter roll-over
          led <= not led;
          toggle_period_counter_r <= to_unsigned(toggle_period_clks, toggle_period_counter_r'length);
        else
        -- counter increment
          toggle_period_counter_r <= toggle_period_counter_r - 1;
        end if;
      end if;
    end if;
  end process toggle_period_counting;
end rtl;

