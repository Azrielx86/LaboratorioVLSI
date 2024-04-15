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
    -- Displays
    --display1 : out std_logic_vector(6 downto 0);
    --display2 : out std_logic_vector(6 downto 0);
    --display3 : out std_logic_vector(6 downto 0);
    led_out  : out std_logic_vector(7 downto 0)
  );
end entity main;

architecture arqmain of main is
  signal distance : integer := 0;

  component ultrasonic is
    port (
      clk       : in std_logic;
      reset     : in std_logic;
      echo      : in std_logic;
      trigger   : out std_logic;
      echo_time : out integer
    );
  end component ultrasonic;
begin
  -- sensor : entity work.ultrasonic(archultrasonic) port map(clk, reset, echo, trigger, distance);
  led_out <= std_logic_vector(to_unsigned(distance, 8));
  sensor : ultrasonic port map(clk, reset, echo, trigger, distance);
end architecture;