library ieee;
use ieee.std_logic_1164.all;

entity corri is 
port (
clk, reset: in std_logic;  --Entrada del Reloj y el Reset
hex0, hex1, hex2, hex3, hex4: out std_logic_vector(6 downto 0)); --Salidas de los vectores lógicos
end;

architecture a of corri is
signal clkl:std_logic;
signal bcd: std_logic_vector (2 downto 0); 
begin
u1: entity work.relojlento(a) port map (clk,clkl);  --Instancia de  relojlento
u2: entity work.conta(a) port map (clkl,reset, bcd); --Instancia de conta
u3: entity work.ss7(a) port map ('0' & bcd, hex0); --Instancia de ss7, hex0
u4: entity work.ss7(a) port map ('0'& bcd, hex1); --Instancia de ss7, hex1
u5: entity work.ss7(a) port map ('0'& bcd, hex2); --Instancia de ss7, hex2
u6: entity work.ss7(a) port map ('0'& bcd, hex3); --Instancia de ss7, hex3
u7: entity work.ss7(a) port map ('0'& bcd, hex4); --Instancia de ss7, hex4
end;
