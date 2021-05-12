#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/common.sh"

WAIT_SEC=4

echo "Init GPIO Out..."
initGPIOLeds

echo "start loading animation..."
for led in 1 2 3 4 5 6 7; do
    echo "led $led => ON"
    echo 1 > /sys/class/gpio/gpio${GPIO_LEDL[$led]}/value
    echo 1 > /sys/class/gpio/gpio${GPIO_LEDR[$led]}/value
    sleep $WAIT_SEC
done

echo "switch off all leds"
allLedsOff


