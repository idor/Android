#!/system/bin/sh

wpa_cli -iwlan0 -p/data/misc/wifi/wpa_supplicant/wlan0 $@
