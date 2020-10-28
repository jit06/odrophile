#!/bin/bash
GPIO_OUT=(98 99 77 118 117 103 102 104 87 83 97 108 100 101 76 105 106 107 115 116 88 74)
GPIO_IN=(75)

echo "remove aml_i2c module"
rmmod aml_i2c

echo "Init GPIO Out..."
for pin in "${GPIO_OUT[@]}"; do
	echo "init $pin"
	echo $pin > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio$pin/direction
	echo "done $pin"
done

echo "Init GPIO in..."
for pin in "${GPIO_IN[@]}"; do
	echo "init $pin"
	echo $pin > /sys/class/gpio/export
	echo in > /sys/class/gpio/gpio$pin/direction
	echo both > /sys/class/gpio/gpio$pin/edge
	echo "done $pin"
done
