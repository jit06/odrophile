#!/bin/sh
PREREQ=""
prereqs() {
         echo "$PREREQ"
}

case $1 in 
# get pre-requisites 
prereqs)
         prereqs
         exit 0
         ;; esac

. /usr/share/initramfs-tools/hook-functions

#rm -f ${DESTDIR}/etc/splash.lzo

cp -pnL /etc/logo.lzo ${DESTDIR}/etc
chmod 644 ${DESTDIR}/etc/logo.lzo

exit 0
