package general_utilities_pkg is
  -- ceiling(log2(input)) , with clog2(0) = 0
  function clog2(i : natural) return natural;
  -- bit width needed to store a value, minimum width is 1
  function bitwidth(i : natural) return natural;
end package;

package body general_utilities_pkg is
  function clog2(i : natural) return natural is
    variable temp : integer := i - 1;
    variable ret  : natural := 0;
  begin
    if i <= 1 then
      return 0;
    end if;

    while temp > 0 loop
      ret  := ret + 1;
      temp := temp / 2;
    end loop;

    return ret;
  end function;

  function bitwidth(i : natural) return natural is
  begin
    return natural'max(1, clog2(i + 1));
  end function;
end package body;

