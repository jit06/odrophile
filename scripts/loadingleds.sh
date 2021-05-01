#!/bin/bash

GPIO_LEDR=(102 104 115 116 87 88 83)
GPIO_LEDL=(106 103 105 117 118 76 77)
GPIO_OUT=( "${GPIO_LEDL[@]}" "${GPIO_LEDR[@]}" )
WAIT_SEC=4

echo "Init GPIO Out..."
for pin in "${GPIO_OUT[@]}"; do
	echo "init $pin"
	echo $pin > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio$pin/direction
done

echo "start loading animation"
for led in 0 1 2 3 4 5 6; do
    echo "led $led => ON"
    echo 1 > /sys/class/gpio/gpio${GPIO_LEDL[$led]}/value
    echo 1 > /sys/class/gpio/gpio${GPIO_LEDR[$led]}/value
    sleep $WAIT_SEC
done

echo "switch off all leds"
for led in 0 1 2 3 4 5 6; do
    echo "led $led => OFF"
    echo 0 > /sys/class/gpio/gpio${GPIO_LEDL[$led]}/value
    echo 0 > /sys/class/gpio/gpio${GPIO_LEDR[$led]}/value
done

echo "Free GPIO Out..."
for pin in "${GPIO_OUT[@]}"; do
	echo "free $pin"
	echo $pin > /sys/class/gpio/unexport
done
