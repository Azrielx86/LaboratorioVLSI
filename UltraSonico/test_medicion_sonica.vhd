-- FILEPATH: /home/kaguya/FIUnam/LabVLSI/UltraSonico/medicion_sonica_tb.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity medicion_sonica_tb is
end medicion_sonica_tb;

architecture testbench of medicion_sonica_tb is
  -- Component declaration
  component medicion_sonica is
    port (
      clk                : in std_logic;
      sensor_disp        : out std_logic; --señal de disparo
      sensor_eco         : in std_logic; --señal de eco
      segmentos_unidades : out unsigned(7 downto 0);
      segmentos_decenas  : out unsigned(7 downto 0);
      segmentos_centenas : out unsigned(7 downto 0);
      segmentos_cercania : out unsigned(7 downto 0);
      sal_binario        : out unsigned (9 downto 0)
    );
  end component;

  -- Signals
  signal clk_tb                : std_logic := '0';
  signal sensor_disp_tb        : std_logic;
  signal sensor_eco_tb         : std_logic;
  signal segmentos_unidades_tb : unsigned(7 downto 0);
  signal segmentos_decenas_tb  : unsigned(7 downto 0);
  signal segmentos_centenas_tb : unsigned(7 downto 0);
  signal segmentos_cercania_tb : unsigned(7 downto 0);
  signal sal_binario_tb        : unsigned(9 downto 0);

begin
  -- Instantiate the DUT
  UUT : medicion_sonica
    port map (
      clk                => clk_tb,
      sensor_disp        => sensor_disp_tb,
      sensor_eco         => sensor_eco_tb,
      segmentos_unidades => segmentos_unidades_tb,
      segmentos_decenas  => segmentos_decenas_tb,
      segmentos_centenas => segmentos_centenas_tb,
      segmentos_cercania => segmentos_cercania_tb,
      sal_binario        => sal_binario_tb
    );

  -- Clock process
  process
  begin
    while now < 500 ms loop
      clk_tb <= '0';
      wait for 20 ns;
      clk_tb <= '1';
      wait for 20 ns;
    end loop;
    wait;
  end process;

    -- Stimulus process
    process
    begin
      sensor_eco_tb <= '0';
      wait for 1 ms;
      sensor_eco_tb <= '1';
      wait for 2 ms;
  
      sensor_eco_tb <= '0';
      wait for 20 ms;
      sensor_eco_tb <= '1';
      wait for 2 ms;
  
      sensor_eco_tb <= '0';
  
      wait;
    end process;
  

end testbench;