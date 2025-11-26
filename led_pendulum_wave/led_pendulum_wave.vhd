--  Module that emulates a wave of swinging pendulums via leds.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.led_pendulum_wave_pkg.all;

entity led_pendulum_wave is
  port (
    clk    : in std_logic;
    resetn : in std_logic;
    -- enable wave
    en     : in std_logic;
    -- led outputs
    led    : out std_logic_vector (num_pendulums-1 downto 0)
  );
end led_pendulum_wave;

architecture rtl of led_pendulum_wave is
  -- individual led pendulum component
  component led_pendulum
    generic (toggle_period_clks : natural);
    port (
      clk    : in std_logic;
      resetn : in std_logic;
      -- enable pendulum "swing"
      en     : in  std_logic;
      -- led drive
      led    : out std_logic
    );
  end component led_pendulum;
begin
  pendulum_instantiations : for i in 0 to num_pendulums-1 generate
    pendulum_i : led_pendulum
      generic map (
        toggle_period_clks => calc_toggle_period(wave_time_length_clks, base_oscillations + i)
      )
      port map (
        clk => clk,
        resetn => resetn,
        en => en,
        led => led(i)
      );
  end generate pendulum_instantiations;
end rtl;

