library ieee;
use ieee.std_logic_1164.all;

entity int2bcd is
port
	(
	a : out integer range 0 to 15;
	b : in std_logic_vector(3 downto 0)
	);
end entity;

architecture int2bcd of int2bcd is
begin
	with a select
	b <=	"0000" when 0,
			"0001" when 1,
  			"0010" when 2,
  			"0011" when 3,
  			"0100" when 4,
  			"0101" when 5,
  			"0110" when 6,
  			"0111" when 7,
  			"1000" when 8,
  			"1001" when 9,
  			"1010" when 10,
  			"1011" when 11,
  			"1100" when 12,
  			"1101" when 13,
  			"1110" when 14,
  			"1111" when 15,
  			"0000" when others;
end architecture;