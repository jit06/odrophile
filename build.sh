#!/bin/bash

############################################################
# this script must be run on custom volumio release for
# odroid C1 from https://github.com/jit06/Build
# To be run as root
############################################################

# install required packages
apt-get -y install xorg xserver-xorg-video-mali mali-x11 chromium-browser busybox


# allows mali HW accel
ln -s /usr/share/mali/libs/libUMP.so /usr/lib/arm-linux-gnueabihf/libUMP.so
ln -s /usr/share/mali/libs/libMali.so /usr/lib/arm-linux-gnueabihf/libMali.so


# enable chromium HW accel with mali
rm /usr/lib/chromium-browser/libEGL.so
rm /usr/lib/chromium-browser/libGLESv2.so
ln -s /usr/share/mali/libs/libEGL.so /usr/lib/chromium-browser/libEGL.so
ln -s /usr/share/mali/libs/libGLESv2.so /usr/lib/chromium-browser/libGLESv2.so


# enable kiosk mode
cp scripts/volumiokiosk.sh /opt/
cp scripts/volumio-kiosk.service /etc/systemd/system/
chmod +x /opt/volumiokiosk.sh
systemctl daemon-reload


# set default uboot hdmi mode to 640x480 (default is 720p)
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
cp gfx/logo.lzo /etc/
cp scripts/cpimg.sh /etc/initramfs-tools/hooks/

echo "busybox lzop -d -c /etc/logo.lzo > /dev/fb0" >> /etc/initramfs-tools/scripts/local-top/c1_init.sh

update-initramfs -u
mkimage -A arm -O linux -T ramdisk -C none -a 0 -e 0 -n uInitrd -d /boot/initrd.img-3.10.107-13 /media/boot/uInitrd
