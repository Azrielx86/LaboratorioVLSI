library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_uart_tb is
end entity rx_uart_tb;

architecture tb_arch of rx_uart_tb is
  -- Constants
  constant CLK_PERIOD : time := 10 ns;
  
  -- Signals
  signal clk       : std_logic := '0';
  signal reset     : std_logic := '0';
  signal br_tick   : std_logic := '0';
  signal rx        : std_logic := '0';
  signal rx_data   : std_logic_vector(7 downto 0);
  
  -- Component Declaration
  component rx_uart is
    generic (
      nbits : integer range 0 to 8 := 8
    );
    port (
      clk     : in std_logic;
      reset   : in std_logic;
      br_tick : in std_logic;
      rx      : in std_logic;
      rx_data : out std_logic_vector(7 downto 0)
    );
  end component rx_uart;
  
begin
  -- DUT Instantiation
  dut : rx_uart
    generic map (
      nbits => 8
    )
    port map (
      clk     => clk,
      reset   => reset,
      br_tick => br_tick,
      rx      => rx,
      rx_data => rx_data
    );
  
  -- Clock Process
  clk_process : process
  begin
    while now < 1000 ns loop
      clk <= '0';
      wait for CLK_PERIOD / 2;
      clk <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
    wait;
  end process clk_process;
  
  -- Stimulus Process
  stimulus_process : process
  begin
    reset <= '1';
    wait for CLK_PERIOD * 2;
    reset <= '0';
    wait for CLK_PERIOD * 2;
    br_tick <= '1';
    wait for CLK_PERIOD * 2;
    br_tick <= '0';
    wait for CLK_PERIOD * 2;
    rx <= '1';
    wait for CLK_PERIOD * 2;
    rx <= '0';
    wait for CLK_PERIOD * 2;
    -- Add more stimulus here if needed
    wait;
  end process stimulus_process;
  
end architecture tb_arch;