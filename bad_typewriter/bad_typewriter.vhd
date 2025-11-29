library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.seg7_display_driver_pkg.all;
use work.bad_typewriter_pkg.all;

entity bad_typewriter is
  port (
    clk    : in std_logic;
    resetn : in std_logic;
    -- switch encoding of hex character
    char   : in raw_character_t;
    -- switch encoding of decimal point
    dp     : in std_logic;
    -- 'shift' character command
    shift  : in std_logic;
    -- Anode selection
    an     : out anode_select_t;
    -- cathode encoding drive
    cath   : out cathode_encoding_t
  );
end bad_typewriter;

architecture rtl of bad_typewriter is
  -- input character buffer, one index per display digit
  signal char_buffer_r : char_buffer_t;

  -- 7-segment display controller
  component seg7_display_driver
    generic (display_refresh_period_clks : natural);
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
  end component seg7_display_driver;
begin
  char_buffer_ctrl : process(clk)
  begin
    if rising_edge(clk) then
      if resetn = '0' then
        -- reset all digits to blank
        char_buffer_r <= (others => (others => '0'));
      else
        -- check for shift command
        if shift = '1' then
          -- shift buffer array to the left, throwing away MSB element
          char_buffer_r(7 downto 1) <= char_buffer_r(6 downto 0);
          char_buffer_r(0) <= (others => '0');
        else
          -- Update LSB in buffer array with currently desired char/dp 
          char_buffer_r(0) <= dp & char;
        end if;
      end if;
    end if;
  end process char_buffer_ctrl;

  seg7_display_driver_inst : seg7_display_driver
    generic map(
      display_refresh_period_clks => nexys_a7_display_refresh_period_clks
    )
    port map (
      clk                => clk,
      resetn             => resetn,
      -- char buffer to display controller record
      display_in.digit_0 => char_buffer_r(0)(7 downto 0),
      display_in.dp_0    => char_buffer_r(0)(8),
      display_in.digit_1 => char_buffer_r(1)(7 downto 0),
      display_in.dp_1    => char_buffer_r(1)(8),
      display_in.digit_2 => char_buffer_r(2)(7 downto 0),
      display_in.dp_2    => char_buffer_r(2)(8),
      display_in.digit_3 => char_buffer_r(3)(7 downto 0),
      display_in.dp_3    => char_buffer_r(3)(8),
      display_in.digit_4 => char_buffer_r(4)(7 downto 0),
      display_in.dp_4    => char_buffer_r(4)(8),
      display_in.digit_5 => char_buffer_r(5)(7 downto 0),
      display_in.dp_5    => char_buffer_r(5)(8),
      display_in.digit_6 => char_buffer_r(6)(7 downto 0),
      display_in.dp_6    => char_buffer_r(6)(8),
      display_in.digit_7 => char_buffer_r(7)(7 downto 0),
      display_in.dp_7    => char_buffer_r(7)(8),
      -- display outputs
      an                 => an,
      cath               => cath
    );
end rtl;

