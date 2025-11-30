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

  -- anode buffer read to control input-char mux
  signal an_r : anode_select_t;

  -- debounced shift button buffer
  signal debounced_shift_r : std_logic;

  -- shift button buffer, to detect edges
  signal buff_shift_r : std_logic;

  -- shift rising edge proxy
  signal shift_re_r : std_logic;

  -- shift button debouncer
  component debouncer
    generic (debounce_period_clks : natural);
    port (
      clk           : in std_logic;
      resetn        : in std_logic;
      raw_in        : in std_logic;
      debounced_out : out std_logic
    );
  end component debouncer;

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
        if shift_re_r = '1' then
          -- shift buffer array to the left, throwing away MSB element
          char_buffer_r(7 downto 1) <= char_buffer_r(6 downto 0);
          char_buffer_r(0) <= (others => '0');
        else
          -- Update active digit in buffer array with input char/dp 
          char_buffer_r(0) <= dp & char;
        end if;
      end if;
    end if;
  end process char_buffer_ctrl;

  shift_edge_detect : process(clk)
  begin
    if rising_edge(clk) then
      if resetn = '0' then
        buff_shift_r <= '0';
        shift_re_r <= '0';
      else
        -- buffer previous shift state
        buff_shift_r <= debounced_shift_r;

        -- rising edge detect
        if (buff_shift_r = '0') and (debounced_shift_r = '1') then
          shift_re_r <= '1';
        else
          shift_re_r <= '0';
        end if;
      end if;
    end if;
  end process shift_edge_detect;

  shift_debouncer_inst : debouncer
    generic map (
      debounce_period_clks => 200000
    )
    port map (
      clk           => clk,
      resetn        => resetn,
      raw_in        => shift,
      debounced_out => debounced_shift_r
    );

  seg7_display_driver_inst : seg7_display_driver
    generic map(
      display_refresh_period_clks => nexys_a7_display_refresh_period_clks
    )
    port map (
      clk                => clk,
      resetn             => resetn,
      -- char buffer to display controller record
      display_in.digit_0 => raw_character_t(char_buffer_r(0)(7 downto 0)),
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
      an                 => an_r,
      cath               => cath
    );

    -- anode assignment from buffer instead of directly b/c
    -- VHDL '93 is actually a pos
    an <= an_r;
end rtl;

