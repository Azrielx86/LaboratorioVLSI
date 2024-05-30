library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity baud_generator is
  generic (
    baud_rate : in integer := 328
  );
  port (
    clk   : in std_logic;
    reset : in std_logic;
    tick  : out std_logic
  );
end entity baud_generator;

architecture rtl of baud_generator is
  signal count : integer := 0;
begin
  process (clk, reset)
  begin
    if reset = '0' then
      count <= 0;
    elsif rising_edge(clk) then
      if count = baud_rate then
        count <= 0;
        tick  <= '1';
      else
        count <= count + 1;
        tick  <= '0';
      end if;
    end if;
  end process;
end architecture;