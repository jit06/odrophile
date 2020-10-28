#!/bin/bash

GPIO_LEDR=(0 102 104 115 116 87 88 83)
GPIO_LEDL=(0 106 103 105 117 118 76 77)

while read; 
do
#	echo "line = ${REPLY}"
#	echo "led 3 = ${REPLY:4:1}"
#	echo "led 4 = ${REPLY:6:1}"
	valL="${REPLY:0:1}"
	valR="${REPLY:2:1}"

	for led in 1 2 3 4 5 6 7; do
#		echo "led = $led / valL = $valL"
		if [ $led -le $valL ]; then
#			echo "led $led > ON"
			echo 1 > /sys/class/gpio/gpio${GPIO_LEDL[$led]}/value
		else
#			echo "led $led > OFF"
			echo 0 > /sys/class/gpio/gpio${GPIO_LEDL[$led]}/value
		fi

		if [ $led -le $valR ]; then
#			echo "led $led > ON"
			echo 1 > /sys/class/gpio/gpio${GPIO_LEDR[$led]}/value
		else
#			echo "led $led > OFF"
			echo 0 > /sys/class/gpio/gpio${GPIO_LEDR[$led]}/value
		fi
	done

#	if [ $val = "4" ] ; then
#		echo 1 > /sys/class/gpio/gpio88/value;
#	else
#		echo 0 > /sys/class/gpio/gpio88/value;
#	fi
done
