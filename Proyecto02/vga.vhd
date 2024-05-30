library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity vga is
  port (
    clk    : in std_logic;
    reset  : in std_logic;
    red    : out std_logic_vector (3 downto 0);
    green  : out std_logic_vector (3 downto 0);
    blue   : out std_logic_vector (3 downto 0);
    h_sync : out std_logic;
    v_sync : out std_logic;
    rx_bin : out std_logic_vector(7 downto 0);
    rx_led : out std_logic;
    rx     : in std_logic
  );
end entity;

architecture arqvga of vga is
  signal clkl, disp_ena : std_logic;
  signal clklsec        : std_logic;
  signal column, row    : integer;
  signal int            : integer range 0 to 15;
  signal ss7out         : std_logic_vector(6 downto 0);
  signal rx_out         : std_logic_vector(9 downto 0) := (others => '0');
begin
  rx_a : entity work.rx_uart(rxuartarch) generic map (10) port map (clk, reset, rx, rx_out);
  rx_bin <= rx_out(8 downto 1);
  rx_led <= rx;

  u1 : entity work.divf(arqdivf) generic map (0) port map (clk, clkl);
  u2 : entity work.divf(arqdivf) generic map (25000000) port map (clk, clklsec);
  u3 : entity work.vga_core(arqcr) port map (clkl, disp_ena, h_sync, v_sync, column, row);
  u5 : entity work.cont(arqcont) port map (clklsec, int);
  u6 : entity work.ss7int(arqss7int) port map (to_integer(unsigned(rx_out(5 downto 1))), ss7out);
  u7 : entity work.imagen(arqim) port map (disp_ena, column, row, 100, 200, ss7out, red, green, blue);
end architecture;