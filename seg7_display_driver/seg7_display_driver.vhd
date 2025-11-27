--  Module that controls a common-anode seven-segment
-- display circuit. Supports A-Z,a-z,0-9 and decimal points,
-- allowing application to supply desired characters directly
-- as opposed to cathode-encodings.
--
-- NOTE: For readability, driver will output some letters in either
-- lowercase or uppercase regardless of capitalization of input.
--
-- NOTE: that it assumes an 8-digit display while not all 8
-- need be driven, it cannot drive more than eight as the
-- anode driver period-divisions are not parameterizable.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.seg7_display_driver_pkg.all;

entity seg7_display_driver is
  generic (
    display_refresh_period_clks : natural := nexys_a7_display_refresh_period_clks
  );
  port (
    clk        : in std_logic;
    resetn     : in std_logic;
    -- TEMP: single digit for testing
    input_char : in raw_character_t;
    input_dp   : in std_logic;
    -- 7-seg drive
    -- TEMP anode can be single bit since we're only driving one digit
    an         : out anode_select_t;
    -- cathode drive
    cath       : out cathode_encoding_t
  );
end seg7_display_driver;

architecture rtl of seg7_display_driver is
begin
  cath <= cathode_encoding_lookup(input_char, input_dp);
  -- drive only digit 0
  an <= "11111110";
end rtl;

