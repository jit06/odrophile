#!/bin/bash

############################################################
# this script must be run on custom volumio release for
# odroid C1 from https://github.com/jit06/Build
# To be run as root
############################################################

# install required packages
echo "------------ install packages"
apt-get -y install xorg xserver-xorg-video-mali mali-x11 chromium-browser busybox unzip autoconf make libtool libfftw3-dev libasound2-dev inotify-tools exfat-fuse exfat-utils


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


# custom boot.ini
echo "------------ install custom boot.ini"
cp boot/boot.ini /media/boot/


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
cp boot/cpimg.sh /etc/initramfs-tools/hooks/
cp boot/c1_init.sh /etc/initramfs-tools/scripts/local-top/
chmod +x /etc/initramfs-tools/hooks/cpimg.sh
chmod +x /etc/initramfs-tools/scripts/local-top/c1_init.sh

update-initramfs -u
mkimage -A arm -O linux -T ramdisk -C none -a 0 -e 0 -n uInitrd -d /boot/initrd.img-3.10.107-13 /media/boot/uInitrd


# copy services and scripts files
echo "------------ install scripts and services"
cp scripts/* /opt/
chmod +x /opt/*.sh
cp services/* /etc/systemd/system/
systemctl daemon-reload
systemctl enable volumio-kiosk
systemctl enable adc-volume
systemctl enable loading-leds


# setup volume knob support
echo "------------ setup soft volume in mpd"
sed -i -e "s/\${mixer}/mixer_type \"software\"/g" /volumio/app/plugins/music_service/mpd/mpd.conf.tmpl


# install cava
echo "------------ retreive cava sources and install it"
cd ..
git clone --depth 1 https://github.com/karlstav/cava
cd cava
./autogen.sh
./configure
make -j4
sudo make install
cd ../odrophile

echo "audio_output {
    type            "fifo"
    name            "mpd_oled_FIFO"
    path            "/tmp/mpd_oled_fifo"
    format          "44100:16:2"
}" >> /volumio/app/plugins/music_service/mpd/mpd.conf.tmpl

cp config/cava.config /home/volumio/.config/cava/config


# set hostname
echo "------------ set hostname"
echo "odrophile" >> /etc/hostname


# install volumio plugin and configurations
echo "------------ install volumio plugins"
sudo -u volumio mkdir /tmp/gpiorandom
sudo -u volumio cp plugins/gpiorandom.zip /tmp/gpiorandom/
cd /tmp/gpiorandom
sudo -u volumio unzip gpiorandom.zip
sudo -u volumio volumio plugin install
cd /home/volumio/odrophile

sudo -u volumio mkdir /tmp/commandOnEvent
sudo -u volumio cp plugins/commandOnEvent.zip /tmp/commandOnEvent/
cd /tmp/commandOnEvent
sudo -u volumio unzip commandOnEvent.zip
sudo -u volumio volumio plugin install
cd /home/volumio/odrophile


echo "------------ install volumio configuration"
sudo -u volumio cp -R plugins/configuration /data/


echo "----------- finished !"
