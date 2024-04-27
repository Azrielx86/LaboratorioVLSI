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
    enable_in, dir        : in std_logic;
    pwm, enable_out : out std_logic;
    -- Displays
    display1 : out std_logic_vector(6 downto 0);
    display2 : out std_logic_vector(6 downto 0);
    display3 : out std_logic_vector(6 downto 0)
  );
end entity main;

architecture arqmain of main is
  -- Auxiliares motor
  signal clkl : std_logic := '0';
  signal pwm_out : std_logic := '0';
  -- Auxiliares sensor
  signal distance   : integer := 0;
  signal bin_digits : std_logic_vector(27 downto 0);

begin
  -- Parte del motor
  div_freq_motor : entity work.divf(arqdivf) generic map (2500) port map(clk, clkl);
  pwm_motor      : entity work.senal (arqsenal) port map(clkl, 500, pwm_out);
  pwm <= pwm_out;
  enable_out <= enable_in;
  -- Parte para el sensor
  sensor    : entity work.ultrasonic port map(clk, reset, echo, trigger, distance);
  converter : entity work.bcd2ss7 port map(distance, bin_digits);
  digit1    : entity work.display port map(bin_digits(3 downto 0), display1);
  digit2    : entity work.display port map(bin_digits(7 downto 4), display2);
  digit3    : entity work.display port map(bin_digits(11 downto 8), display3);
end architecture;