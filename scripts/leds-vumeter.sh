#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/common.sh"

while read; 
do
	valL="${REPLY:0:1}"
	valR="${REPLY:2:1}"

	for led in 1 2 3 4 5 6 7; do
		if [ $led -le $valL ]; then
			echo 1 > /sys/class/gpio/gpio${GPIO_LEDL[$led]}/value
		else
			echo 0 > /sys/class/gpio/gpio${GPIO_LEDL[$led]}/value
		fi

		if [ $led -le $valR ]; then
			echo 1 > /sys/class/gpio/gpio${GPIO_LEDR[$led]}/value
		else
			echo 0 > /sys/class/gpio/gpio${GPIO_LEDR[$led]}/value
		fi
	done
done
