#!/bin/bash

GPIO_BAT=(101 100 99 108 97 98)
GPIO_LEDR=(102 104 115 116 87 88 83)
GPIO_LEDL=(106 103 105 117 118 76 77)

echo "testing battery monitor leds..."
for led in "${GPIO_BAT[@]}"; do
	echo "led $led"
	echo 1 > /sys/class/gpio/gpio$led/value
#	sleep 1
#	echo 0 > /sys/class/gpio/gpio$led/value
done

echo "testing Right vu meter leds..."
for led in "${GPIO_LEDR[@]}" ; do
	echo "led $led"
	echo 1 > /sys/class/gpio/gpio$led/value
	sleep 1
	echo 0 > /sys/class/gpio/gpio$led/value
done

echo "testing Left vu meter leds..."
for led in "${GPIO_LEDL[@]}" ; do
	echo "led $led"
	echo 1 > /sys/class/gpio/gpio$led/value
	sleep 1
	echo 0 > /sys/class/gpio/gpio$led/value
done
