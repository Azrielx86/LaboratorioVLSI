library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
  port (
    clk   : in std_logic;
    reset : in std_logic;
    -- Parte sensor
    echo    : in std_logic;
    trigger : out std_logic;
    -- Parte motor
    enable_in             : in std_logic;
    pwm, npwm, enable_out : out std_logic;
    -- Displays
    display1 : out std_logic_vector(6 downto 0);
    display2 : out std_logic_vector(6 downto 0);
    display3 : out std_logic_vector(6 downto 0)
  );
end entity main;

architecture arqmain of main is
  -- Auxiliares motor
  signal clk_motor : std_logic := '0';
  signal pwm_out   : std_logic := '0';
  -- Auxiliares sensor
  signal distance   : integer := 0;
  signal bin_digits : std_logic_vector(27 downto 0);
  -- Constantes
  constant max_clk_motor : integer := 2500;
  constant max_speed     : integer := max_clk_motor; --! Velocidad máxima = Pulso completo
  constant min_speed     : integer := 300; --! Mínimo para que el motor tenga suficiente potencia para girar.

  -- Máquina de estados robot
  type state is (STOP, ACCELERATE, DECELERATE);
  signal PS, NS : state := STOP;
begin
  -- Parte del motor
  div_freq_motor : entity work.divf(arqdivf) generic map (max_clk_motor) port map(clk, clk_motor);
  pwm_motor      : entity work.senal (arqsenal) port map(clk_motor, 500, pwm_out);
  pwm        <= pwm_out;
  enable_out <= enable_in;
  -- Parte para el sensor
  sensor    : entity work.ultrasonic port map(clk, reset, echo, trigger, distance);
  converter : entity work.bcd2ss7 port map(distance, bin_digits);
  digit1    : entity work.display port map(bin_digits(3 downto 0), display1);
  digit2    : entity work.display port map(bin_digits(7 downto 4), display2);
  digit3    : entity work.display port map(bin_digits(11 downto 8), display3);

  fsm_change : process (clk, reset)
  begin
    if reset = '0' then
      PS <= STOP;
    else
      PS <= NS;
    end if;
  end process;

  fsm_robot : process (clk)
  begin
    case PS is
      when STOP =>
    end case;
  end process;
end architecture;