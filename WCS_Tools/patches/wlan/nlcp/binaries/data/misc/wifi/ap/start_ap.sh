#!/system/bin/sh

insmod /system/lib/modules/wl12xx_sdio.ko
hostapd_bin -B /data/misc/wifi/hostapd/hostapd.wlan0.conf
ifconfig wlan0 up
udhcpd -f /data/misc/wifi/dhcpd/udhcpd.wlan0.conf
