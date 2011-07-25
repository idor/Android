#!/system/bin/sh
insmod /system/lib/modules/wl12xx_sdio.ko
iw reg set `grep country_code= /data/misc/wifi/ap/hostapd.conf | sed "s:country_code=::"`
iw reg get
/system/bin/logwrapper /system/bin/hostapd_bin -dd -B /data/misc/wifi/ap/hostapd.conf
sleep 2
ifconfig wlan0 192.168.43.1 netmask 255.255.255.0 up
sleep 2
udhcpd -f /data/misc/wifi/ap/dhcpd.conf &
