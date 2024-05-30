def hertz_to_seconds(hertz: float):
  return 1 / hertz

clock_fpga = 50e6 # MHz
clock_fpga_ns = hertz_to_seconds(clock_fpga)
clock_uart_us = hertz_to_seconds(115200)
uart_tm = clock_uart_us / 32

print(f"{clock_fpga} Hz => {clock_fpga_ns} s")
print(f"115200 Hz => {clock_uart_us} s")
print(f"{clock_uart_us} s / 32 => {uart_tm} s")

period = (1 * uart_tm) / clock_fpga_ns

print(period)
print(f"Mitad del periodo: {round(period / 2)}")