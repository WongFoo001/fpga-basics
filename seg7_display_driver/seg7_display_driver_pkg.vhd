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
      -- 0
      when x"30" =>
        cathode_enc(6 downto 0) <= "1000000";
      -- 1
      when x"31" =>
        cathode_enc(6 downto 0) <= "1111001";
      -- 2
      when x"32" =>
        cathode_enc(6 downto 0) <= "0100100";
      -- 3
      when x"33" =>
        cathode_enc(6 downto 0) <= "0110000";
      -- 4
      when x"34" =>
        cathode_enc(6 downto 0) <= "0011001";
      -- 5
      when x"35" =>
        cathode_enc(6 downto 0) <= "0010010";
      -- 6
      when x"36" =>
        cathode_enc(6 downto 0) <= "0000010";
      -- 7 
      when x"37" =>
        cathode_enc(6 downto 0) <= "1011000";
      -- 8 
      when x"38" =>
        cathode_enc(6 downto 0) <= "00000000";
      -- 9 
      when x"39" =>
        cathode_enc(6 downto 0) <= "0010000";
      -- A or a -> A
      when x"41" or x"61" =>
        cathode_enc(6 downto 0) <= "0001000";
      -- B or b -> b
      when x"42" or x"62" =>
        cathode_enc(6 downto 0) <= "0000011";
      -- C
      when x"43" =>
        cathode_enc(6 downto 0) <= "1000110";
      -- c
      when x"63" =>
        cathode_enc(6 downto 0) <= "0100111";
      -- D or d -> d
      when x"44" or x"64" =>
        cathode_enc(6 downto 0) <= "0100001";
      -- E or e -> E
      when x"45" or x"65" =>
        cathode_enc(6 downto 0) <= "0000110";
      -- F or f -> F
      when x"46" or x"66" =>
        cathode_enc(6 downto 0) <= "0001110";
      -- G or g -> G
      when x"47" or x"67" =>
        cathode_enc(6 downto 0) <= "1000010";
      -- H
      when x"48" =>
        cathode_enc(6 downto 0) <= "0001001";
      -- h
      when x"68" =>
        cathode_enc(6 downto 0) <= "0001011";
      -- I or i -> I
      when x"49" or x"69" =>
        cathode_enc(6 downto 0) <= "1111001";
      -- J or j -> J
      when x"4A" or x"6A" =>
        cathode_enc(6 downto 0) <= "1100001";
      -- K or k -> K
      when x"4B" or x"6B" =>
        cathode_enc(6 downto 0) <= "0000101";
      -- L or l -> L
      when x"4C" or x"6C" =>
        cathode_enc(6 downto 0) <= "1000111";
      -- M or m -> m
      when x"4D" or x"6D" =>
        cathode_enc(6 downto 0) <= "1101010";
      -- N or n -> n
      when x"4E" or x"6E" =>
        cathode_enc(6 downto 0) <= "0101011";
      -- O or o -> o
      when x"4F" or x"6F" =>
        cathode_enc(6 downto 0) <= "0100011";
      -- P or p -> P 
      when x"50" or x"70" =>
        cathode_enc(6 downto 0) <= "0001100";
      -- Q or q -> q
      when x"51" or x"71" =>
        cathode_enc(6 downto 0) <= "0011000";
      -- R or r -> r
      when x"52" or x"72" =>
        cathode_enc(6 downto 0) <= "0101111";
      -- S or s -> S
      when x"53" or x"73" =>
        cathode_enc(6 downto 0) <= "0010010";
      -- T or t -> t
      when x"54" or x"74" =>
        cathode_enc(6 downto 0) <= "0000111";
      -- U or u -> u
      when x"55" or x"75" =>
        cathode_enc(6 downto 0) <= "1100011";
      -- V or v -> v
      when x"56" or x"76" =>
        cathode_enc(6 downto 0) <= "1000001";
      -- W or w -> W
      when x"57" or x"77" =>
        cathode_enc(6 downto 0) <= "0010101";
      -- X or x -> X
      when x"58" or x"78" =>
        cathode_enc(6 downto 0) <= "0101010";
      -- Y or y -> y
      when x"59" or x"79" =>
        cathode_enc(6 downto 0) <= "0010001";
      -- Z or z -> Z
      when x"5A" or x"7A" =>
        cathode_enc(6 downto 0) <= "0100100";
      -- Non-supported character appears blank
      when others =>
        cathode_enc(6 downto 0) <= (others => '1');
    end case;

    -- Return full cathode encoding
    return cathode_enc;
  end function

end seg7_display_driver_pkg;

