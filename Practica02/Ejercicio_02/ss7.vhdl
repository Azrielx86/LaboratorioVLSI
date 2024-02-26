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
    "1000000" when "0001",
    "1111001" when "0010",
    "0100100" when "0011",
    "0110000" when "0100",
    "0011001" when "0101",
    "0010010" when "0110",
    "0000010" when "0111",
    "1111000" when "1000",
    "0011000" when "1001",
    "0000000" when others;
end architecture;