#!/system/bin/sh

wpa_cli -i wlan0 -p/data/misc/wifi/wpa_supplicant/wlan0 terminate
sleep2 
#killall wpa_supplicant
ifconfig wlan0 down
sleep 2
rmmod wl12xx_sdio

