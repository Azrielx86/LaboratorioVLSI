library ieee;
use ieee.std_logic_1164.all;

entity conta is

port (
clk, reset: in std_logic;
SalMoore: out std_logic_vector (2 downto 0)
     );
end entity;

architecture a of conta is 

subtype state is std_logic_vector (2 downto 0);
signal present_state, next_state: state; --Declaraciòn de las señales
constant e0: state:="000"; --Define la constante e0 con valor de 000
constant e1: state:="001"; --Define la constante e1 con valor de 001
constant e2: state:="010"; --Define la constante e2 con valor de 010
constant e3: state:="011"; --Define la constante e3 con valor de 011
constant e4: state:="100"; --Define la constante e4 con valor de 100
constant e5: state:="101"; --Define la constante e5 con valor de 101
constant e6: state:="110"; --Define la constante e6 con valor de 110
constant e7: state:="111"; --Define la constante e7 con valor de 111

begin
process (clk)
begin
if rising_edge(clk) then 
   if (reset='0') then
	   present_state<=e0;
   else
      present_state<=next_state;
   end if;
end if;
end process;

process (present_state)
begin
case present_state is  --Asignaciones del proximo estado según el actual
when e0=> next_state<=e1; 
when e1=> next_state<=e2;
when e2=> next_state<=e3;
when e3=> next_state<=e4;
when e4=> next_state<=e5;
when e5=> next_state<=e6; 
when e6=> next_state<=e7;
when e7=> next_state<=e0;
when others=> next_state<=e0;
end case;
salMoore<=present_state;
end process;
end;
