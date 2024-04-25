library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- https://stackoverflow.com/questions/32599947/cant-run-hc-sr04-sensor-vhdl
entity ultrasonic is
  port (
    clk      : in std_logic;
    reset    : in std_logic;
    echo     : in std_logic;
    trigger  : out std_logic;
    distance : out integer := 0
  );
end entity ultrasonic;

architecture archultrasonic of ultrasonic is
  type state_type is (Wait_state, Echo_state);
  signal NS, PS : state_type := Wait_state;
  signal cuenta : integer    := 0;
  -- signal reset_cuenta         : std_logic  := '0';
  signal centimeters          : integer   := 0;
  signal distance_out         : integer   := 0;
  signal past_echo, sync_echo : std_logic := '0';
begin

  -- counter : process (clk, reset, reset_cuenta, cuenta)
  -- begin
  --   if reset = '0' or reset_cuenta = '1' then
  --     cuenta <= 0;
  --   elsif rising_edge(clk) then
  --     cuenta <= cuenta + 1;
  --   end if;
  -- end process;

  state_machine : process (clk, reset)
  begin
    if reset = '0' then
      PS <= Wait_state;
    elsif rising_edge(clk) then
      PS <= NS;
    end if;
  end process;

  outputs : process (clk)
  begin
    if rising_edge(clk) then
      past_echo <= sync_echo;
      sync_echo <= echo;
    end if;
  end process;

  ultrasonic_sensor : process (clk, cuenta, past_echo, sync_echo, centimeters)
  begin
    if rising_edge(clk) then
      case PS is
        when Wait_state =>
          if cuenta >= 500 then
            trigger <= '0';
            NS      <= Echo_state;
            cuenta  <= 0;
          else
            trigger <= '1';
            NS      <= Wait_state;
            cuenta  <= cuenta + 1;
          end if;

        when Echo_state =>
          if past_echo = '0' and sync_echo = '1' then
            cuenta      <= 0;
            centimeters <= 0;
          elsif past_echo = '1' and sync_echo = '0' then
            distance_out <= centimeters;
            cuenta       <= 0;
          elsif cuenta >= 2900 then -- Aprox 1cm usando un reloj de 50[MHz]
            if centimeters >= 3448 then
              NS     <= Wait_state;
              cuenta <= 0;
            else
              centimeters <= centimeters + 1;
              cuenta      <= 0;
            end if;
          else
            NS     <= Echo_state;
            cuenta <= cuenta + 1;
          end if;
          trigger <= '0';
      end case;
    end if;
  end process;
  distance <= distance_out;
end architecture;