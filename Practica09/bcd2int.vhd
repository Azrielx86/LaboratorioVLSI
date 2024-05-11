library ieee;
use ieee.std_logic_1164.all;

entity bcd2int is
port
	(
	a : in std_logic_vector(3 downto 0);
	b : out integer range 0 to 15
	);
end entity;

architecture arqbcd2int of bcd2int is
begin
	with a select
	b <=	0 when "0000",
			1 when "0001",
  			2 when "0010",
  			3 when "0011",
  			4 when "0100",
  			5 when "0101",
  			6 when "0110",
  			7 when "0111",
  			8 when "1000",
  			9 when "1001",
  			10 when "1010",
  			11 when "1011",
  			12 when "1100",
  			13 when "1101",
  			14 when "1110",
  			15 when "1111",
  			16 when others;
end architecture;