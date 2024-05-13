library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vga is
port (
		clk: in std_logic;
		red: out std_logic_vector (3 downto 0);
		green: out std_logic_vector (3 downto 0);
		blue: out std_logic_vector (3 downto 0);
		h_sync: out std_logic;
		v_sync: out std_logic
		);
end entity;

architecture arqvga of vga is
signal clkl, disp_ena: std_logic;
signal clklsec: std_logic;
signal column, row: integer;
signal int: integer range 0 to 15;
signal ss7out: std_logic_vector(6 downto 0);
begin
	u1: entity work.divf(arqdivf) generic map (0) port map (clk, clkl);
	u2: entity work.divf(arqdivf) generic map (25000000) port map (clk, clklsec);
	u3: entity work.vga_core(arqcr) port map (clkl,disp_ena,h_sync,v_sync,column,row);
	u5: entity work.cont(arqcont) port map (clklsec,int);
	u6: entity work.ss7int(arqss7int) port map (int,ss7out);
	u7: entity work.imagen(arqim) port map (disp_ena,column,row,100,200,ss7out,red,green,blue);
end architecture;