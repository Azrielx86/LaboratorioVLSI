library ieee;
use ieee.std_logic_1164.all;

entity imagen is
port (
		display_ena: in std_logic;
		column: in integer range 0 to 640;
		row: in integer range 0 to 640;
		h_offset: in integer range 0 to 640;
		v_offset: in integer range 0 to 640;
		ss7: in std_logic_vector(6 downto 0);
		red, green, blue: out std_logic_vector (3 downto 0)
		);
end entity;

architecture arqim of imagen is
begin
	process(display_ena, row, column, h_offset, v_offset, ss7)
		begin
			if(display_ena='1') then
				if(((row>v_offset)and(row<v_offset+10))and((column>h_offset+10)and(column<h_offset+40))and(ss7(0)='0')) then -- 0. Azul
					red<= (others => '0');
					green<= (others => '0');
					blue<= (others => '1');
				elsif(((row>v_offset+10)and(row<v_offset+40))and((column>h_offset+40)and(column<h_offset+50))and(ss7(1)='0')) then -- 1. Verde
					red<= (others => '0');
					green<= (others => '1');
					blue<= (others => '0');
				elsif(((row>v_offset+50)and(row<v_offset+80))and((column>h_offset+40)and(column<h_offset+50))and(ss7(2)='0')) then -- 2. Rojo
					red<= (others => '1');
					green<= (others => '0');
					blue<= (others => '0');
				elsif(((row>v_offset+80)and(row<v_offset+90))and((column>h_offset+10)and(column<h_offset+40))and(ss7(3)='0')) then -- 3. Blanco
					red<= (others => '1');
					green<= (others => '1');
					blue<= (others => '1');
				elsif(((row>v_offset+50)and(row<v_offset+80))and((column>h_offset)and(column<h_offset+10))and(ss7(4)='0')) then -- 4. Cian
					red<= (others => '0');
					green<= (others => '1');
					blue<= (others => '1');
				elsif(((row>v_offset+10)and(row<v_offset+40))and((column>h_offset)and(column<h_offset+10))and(ss7(5)='0')) then -- 5. Amarillo
					red<= (others => '1');
					green<= (others => '1');
					blue<= (others => '0');
				elsif(((row>v_offset+40)and(row<v_offset+50))and((column>h_offset+10)and(column<h_offset+40))and(ss7(6)='0')) then -- 6. Violeta
					red<= (others => '1');
					green<= (others => '0');
					blue<= (others => '1');
				else
					red<= (others => '0');
					green<= (others => '0');
					blue<= (others => '0');
				end if;
			else
				red<= (others => '0');
				green<= (others => '0');
				blue<= (others => '0');
			end if;
	end process;
end architecture;