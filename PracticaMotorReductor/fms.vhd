library IEEE;
use IEEE.std_logic_1164.all;
entity fsm is
port (
		clks : in std_logic;
		rst : in std_logic;
		paso : in std_logic;
		dire : in std_logic;
		modo : in std_logic_Vector (1 downto 0);
		MOT : out std_logic_vector (3 downto 0);
		led : out std_logic_vector (3 downto 0));
end fsm;

architecture behavioral of fsm is
subtype estados is std_logic_vector (3 downto 0);
constant s0: estados:="0000";
constant s1: estados:="0001";
constant s2: estados:="0010";
constant s3: estados:="0011";
constant s4: estados:="0100";
constant s5: estados:="0101";
constant s6: estados:="0110";
constant s7: estados:="0111";
constant s8: estados:="1000";
constant s9: estados:="1001";
constant s10: estados:="1010";
signal estado_actual,estado_siguiente: estados;
signal motor : std_logic_vector(3 downto 0);

begin
-- Transición de Estados
	process (clks,rst) begin
		if rst='0' then
			estado_actual <= s0;
		elsif clks'event and clks='1' and paso = '0' then
			estado_actual <= estado_siguiente;
		end if;
	end process;
--Máquina de Estados
	process (estado_actual,dire,rst,modo) begin
		case(estado_actual) is
			when s0 =>
				estado_siguiente <= s1;
			when s1 =>
				if modo="00" then ---motor bipolar
					if dire='0' then
						estado_siguiente <= s3;
					else
						estado_siguiente <= s7;
					end if;
				elsif modo="01" then
					if dire='0' then
						estado_siguiente <= s2;
					else
						estado_siguiente <= s8;
					end if;
				elsif modo="10" then
					if dire='0' then
						estado_siguiente <= s2;
					else
						estado_siguiente <= s8;
				end if;
			elsif modo="11" then
				if dire='0' then
					estado_siguiente <= s9;
				else
					estado_siguiente <= s4;
				end if;
			else
				estado_siguiente <= s1;
			end if;
				when s2 =>
					if modo="00" then
						if dire='0' then
							estado_siguiente <= s1;
						else
							estado_siguiente <= s7;
						end if;
					elsif modo="01" then
						if dire='0' then
							estado_siguiente <= s4;
						else
							estado_siguiente <= s8;
						end if;
					elsif modo="10" then
						if dire='0' then
							estado_siguiente <= s3;
						else
							estado_siguiente <= s1;
						end if;
					elsif modo="11" then
						if dire='0' then
							estado_siguiente <= s9;
						else
							estado_siguiente <= s4;
						end if;
					else
						estado_siguiente <= s2;
					end if;
				when s3 =>
					if modo="00" then
						if dire='0' then
							estado_siguiente <= s5;
						else
							estado_siguiente <= s1;
						end if;
					elsif modo="01" then
						if dire='0' then
							estado_siguiente <= s2;
