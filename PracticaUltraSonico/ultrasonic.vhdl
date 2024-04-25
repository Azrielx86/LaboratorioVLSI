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
    distance : out integer
  );
end entity ultrasonic;

architecture archultrasonic of ultrasonic is
  type state_type is (Init_state, Trigger_state, Echo_state);
  signal state         : state_type := Init_state;
  signal echoing       : std_logic  := '0';
  signal echo_recieved : std_logic  := '0';
  signal d             : integer;
  signal en_timer      : std_logic := '0';
  signal rst_timer     : std_logic := '0';
  signal cnt_timer     : integer   := 0;
  signal final_timer   : integer   := 0;
begin
  state_machine : process (clk, cnt_timer, echo_recieved)
  begin
    if rising_edge(clk) then
      case state is
        when Init_state =>
          if cnt_timer >= d then
            state     <= Trigger_state;
            rst_timer <= '1';
          else
            rst_timer <= '0';
          end if;
        when Trigger_state =>
          if cnt_timer >= d then
            state     <= Echo_state;
            rst_timer <= '1';
          else
            rst_timer <= '0';
          end if;
        when Echo_state =>
          if echo_recieved = '1' or cnt_timer >= d then
            state     <= Init_state;
            rst_timer <= '1';
          else
            state     <= Echo_state;
            rst_timer <= '0';
          end if;
        when others =>
          state <= Init_state;
      end case;
    end if;
  end process;

  timer : process (clk, en_timer, rst_timer)
  begin
    if rising_edge(clk) then
      if en_timer = '1' and rst_timer = '0' then
        cnt_timer <= cnt_timer + 1;
      elsif rst_timer = '1' then
        cnt_timer <= 0;
      end if;
    end if;
  end process;

  output : process (state, echo, echoing, cnt_timer)
  begin
    d       <= 0;
    trigger <= '0';
    case state is
      when Init_state =>
        en_timer      <= '1';
        trigger       <= '0';
        d             <= 50;
        echoing       <= '0';
        echo_recieved <= '0';
      when Trigger_state =>
        en_timer      <= '1';
        d             <= 250;
        echoing       <= '0';
        echo_recieved <= '0';
        trigger       <= '1';
      when Echo_state =>
        d <= 1_900_000_000;
        if echo = '0' and echoing = '0' then
          en_timer <= '1';
        elsif echo = '1' then
          en_timer <= '1';
          echoing  <= '1';
        elsif echo = '0' and echoing = '1' then
          final_timer   <= cnt_timer;
          en_timer      <= '0';
          echoing       <= '0';
          echo_recieved <= '1';
        else
          final_timer <= 0;
          echo_recieved <= '0';
          echoing <= '0';
          en_timer <= '0';
        end if;
      when others =>
        en_timer      <= '0';
        trigger       <= '0';
        d             <= 0;
        echoing       <= '0';
        echo_recieved <= '0';
    end case;
  end process;

  -- VelSonido[cm]( Conteo[hz] * 1000[ms] / 50_000_000[hz]) / 2 -> distancia en cm
  distance <= (34 * (final_timer * 1_000 / 25_000_000)) / 2;
end architecture;