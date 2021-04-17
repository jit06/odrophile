while ! wget -q --spider http://localhost:3000
do
 sleep 1
done;

/usr/lib/xorg/Xorg -nolisten tcp vt1 &
#-novtswitch -nocursor &

mkdir /tmp/volumiokiosk

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
