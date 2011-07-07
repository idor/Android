#!/system/bin/sh
mkdir -p /data/misc/wifi/sockets
insmod /system/lib/modules/wl12xx_sdio.ko
ifconfig wlan0 up
sleep 2
setprop ctl.start wpa_supplicant

