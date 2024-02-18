library ieee;
use ieee.std_logic_1164.all;

entity cont is
  generic (
    max_count : integer := 9
  );
  port (
    clk     : in std_logic;
    counter : buffer integer;
    -- Se agrega una entrada para reiniciar el contador
    reset   : in std_logic;
    carry   : out std_logic := '0'
  );
end entity;

architecture arqcont of cont is
  signal flag : std_logic := '1';
begin
  -- Se toma en cuenta esta entrada en la lista se sensibilidad del process
  process (clk, reset)
  begin
    -- Se comprueba primero si el reset está activo, de ser el caso,
    -- el contador se reinicia
    if reset = '1' then
      counter <= 0;
    elsif rising_edge(clk) then
      if (counter = max_count) then
        counter <= 0;
        flag    <= '1';
      else
        counter <= counter + 1;
        flag    <= '0';
      end if;
    end if;
  end process;
  carry <= flag;
end architecture;