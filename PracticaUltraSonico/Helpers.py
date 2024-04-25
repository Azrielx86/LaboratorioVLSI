def pulse_to_ms(in_pulse: int, reference_clock: int = 50_000_000) -> float:
    """Returns duration in miliseconds"""
    print("Time in miliseconds.")
    return (in_pulse * 1000.0) / reference_clock

def ms_to_pulse(in_time: float, reference_clock: int = 50_000_000) -> float:
    """Returns pulse in ms using a reference clock. 50[MHz] = 1000[ms]"""
    return (in_time * reference_clock) / 1000.0

def ms_to_cm(time_elapsed: float) -> float:
    """Returns centimeters per second (when 34 cm/ms = Sonic Speed) using a HC-SR04 sensor."""
    return (34.0 * time_elapsed) / 2
