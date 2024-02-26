library ieee;
use ieee.std_logic_1164.all;

entity conta3display is
port(
	clk: in std_logic; --Tomará el reloj de la tarjeta como entrada.
	ssg0: out std_logic_vector(6 downto 0);
	ssg1: out std_logic_vector(6 downto 0);
	ssg2: out std_logic_vector(6 downto 0); --Salida para el tercer display.
	banderaSal: out std_logic --Guarda la salida de cont pero no se utiliza.
	);
end entity;

architecture arqconta3display of conta3display is
signal bandera: std_logic; --Bandera para el tercer display.
signal conteo: integer range 0 to 9; --Conteo del tercer display.
begin
	u7: entity work.conta2display(arqconta2display) port map(clk, ssg0, ssg1, bandera); --Se repite el proceso de
  -- conta2display. Le damos el reloj de la tarjeta como entrada y tomamos sus salidas para los displays y la nuestra señal bandera.
	u8: entity work.cont2(arqcont2) port map(bandera, conteo, banderaSal); --Repetimos el proceso de cont para nuestro tercer display.
	u9: entity work.ss7(arqss7) port map(conteo, ssg2); --Convertimos la señal conteo para nuestro tercer display.
end architecture;