#!/system/bin/sh

/system/bin/insmod /system/lib/modules/wl12xx_sdio.ko
ifconfig wlan0 up
sleep 2
wpa_supplicant -Dmac80211_wext -iwlan0 -c/var/run/wpa_supplicant/wpa_supplicant.conf -dd -B

