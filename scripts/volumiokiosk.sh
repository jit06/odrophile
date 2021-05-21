#!/bin/bash

# wait for volumio UI to be ready
while ! wget -q --spider http://localhost:3000
do
 sleep 1
done;

# start x on vt1
/usr/lib/xorg/Xorg -nolisten tcp -nocursor vt1 &

# create chromium data dir
mkdir /tmp/volumiokiosk

# start chromium
DISPLAY=:0 /usr/bin/chromium-browser \
--no-sandbox \
--simulate-outdated-no-au='Tue, 31 Dec 2099 23:59:59 GMT' \
--force-device-scale-factor=1 \
--disable-pinch \
--kiosk \
--no-first-run \
--noerrdialogs \
--disable-breakpad \
--disable-crash-reporter \
--disable-infobars \
--disable-session-crashed-bubble \
--disable-translate \
--use-gl=egl \
--window-position=0,0 \
--window-size=800,480 \
--disable-gpu-vsync \
--disable-quic \
--enable-fast-unload \
--enable-checker-imaging \
--enable-tcp-fast-open \
--enable-native-gpu-memory-buffers \
--enable-gpu-rasterization \
--enable-zero-copy \
--num-raster-threads=4 \
--user-data-dir='/tmp/volumiokiosk' \
http://localhost:3000
