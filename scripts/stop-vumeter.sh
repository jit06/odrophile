#!/bin/bash

GPIO_LEDR=(0 102 104 115 116 87 88 83)
GPIO_LEDL=(0 106 103 105 117 118 76 77)

killall cava

for led in 1 2 3 4 5 6 7; do
	echo 0 > /sys/class/gpio/gpio${GPIO_LEDL[$led]}/value
        echo 0 > /sys/class/gpio/gpio${GPIO_LEDR[$led]}/value
done

