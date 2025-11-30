library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.general_utilities_pkg.all;

entity debouncer is
  generic (
    -- defaults to 20ms assuming 100 Mhz clk
    debounce_period_clks : natural := 200000
  );
  port (
    clk           : in std_logic;
    resetn        : in std_logic;
    raw_in        : in std_logic;
    debounced_out : out std_logic
  );
end debouncer;

architecture rtl of debouncer is
  -- Debouce delay counter
  signal debounce_count_r : unsigned(bitwidth(debounce_period_clks) downto 0);
  -- buffered output - used to track current state
  signal buff_out_r       : std_logic;
begin
  debounce_counter_proc : process(clk)
  begin
    if rising_edge(clk) then
      if resetn = '0' then
        debounce_count_r <= (others => '0');
        buff_out_r       <= '0';
      else
        -- if raw input differs from current buffered output:
        -- 2. If currently counting, decrement counter
        if (raw_in /= buff_out_r) then
          -- 1. Check for debounce period elapse - propagate input 
          if debounce_count_r = debounce_period_clks then
            buff_out_r <= raw_in;
            debounce_count_r <= (others => '0');
          -- 2. Increment debounce counter
          else
            debounce_count_r <= debounce_count_r + 1;
          end if;
        -- raw input matches output - reset counter
        else
          debounce_count_r <= (others => '0');
        end if;
      end if;
    end if;
  end process debounce_counter_proc;

  -- output assignment
  debounced_out <= buff_out_r;
end rtl;

