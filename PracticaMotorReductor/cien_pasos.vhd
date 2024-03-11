library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity cien_pasos is
port (
		clk : in STD_LOGIC; --Reloj Tarjeta
		rst : in STD_LOGIC; --botonReset
		FH : in STD_LOGIC_VECTOR(1 downto 0); --Switch12
		led : out STD_LOGIC_VECTOR(3 downto 0);
		MOT : out STD_LOGIC_VECTOR(3 downto 0)
 );
end cien_pasos;

architecture behavioral of cien_pasos is
signal div : std_logic_vector(25 downto 0);
signal clkfsm : std_logic;
signal clkp : std_logic;
signal paso : std_logic := '1';
signal UD : std_logic := '1';
signal cont : integer := 0;

begin
-- Divisor de Frecuencia
	process (Clk,rst) begin
		if rst='0' then
			div <= (others=>'0');
		elsif Clk'event and Clk='1' then
			div <= div + 1;
		end if;
	end process;
	clkfsm <= div(18);-- 100 Hz (100 pasos cada segundo)
	divisor6 : entity work.Divisor6 generic map (25) port map(clk,clkp);--reloj que va a 1 seg
	process (clkp)
	begin
		if clkp = '1' then
			if cont = 0 then
				paso <= '0';
				cont<=cont+1;
			elsif cont = 1 then
				paso <= '1';
				cont<=cont+1;
			elsif (cont < 16) then
				ud <= '0';
				paso <= '0';
				cont<=cont+1;
			elsif cont = 16 then
				paso <= '1';
				cont<=cont+1;
			elsif cont = 17 then
				ud <= '1';
				paso <= '0';
				cont<=cont+1;
			else
				cont <= 0;
				ud <= '1';
			end if;
		end if;
	end process;
	fsm: entity work.fsm port map(clkfsm,rst,paso,UD,FH,MOT,led);
end behavioral;