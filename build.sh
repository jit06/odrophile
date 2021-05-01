#!/bin/bash

############################################################
# this script must be run on custom volumio release for
# odroid C1 from https://github.com/jit06/Build
# To be run as root
############################################################

# install required packages
echo "------------ install packages"
apt-get -y install xorg xserver-xorg-video-mali mali-x11 chromium-browser busybox


# allows mali HW accel
echo "------------ enable HW accel for X"
rm -f /usr/lib/arm-linux-gnueabihf/libUMP.so
rm -f /usr/lib/arm-linux-gnueabihf/libMali.so
ln -s /usr/share/mali/libs/libUMP.so /usr/lib/arm-linux-gnueabihf/libUMP.so
ln -s /usr/share/mali/libs/libMali.so /usr/lib/arm-linux-gnueabihf/libMali.so


# enable chromium HW accel with mali
echo "------------ enable HW accel for chromium"
rm /usr/lib/chromium-browser/libEGL.so
rm /usr/lib/chromium-browser/libGLESv2.so
ln -s /usr/share/mali/libs/libEGL.so /usr/lib/chromium-browser/libEGL.so
ln -s /usr/share/mali/libs/libGLESv2.so /usr/lib/chromium-browser/libGLESv2.so


# enable kiosk mode
echo "------------ enable kiosk mode"
cp scripts/volumiokiosk.sh /opt/
cp scripts/volumio-kiosk.service /etc/systemd/system/
chmod +x /opt/volumiokiosk.sh
systemctl daemon-reload
systemctl enable volumio-kiosk

# custom boot.ini
echo "------------ install custom boot.ini"
cp scripts/boot.ini /media/boot/


# set default uboot hdmi mode to 640x480 (default is 720p)
echo "------------ set uboot splash"
fw_setenv hdmimode 480p
fw_setenv outputmode 480p
fw_setenv fb_width 640
fw_setenv fb_height 480
fw_setenv display_width 640
fw_setenv display_height 480


# tell uboot to load the boot splash
cp gfx/boot-logo.bmp /media/boot/
fw_setenv preloadlogo 'video open;video clear; video dev open ${outputmode};fatload mmc 0:1 ${loadaddr_logo} boot-logo.bmp;bmp display ${loadaddr_logo}; bmp scale'


# handle the second splash screen in initram-fs
echo "------------ set system splash"
cp gfx/logo.lzo /etc/
cp scripts/cpimg.sh /etc/initramfs-tools/hooks/
cp scripts/c1_init.sh /etc/initramfs-tools/scripts/local-top/
chmod +x /etc/initramfs-tools/hooks/cpimg.sh
chmod +x /etc/initramfs-tools/scripts/local-top/c1_init.sh

update-initramfs -u
mkimage -A arm -O linux -T ramdisk -C none -a 0 -e 0 -n uInitrd -d /boot/initrd.img-3.10.107-13 /media/boot/uInitrd


# setup volume knob support
echo "------------ setup volume knob"
sed -i -e "s/\${mixer}/mixer_type \"software\"/g" /volumio/app/plugins/music_service/mpd/mpd.conf.tmpl
cp scripts/adcvolume.sh /opt/
cp scripts/adc-volume.service /etc/systemd/system/
chmod +x /opt/adcvolume.sh
systemctl daemon-reload
systemctl enable adc-volume


# setup loading leds animation
echo "------------ setup loading leds animation"
cp scripts/loadingleds.sh /opt/
cp scripts/loading-leds.service /etc/systemd/system/
chmod +x /opt/loadingleds.sh
systemctl daemon-reload
systemctl enable loading-leds

echo "----------- finished"
