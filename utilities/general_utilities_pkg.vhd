package general_utilities_pkg is
  function clog2(i : natural) return natural;
  function bitwidth(i : natural) return natural;
end package;

package body general_utilities_pkg is
  -- Returns clog2(i), with clog2(0) defined as 0
  function clog2(i : natural) return natural is
    variable temp : integer := i - 1;
    variable ret  : natural := 0;
  begin
    if i <= 1 then
      return 0;  -- definition: clog2(0)=0, clog2(1)=0
    end if;

    while temp > 0 loop
      ret  := ret + 1;
      temp := temp / 2;
    end loop;

    return ret;
  end function;

  -- Width is nominally clog2(i+1), with a minimum return value of 1
  function bitwidth(i : natural) return natural is
  begin
    return natural'max(1, clog2(i + 1));
  end function;
end package body;

