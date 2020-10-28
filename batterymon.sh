#!/bin/sh

# Read Battery Voltage on ODROID-C0

BATTVOL=$(cat /sys/class/saradc/saradc_ch0)

while true
do
    if [ "$BATTVOL" -ge 850 ]; then
        echo 1 > /sys/class/gpio/gpio101/value
    else
        echo 0 > /sys/class/gpio/gpio101/value
    fi

    if [ "$BATTVOL" -ge 730 ]; then
        echo 1 > /sys/class/gpio/gpio100/value
    else
        echo 0 > /sys/class/gpio/gpio100/value
    fi

    if [ "$BATTVOL" -ge 570 ]; then
        echo 1 > /sys/class/gpio/gpio99/value
    else
        echo 0 > /sys/class/gpio/gpio99/value
    fi

    if [ "$BATTVOL" -ge 430 ]; then
        echo 1 > /sys/class/gpio/gpio108/value
    else
        echo 0 > /sys/class/gpio/gpio108/value
    fi

    if [ "$BATTVOL" -ge 270 ]; then
        echo 1 > /sys/class/gpio/gpio97/value
    else
        echo 0 > /sys/class/gpio/gpio97/value
    fi

    if [ "$BATTVOL" -ge 130 ]; then
        echo 1 > /sys/class/gpio/gpio98/value
    else
        echo 0 > /sys/class/gpio/gpio98/value
    fi

    sleep 10
done
