library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package bad_typewriter_pkg is
  -- Input character type - char concatenated with dp(MSB)
  subtype char_and_dp_input_t is std_logic_vector(8 downto 0);

  -- Character input buffer array type
  type char_buffer_t is array (7 downto 0) of char_and_dp_input_t;
end bad_typewriter_pkg;

