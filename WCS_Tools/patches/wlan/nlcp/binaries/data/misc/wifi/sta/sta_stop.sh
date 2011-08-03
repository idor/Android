#!/system/bin/sh

setprop ctl.stop wpa_supplicant
ifconfig wlan0 down
#rmmod wl12xx_sdio

