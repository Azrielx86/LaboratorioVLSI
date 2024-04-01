library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity control_sonico is
  port (
    clk                : in std_logic;
    sensor_disp        : out std_logic; --señal de disparo
    sensor_eco         : in std_logic; --señal de eco
    segmentos_unidades : out unsigned(7 downto 0);
    segmentos_decenas  : out unsigned(7 downto 0);
    segmentos_centenas : out unsigned(7 downto 0);
    sal_binario        : out unsigned (9 downto 0));
end control_sonico;

architecture arqcontrol_sonico of control_sonico is
  signal cuenta           : unsigned(16 downto 0) := (others => '0');
  signal binario          : unsigned(9 downto 0)  := (others => '0');
  signal centimetros      : unsigned(15 downto 0) := (others => '0');
  signal centimetros_unid : unsigned(3 downto 0)  := (others => '0');
  signal centimetros_dece : unsigned(3 downto 0)  := (others => '0');
  signal centimetros_cent : unsigned(3 downto 0)  := (others => '0');
  signal eco_pasado       : std_logic             := '0';
  signal eco_sinc         : std_logic             := '0';
  signal eco_nsinc        : std_logic             := '0';
  signal espera           : std_logic             := '0';
  signal sal_unid         : unsigned(3 downto 0)  := (others => '0');
  signal sal_dece         : unsigned(3 downto 0)  := (others => '0');
  signal sal_cent         : unsigned(3 downto 0)  := (others => '0');

begin
  Trigger : process (clk)
  begin
    if rising_edge(clk) then
      if espera = '0' then
        if cuenta = 500 then --para el puso de 10 microsegundos
          sensor_disp <= '0';
          espera      <= '1';
          cuenta      <= (others => '0');
        else
          sensor_disp <= '1';
          cuenta      <= cuenta + 1;
        end if;
      elsif eco_pasado = '0' and eco_sinc = '1' then --Pone en cero todaslas unidades
        --Si en un tiempo pasado vale cero y ahora vale 1 hay un cambio en el sensor en el eco de subida
        cuenta           <= (others => '0');
        centimetros      <= (others => '0');
        centimetros_unid <= (others => '0');
        centimetros_dece <= (others => '0');
        centimetros_cent <= (others => '0');
        binario          <= (others => '0');
      elsif eco_pasado = '1' and eco_sinc = '0' then
        --Ahora detecta el flanco de bajada
        sal_unid    <= centimetros_unid; --Manda al display la medicionde unidades
        sal_dece    <= centimetros_dece; --manda al display la medicionde decenas
        sal_cent    <= centimetros_cent; --manda al display la medicion de centenas
        sal_binario <= binario;
      elsif cuenta = 2900 - 1 then
        --Contamos centimetros en BCD
        if centimetros_unid = 9 then
          centimetros_unid <= (others => '0');
          centimetros_dece <= centimetros_dece + 1;
        elsif centimetros_dece = 9 then
          centimetros_dece <= (others => '0');
          centimetros_cent <= centimetros_cent + 1;
        else
          centimetros_unid <= centimetros_unid + 1;
        end if;
        binario     <= binario + 1;
        centimetros <= centimetros + 1;
        cuenta      <= (others => '0');
        if centimetros = 3448 then --cada 200ms hace una lectura
          espera <= '0';
        end if;
      else
        cuenta <= cuenta + 1;
      end if;
      --Hay un retardo en el tiempo, la señal llega desfasada de un ciclo de reloj
      --Existe una historia de la señal
      eco_pasado <= eco_sinc;
      eco_sinc   <= eco_nsinc;
      eco_nsinc  <= sensor_eco;
    end if;
  end process;

  -- Multiplexado de salida
  with sal_unid select
    segmentos_unidades <= "11000000" when "0000", -- 0
    "11111001" when "0001", -- 1
    "10100100" when "0010", -- 2
    "10110000" when "0011", -- 3
    "10011001" when "0100", -- 4
    "10010010" when "0101", -- 5
    "10000010" when "0110", -- 6
    "11111000" when "0111", -- 7
    "10000000" when "1000", -- 8
    "10010000" when "1001", -- 9
    "11000000" when others; -- 0
  with sal_dece select
    segmentos_decenas <= "11000000" when "0000", -- 0
    "11111001" when "0001", -- 1
    "10100100" when "0010", -- 2
    "10110000" when "0011", -- 3
    "10011001" when "0100", -- 4
    "10010010" when "0101", -- 5
    "10000010" when "0110", -- 6
    "11111000" when "0111", -- 7
    "10000000" when "1000", -- 8
    "10010000" when "1001", -- 9
    "11000000" when others; -- 0
  with sal_cent select
    segmentos_centenas <= "11000000" when "0000", -- 0
    "11111001" when "0001", -- 1
    "10100100" when "0010", -- 2
    "10110000" when "0011", -- 3
    "10011001" when "0100", -- 4
    "10010010" when "0101", -- 5
    "10000010" when "0110", -- 6
    "11111000" when "0111", -- 7
    "10000000" when "1000", -- 8
    "10010000" when "1001", -- 9
    "11000000" when others; -- 0
end arqcontrol_sonico;