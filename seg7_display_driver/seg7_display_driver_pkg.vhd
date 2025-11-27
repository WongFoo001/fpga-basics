library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package seg7_display_driver_pkg is
  -- Character subtype for convenience and readability
  subtype raw_character_t is std_logic_vector(7 downto 0);
  -- Cathode-encoding subtype for convenience and readability
  -- NOTE: There are only 7 character cathodes, MSB is for DP cathode.
  subtype cathode_encoding_t is std_logic_vector(7 downto 0);

  -- Number of digits in display, Nexys A7 has 8
  constant nexys_a7_num_digits_in_display : natural := 8;

  -- Controller timing constants (assuming 100 MHz clock):
  --
  -- Documentation describes observable flicker at refresh
  -- rate of 45Hz (~22.2ms period)
  -- 
  -- Thus chosen refresh rate of 1kHz (1ms period)
  --   --> in 100Mhz (10ns) system clocks = 100000
  constant nexys_a7_display_refresh_period_clks : natural := 100000;

  -- Controller divides up period into 'num_digits_in_display'
  -- sections - where in each it drives one digit's anode active
  constant digit_active_period_clks : natural := display_refresh_period_clks / num_digits_in_display;
  
  function character_cathode_encoding_lookup(
    input_char : raw_character_t;
    input_dp   : std_logic
  ) return cathode_encoding_t;
end seg7_display_driver_pkg;

package body seg7_display_driver_pkg is
  function character_cathode_encoding_lookup(
    input_char : raw_character_t;
    input_dp   : std_logic
  ) return cathode_encoding_t is
    signal cathode_enc : cathode_encoding_t;
  begin
    -- NOTE: While input characters/dp are active-high, all cathode
    -- encodings are active-low. Encodings are mapped as follows:
    -- {DP, G, F, E, D, C, B, A}

    -- Decimal-point encoding:
    cathode_enc(7) <= not input_dp;

    -- Character to cathode decoding:
    case input_char is
      --    A or    a -> A
      -- 0x41 or 0x61
      when x"41" or x"61" =>
        cathode_enc(6 downto 0) <= "0001000";
      --    B or    b -> b
      -- 0x42 or 0x62
      when x"42" or x"62" =>
        cathode_enc(6 downto 0) <= "0000011";
      --    C
      -- 0x43
      when x"43" =>
        cathode_enc(6 downto 0) <= "1000110";
      --    c
      -- 0x63
      when x"63" =>
        cathode_enc(6 downto 0) <= "0100111";
      --    D or    d -> d
      -- 0x44 or 0x64
      when x"44" or x"64" =>
        cathode_enc(6 downto 0) <= "0100001";

      -- Default or non-supported character appears blank
      when others =>
        cathode_enc(6 downto 0) <= (others => '1');
    end case;

    -- Return full cathode encoding
    return cathode_enc;
  end function

end seg7_display_driver_pkg;

