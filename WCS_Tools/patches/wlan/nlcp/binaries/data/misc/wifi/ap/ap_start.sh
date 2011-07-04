#!/system/bin/sh

insmod /system/lib/modules/wl12xx_sdio.ko
hostapd_bin -B /data/misc/wifi/hostapd/hostapd.conf
ifconfig wlan1 up
udhcpd -f /data/misc/wifi/dhcpd/udhcpd.conf
