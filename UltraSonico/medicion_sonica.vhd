library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity medicion_sonica is
  port (
    clk                : in std_logic;
    sensor_disp        : out std_logic; --señal de disparo
    sensor_eco         : in std_logic; --señal de eco
    segmentos_unidades : out unsigned(7 downto 0);
    segmentos_decenas  : out unsigned(7 downto 0);
    segmentos_centenas : out unsigned(7 downto 0);
    segmentos_cercania : out unsigned(7 downto 0);
    sal_binario        : out unsigned (9 downto 0));
end medicion_sonica;

architecture arqmedicion_sonica of medicion_sonica is
  signal digito_cerca : unsigned(1 downto 0) := (others => '0');
  signal digito_cent  : unsigned(7 downto 0) := (others => '0');
  signal digito_dece  : unsigned(7 downto 0) := (others => '0');
  signal digito_uni   : unsigned(7 downto 0) := (others => '0');
  signal binary       : unsigned(9 downto 0) := (others => '0');

  component control_sonico is
    port (
      clk                : in std_logic;
      sensor_disp        : out std_logic; --señal de disparo
      sensor_eco         : in std_logic; --señal de eco
      segmentos_unidades : out unsigned(7 downto 0);
      segmentos_decenas  : out unsigned(7 downto 0);
      segmentos_centenas : out unsigned(7 downto 0);
      sal_binario        : out unsigned (9 downto 0)
    );
  end component;

begin
  U1 : control_sonico port map
    (clk, sensor_disp, sensor_eco, segmentos_unidades, segmentos_decenas, segmentos_centenas, binary);
  process (binary)
    --convertir binario a entero
    variable int_binary : integer := 0;
  begin
    int_binary := to_integer(binary);
    --comparar con 30
    if int_binary > 30 then
      digito_cerca <= "00";
    elsif int_binary < 30 then
      digito_cerca <= "01";
    elsif int_binary = 30 then
      digito_cerca <= "10";
    else
      digito_cerca <= "11";
      --si si mandar los valores del codificador L C 0
    end if;
  end process;

  -- Multiplexado de salida
  with digito_cerca select
    segmentos_cercania <= "11000111" when "00",
    "11000110" when "01",
    "11000000" when "10",
    "11111111" when others;
end arqmedicion_sonica;