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
    -- Character and decimal-point inputs for each display
    display_in : in char_inputs_t;
    -- Anode selection
    an         : out anode_select_t;
    -- cathode encoding drive
    cath       : out cathode_encoding_t
  );
end seg7_display_driver;

architecture rtl of seg7_display_driver is
  -- Single anode period in clks
  constant single_anode_period_clks : natural := nexys_a7_display_refresh_period_clks / nexys_a7_num_digits_in_display;
  -- active anode period tracker
  signal anode_period_counter_r : natural;
  -- anode and cathode output registers
  signal an_r : anode_select_t;
  signal cath_r : cathode_encoding_t;
begin
  process_anode_ctrl : process(clk)
  begin
    if rising_edge(clk) then
      if resetn = '0' then
        -- Activate(active-low) digit 0 only
        an_r <= (0 => '0', others => '1');
        anode_period_counter_r <= single_anode_period_clks;
      else
        if anode_period_counter_r = 0 then
          -- emulate : an_r rol 1
          -- rotate active anode 1 to the left
          an_r <= an_r(6 downto 0) & an_r(7);

          -- reset period counter
          anode_period_counter_r <= single_anode_period_clks;
        else
          -- decrement period counter
          anode_period_counter_r <= anode_period_counter_r - 1;
        end if;
      end if;
    end if;
  end process process_anode_ctrl;

  process_cathode_ctrl : process(clk)
  begin
    if rising_edge(clk) then
      if resetn = '0' then
        -- default to blank display
        cath_r <= (others => '1');
      else
        case an_r is
          when "11111110" =>
            cath_r <= cathode_encoding_lookup(display_in.digit_0, display_in.dp_0);
          when "11111101" =>
            cath_r <= cathode_encoding_lookup(display_in.digit_1, display_in.dp_1);
          when "11111011" =>
            cath_r <= cathode_encoding_lookup(display_in.digit_2, display_in.dp_2);
          when "11110111" =>
            cath_r <= cathode_encoding_lookup(display_in.digit_3, display_in.dp_3);
          when "11101111" =>
            cath_r <= cathode_encoding_lookup(display_in.digit_4, display_in.dp_4);
          when "11011111" =>
            cath_r <= cathode_encoding_lookup(display_in.digit_5, display_in.dp_5);
          when "10111111" =>
            cath_r <= cathode_encoding_lookup(display_in.digit_6, display_in.dp_6);
          when "01111111" =>
            cath_r <= cathode_encoding_lookup(display_in.digit_7, display_in.dp_7);
          when others =>
            cath_r <= cath_r;
        end case;
      end if;
    end if;
  end process process_cathode_ctrl;

  -- output assignments
  an <= an_r;
  cath <= cath_r;
end rtl;

