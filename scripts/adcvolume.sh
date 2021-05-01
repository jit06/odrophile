#!/bin/bash

LAST_VOLUME=-1
VOL_100=0

while true
do
	VALUE=$(cat /sys/class/saradc/saradc_ch1)
	VOL_100=$(($VALUE/10))

	if [ $VOL_100 -gt 100 ]; then
		VOL_100=100
	fi

	if [ $VOL_100 != $LAST_VOLUME ]; then


		LAST_VOLUME=$VOL_100
		mpc volume $VOL_100
	fi
	sleep 0.1
done
