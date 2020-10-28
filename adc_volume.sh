#!/bin/bash

VOLUME=0

while true
do
	VALUE=$(cat /sys/class/saradc/saradc_ch1)
	if [ $VALUE != $VOLUME ]; then
		VOLUME=$VALUE
		let "vol_100=$VOLUME/10"
		if [ $vol_100 -gt 100 ]; then
			vol_100=100
		fi
		mpc volume $vol_100
	fi
	sleep 0.1
done
