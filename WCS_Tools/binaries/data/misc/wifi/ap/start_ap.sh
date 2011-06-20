#!/system/bin/sh

/system/bin/insmod /system/lib/modules/wl12xx_sdio.ko
hostapd_bin -B /var/run/hostapd/hostapd.wlan0.conf 
ifconfig wlan0 up
#udhcpd -f /var/run/dhcpd/udhcpd.wlan0.conf
