library ieee;
use ieee.std_logic_1164.all;

entity ss7 is
  port (
    bcd : in std_logic_vector(3 downto 0);
    hex : out std_logic_vector(6 downto 0)
  );
end entity;

architecture arqss7 of ss7 is
begin
  with bcd select
    hex <= "1000000" when "0000",
    "0001001" when "0001",
    "1000000" when "0010",
    "1000111" when "0011",
    "0001000" when "0100",
    "0001100" when "0101",
    "0101111" when "0110",
    "1000000" when "0111",
    "0001110" when "1000",
    "1010000" when "1001",
    "1000000" when others;
end architecture;