library ieee;
use ieee.std_logic_1164.all;

entity movimiento is
  port (
    clk, pi, pf, inc : in std_logic;
    reset            : in std_logic;
    ancho            : out integer
  );
end entity;

architecture arqmov of movimiento is
  signal valor : integer range 0 to 200;
begin
  process ()
  begin
    if reset = '1' then
      valor <= 75;
    elsif pi = '1' then
      valor <= 55;
    elsif pf = '1' then
      
    end if;
  end process;
end architecture;