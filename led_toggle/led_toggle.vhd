library ieee;
use ieee.std_logic_1164.all;

entity led_toggle is
port (
  -- switch enable, no debounce since this is just a simple example
  en  : in  std_logic;
  -- output to drive led
  led : out std_logic
);
end led_toggle;

architecture rtl of led_toggle is
begin
  led <= en;
end rtl;


