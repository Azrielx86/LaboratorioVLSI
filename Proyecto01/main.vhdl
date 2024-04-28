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
    enable_in       : in std_logic;
    pwm, enable_out : out std_logic;
    -- Displays
    display1 : out std_logic_vector(6 downto 0);
    display2 : out std_logic_vector(6 downto 0);
    display3 : out std_logic_vector(6 downto 0);
    -- Visulización del estado actual
    curr_state : out std_logic_vector(3 downto 0)
  );
end entity main;

architecture arqmain of main is
  -- Auxiliares motor
  signal clk_motor : std_logic := '0';
  signal pwm_var   : integer   := 0;
  signal pwm_out   : std_logic := '0';
  -- Auxiliares sensor
  signal distance     : integer := 0;
  signal neg_distance : integer := 0;
  signal bin_digits   : std_logic_vector(27 downto 0);
  -- Constantes
  constant max_clk_motor : integer := 1500;
  constant max_speed     : integer := max_clk_motor; --! Velocidad máxima = Pulso completo
  constant min_speed     : integer := 300; --! Mínimo para que el motor tenga suficiente potencia para girar.
  constant max_distance  : integer := 200; --! Máxima distancia: 200[cm], por lo tanto v_max se alcanza a los 100[cm]
  constant mid_distance  : integer := max_distance / 2;
  constant increment     : integer := 20;
  -- Máquina de estados robot
  type state is (STATE_STOP, STATE_ACCELERATE, STATE_MID, STATE_DECELERATE);
  signal PS, NS : state := STATE_STOP;
begin
  -- Parte del motor
  div_freq_motor : entity work.divf(arqdivf) generic map (max_clk_motor) port map(clk, clk_motor);
  pwm_motor      : entity work.senal (arqsenal) port map(clk_motor, pwm_var, pwm_out);
  pwm        <= pwm_out;
  enable_out <= enable_in;
  -- Parte para el sensor
  sensor    : entity work.ultrasonic port map(clk, reset, echo, trigger, distance);
  converter : entity work.bcd2ss7 port map(distance, bin_digits);
  digit1    : entity work.display port map(bin_digits(3 downto 0), display1);
  digit2    : entity work.display port map(bin_digits(7 downto 4), display2);
  digit3    : entity work.display port map(bin_digits(11 downto 8), display3);

  -- Procesos
  fsm_change : process (clk, reset, NS)
  begin
    if reset = '0' then
      PS <= STATE_STOP;
    elsif rising_edge(clk) then
      PS <= NS;
    end if;
  end process;

  fsm_robot : process (clk, distance, enable_in)
  begin
    if rising_edge(clk) then
      neg_distance <= - distance;
      case PS is
        when STATE_STOP =>
          if enable_in = '1' and distance < max_distance then
            NS <= STATE_ACCELERATE;
          else
            NS <= STATE_STOP;
          end if;
          pwm_var <= 0;
          curr_state <= "0001";
        when STATE_ACCELERATE =>
          if distance >= mid_distance - 1 then
            NS <= STATE_MID;
          else
            NS <= STATE_ACCELERATE;
          end if;
          pwm_var <= (distance * max_speed) / mid_distance;
          curr_state <= "0010";
        when STATE_MID =>
          if distance >= mid_distance + 1 then
            NS <= STATE_DECELERATE;
          else
            NS <= STATE_MID;
          end if;
          pwm_var <= max_speed;
          curr_state <= "0100";
        when STATE_DECELERATE =>
          if distance >= max_distance then
            NS <= STATE_STOP;
          else
            NS <= STATE_DECELERATE;
          end if;
          pwm_var <= ((max_distance - distance) * max_speed) / mid_distance;
          curr_state <= "1000";
      end case;
    end if;
  end process;
end architecture;