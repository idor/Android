#!/system/bin/sh

wpa_cli -i wlan0 -p /var/run/wpa_supplicant/wlan0 terminate
killall wpa_supplicant
ifconfig wlan0 down
rmmod wl12xx_sdio

