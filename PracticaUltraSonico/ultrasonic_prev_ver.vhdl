library ieee;
use ieee.std_logic_1164.all;

entity ultrasonic is
  port (
    clk      : in std_logic;
    reset    : in std_logic;
    echo     : in std_logic;
    trigger  : out std_logic;
    result : out std_logic_vector(15 downto 0); -- Resultado 
    estado   : out std_logic_vector(2 downto 0) -- debug??? :v
  );
end entity ultrasonic;

architecture archultrasonic of ultrasonic is
  type SonicState is (disparo, espera, mide, reset_data);
  signal PS, NS                    : SonicState;
  signal count_echo, count_trigger : integer := 0;
  signal count: integer := 0;
  signal binary            : std_logic_vector(15 downto 0) := (others => '0');
  signal eco_pasado       : std_logic             := '0';
  signal eco_sinc         : std_logic             := '0';
  signal eco_nsinc        : std_logic             := '0';

begin
  sm_control : process (clk, reset)
  begin
    if reset = '0' then
      PS <= disparo;
    elsif rising_edge(clk) then
      PS <= NS;
    end if;
  end process;

  sm_logic : process (PS, echo, count_echo, count_trigger, binary)
  begin
    case PS is
      when disparo =>
        if count_trigger = 500 then -- Disparo de 10us
          count_trigger <= 0;
          NS            <= espera;
        else
          count_trigger <= count_trigger + 1;
          NS            <= disparo;
        end if;
        trigger        <= '1';
        count_echo     <= 0;
        binary         <= (others => '0');
        estado         <= "001";


      when espera =>
        if eco_pasado = '0' and eco_sinc = '1' then
          NS <= reset_data;
        elsif eco_pasado = '1' and eco_sinc = '0' then
          binary <= (count_echo / 50_000_000) * 34000 / 2;
        else
          NS <= espera;
        end if;

        -- if echo = '1' then
        --   count_echo <= count_echo + 1;
        -- elsif echo = '0' then
        --   count_echo <= 0;
        --   NS         <= disparo;
        -- elsif count_echo = 10000000 then -- Lectura cada 200ms
        --   NS         <= disparo;
        --   count_echo <= 0;
        -- end if;
        NS            <= espera;
        trigger       <= '0';
        count_trigger <= 0;
        estado        <= "010";


      when reset_data => 
        
        
      when mide =>
        
      when others =>
        trigger        <= '0';
        count_trigger  <= 0;
        count_echo     <= 0;
        binary <= 0;
        estado         <= "000";
    end case;

    result <= binary;
    eco_pasado <= eco_sinc;
    eco_sinc <= echo_nsinc;
    eco_nsinc <= echo;
  end process;
end architecture;