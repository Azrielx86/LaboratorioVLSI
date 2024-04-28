import matplotlib.pyplot as plot

max_speed = 2500
min_speed = 300

max_distance = 200
mid_distance = max_distance / 2

pwm = 0

distances: list[tuple[int, float]] = []

for distance in range(201):
    if distance <= mid_distance - 1: # Aceleea
        pwm = (distance * max_speed) / mid_distance
    elif distance <= mid_distance + 1: # Espera
        pwm = max_speed
    elif distance <= max_distance: # Desacelera
        pwm = ((max_distance - distance) * max_speed) / mid_distance
    print(f"{distance}[cm] = PWM: {pwm if pwm > 300 else 300}")
    distances.append((distance, pwm if pwm > 300 else 300))

x = [distance for distance, _ in distances]
y = [pwm for _, pwm in distances]

plot.plot(x, y)
plot.xlabel('Distance (cm)')
plot.ylabel('PWM')
plot.title('Distance vs PWM')
plot.show()
