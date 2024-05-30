library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity rx_uart is
  generic (
    n_bitsdata : positive := 8
  );
  port (
    clk          : in std_logic;
    reset        : in std_logic;
    rx_d         : in std_logic;
    data_package : out std_logic_vector(n_bitsdata - 1 downto 0)
  );
end entity rx_uart;

architecture rxuartarch of rx_uart is
  -- type status is (Rx_Idle, Rx_Start, Rx_Data, Rx_Stop);
  type status is (IDLE, START_BIT, WAIT_CICLES_FRONT, WAIT_CICLES_BACK);
  signal clk_uart       : std_logic := '0';
  signal next_status    : status    := IDLE;
  signal present_status : status    := IDLE;

  constant baud_rate     : integer                                    := 115200;
  constant pulses_count  : integer                                    := (25000000 / baud_rate) - 1;
  signal register_dataRx : std_logic_vector (n_bitsdata - 1 downto 0) := (others => '0');
  signal buffer_Rx       : std_logic_vector (n_bitsdata - 1 downto 0) := (others => '0');
  signal counter_bits    : integer range 0 to n_bitsdata              := 0;
  signal counter_pulse   : integer range 0 to pulses_count + 1        := 0;
begin

  clk_gen : process (clk)
    variable count : integer := 0;
  begin
    if rising_edge(clk) then
      if reset = '0' then
        clk_uart <= '0';
        count := 0;
      else
        count := count + 1;
        if count = 7 then -- Periodo para 50MHz
          clk_uart <= not clk_uart;
          count := 0;
        end if;
      end if;
    end if;
  end process;

  fsm_change : process (clk_uart, reset)
  begin
    if reset = '0' then
      present_status <= IDLE;
    elsif rising_edge(clk_uart) then
      present_status <= next_status;
    end if;
  end process;

  Rx : process (clk_uart)
    variable bit_counter : integer := 0;
    variable ticks_count : integer := 0;
  begin
    if rising_edge(clk_uart) then
      if reset = '0' then
        next_status <= IDLE;
        bit_counter := 0;
        ticks_count := 0;
      else
        case present_status is
          when IDLE                  =>
            register_dataRx <= (others => '0');
            next_status     <= START_BIT;
          when START_BIT =>
            if rx_d = '0' then
              next_status <= WAIT_CICLES_FRONT;
            end if;
          when WAIT_CICLES_FRONT =>
            ticks_count := ticks_count + 1;
            if ticks_count = 16 then
              register_dataRx(bit_counter) <= rx_d;
              next_status <= WAIT_CICLES_BACK;
            end if;
            when WAIT_CICLES_BACK =>
            ticks_count := ticks_count + 1;
            if ticks_count = 32 then
              ticks_count := 0;
              bit_counter := bit_counter + 1;
              next_status <= WAIT_CICLES_FRONT;
              if bit_counter = 10 then
                bit_counter := 0;
                buffer_Rx   <= register_dataRx;
                next_status <= IDLE;
              end if;
            end if;
        end case;
      end if;
    end if;
    data_package <= buffer_Rx;
  end process Rx;
end architecture;