library ieee;
use ieee.std_logic_1164.all;

entity pwm is
  port (
    clk, rst, enable_in, dir : in std_logic;
    pwm, npwm, enable_out    : out std_logic
  );
end entity;

architecture arqpwm of pwm is
  type state is (STP, LEFT, RIGHT);
  signal PS, NS  : state;
  signal clkl    : std_logic;
  signal pwm_out : std_logic;
begin
  epwm  : entity work.senal (arqsenal) port map(clkl, 500, pwm_out);
  dvfff : entity work.divf(arqdivf) generic map (2500) port map(clk, clkl);

  process (rst, clkl)
  begin
    if rst = '0' then
      PS <= STP;
    elsif rising_edge(clkl) then
      PS <= NS;
    end if;
  end process;

  process (PS, enable_in, dir, pwm_out)
  begin
    case PS is
      when STP =>
        if enable_in = '1' and dir = '1' then
          NS <= RIGHT;
        elsif enable_in = '1' and dir = '0' then
          NS <= LEFT;
        else
          NS <= STP;
        end if;

        pwm        <= '0';
        npwm       <= '0';
        enable_out <= '0';

      when LEFT =>
        if enable_in = '0' then
          NS <= STP;
        elsif enable_in = '1' and dir = '1' then
          NS <= RIGHT;
        else
          NS <= LEFT;
        end if;

        pwm        <= '0';
        npwm       <= pwm_out;
        enable_out <= '1';

      when RIGHT =>
        if enable_in = '0' then
          NS <= STP;
        elsif enable_in = '1' and dir = '0' then
          NS <= LEFT;
        else
          NS <= RIGHT;
        end if;

        pwm        <= pwm_out;
        npwm       <= '0';
        enable_out <= '1';

      when others =>
        pwm        <= '0';
        npwm       <= '0';
        enable_out <= '0';
        NS         <= STP;
    end case;
  end process;
end architecture;