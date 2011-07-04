#!/system/bin/sh

insmod /system/lib/modules/wl12xx_sdio.ko
ifconfig wlan0 up
sleep 2
setprop ctl.start wpa_supplicant
