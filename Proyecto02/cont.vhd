library ieee;
use ieee.std_logic_1164.all;

entity cont is
port
	(
	clk: in std_logic; --Recibe un reloj como entrada.
	conteo: buffer integer --Regresa un numero entero como salida.
	);
end entity;

architecture arqcont of cont is
begin
	process (clk)
		begin
			if (rising_edge(clk)) then --En el flanco de subida del reloj se prosigue a la condicional siguiente.
				if (conteo = 15) then --Cuando conteo llegue a 9, se regresa a 0.
					conteo <= 0;
				else
					conteo <= conteo + 1; --Si conteo no es igual a 9, se le suma un 1.
				end if;
			end if;
	end process;
end architecture;