else
estado_siguiente <= s8;
end if;
elsif modo="10" then
if dire='0' then
estado_siguiente <= s4;
else
estado_siguiente <= s2;
end if;
elsif modo="11" then
if dire='0' then
estado_siguiente <= s9;
else
estado_siguiente <= s4;
end if;
else
estado_siguiente <= s3;
end if;
When s4 => -- Estado 4
if modo="00" then
if dire='0' then
estado_siguiente <= s1;
else
estado_siguiente <= s7;
end if;
elsif modo="01" then
if dire='0' then
estado_siguiente <= s6;
else
estado_siguiente <= s2;
end if;
elsif modo="10" then
if dire='0' then
estado_siguiente <= s5;
else
estado_siguiente <= s3;
end if;
elsif modo="11" then
if dire='0' then
estado_siguiente <= s9;
else
estado_siguiente <= s10;
end if;
else
estado_siguiente <= s4;
end if;
when s5 => -- Estado 5
if modo="00" then
if dire='0' then
estado_siguiente <= s7;
else
estado_siguiente <= s3;
end if;
elsif modo="01" then
if dire='0' then
estado_siguiente <= s2;
else
estado_siguiente <= s8;
end if;
elsif modo="10" then
if dire='0' then
estado_siguiente <= s6;
else
estado_siguiente <= s4;
end if;
elsif modo="11" then
if dire='0' then
estado_siguiente <= s9;
else
estado_siguiente <= s4;
end if;
else
estado_siguiente <= s3;
end if;
when s6 =>
if modo="00" then
if dire='0' then
estado_siguiente <= s1;
else
estado_siguiente <= s7;
end if;
elsif modo="01" then
if dire='0' then
estado_siguiente <= s8;
else
estado_siguiente <= s4;
end if;
elsif modo="10" then
if dire='0' then
estado_siguiente <= s7;
else
estado_siguiente <= s5;
end if;
elsif modo="11" then
if dire='0' then
estado_siguiente <= s9;
else
estado_siguiente <= s4;
end if;
else
estado_siguiente <= s7;
end if;
when s7 =>
if modo="00" then
if dire='0' then
estado_siguiente <= s1;
else
estado_siguiente <= s5;
end if;
elsif modo="01" then
if dire='0' then
estado_siguiente <= s2;
else
estado_siguiente <= s8;
end if;
elsif modo="10" then
if dire='0' then
estado_siguiente <= s8;
else
estado_siguiente <= s6;
end if;
elsif modo="11" then
if dire='0' then
estado_siguiente <= s9;
else
estado_siguiente <= s4;
end if;
else
estado_siguiente <= s7; 
end if;
when s8 =>
if modo="00" then
if dire='0' then
estado_siguiente <= s1;
else
estado_siguiente <= s7;
end if;
elsif modo="01" then
if dire='0' then
estado_siguiente <= s2;
else
estado_siguiente <= s6;
end if;
elsif modo="10" then
if dire='0' then
estado_siguiente <= s1;
else
estado_siguiente <= s7;
end if;
elsif modo="11" then
if dire='0' then
estado_siguiente <= s10;
else
estado_siguiente <= s9;
end if;
else
estado_siguiente <= s8;
end if;
when s9=>
if modo="00" then
if dire='0' then
estado_siguiente <= s1;
else
estado_siguiente <= s7;
end if;
elsif modo="01" then
if dire='0' then
estado_siguiente <= s2;
else
estado_siguiente <= s8;
end if;
elsif modo="10" then
if dire='0' then
estado_siguiente <= s1;
else
estado_siguiente <= s8;
end if;
elsif modo="11" then
if dire='0' then
estado_siguiente <= s8;
else
estado_siguiente <= s4;
end if;
else
estado_siguiente <= s9;
end if;
when s10 =>
if modo="00" then
if dire='0' then
estado_siguiente <= s1;
else
estado_siguiente <= s7;
end if;
elsif modo="01" then
if dire='0' then
estado_siguiente <= s2;
else
estado_siguiente <= s8;
end if;
elsif modo="10" then
if dire='0' then
estado_siguiente <= s1;
else
estado_siguiente <= s8;
end if;
elsif modo="11" then
if dire='0' then
estado_siguiente <= s4;
else
estado_siguiente <= s8;
end if;
else
estado_siguiente <= s10;
end if;
when others => estado_siguiente <= s0;
end case;
end process;
process(estado_actual) begin
case estado_actual is
when s0 => motor <= "0000";
when s1 => motor <= "1000";
when s2 => motor <= "1100";
when s3 => motor <= "0100";
when s4 => motor <= "0110";
when s5 => motor <= "0010";
when s6 => motor <= "0011";
when s7 => motor <= "0001";
when s8 => motor <= "1001";
when s9 => motor <= "1010";
when s10 => motor <= "0101";
when others => motor <= "0000";
end case;
end process;
MOT<=motor;
led <=motor;
end behavioral;