#!/system/bin/sh

insmod /system/lib/modules/wl12xx_sdio.ko
hostapd_bin -B /data/misc/wifi/ap/hostapd.conf
ifconfig wlan0 up
udhcpd -f /data/misc/wifi/ap/udhcpd.conf
