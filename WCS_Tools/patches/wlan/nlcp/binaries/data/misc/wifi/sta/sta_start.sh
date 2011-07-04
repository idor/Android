#!/system/bin/sh

insmod /system/lib/modules/wl12xx_sdio.ko
ifconfig wlan0 up
sleep 2
wpa_supplicant -Dnl80211 -iwlan0 -c/data/misc/wifi/wpa_supplicant/wpa_supplicant.conf -dd -B

