#!/system/bin/sh
insmod /system/lib/modules/wl12xx_sdio.ko
iw reg set `grep country_code= /data/misc/wifi/ap/hostapd.conf | sed "s:country_code=::"`
iw reg get
/system/bin/logwrapper /system/bin/hostapd_bin -dd -B /data/misc/wifi/ap/hostapd.conf
sleep 2
ifconfig wlan0 192.168.43.1 netmask 255.255.255.0 up
sleep 2
udhcpd -f /data/misc/wifi/ap/dhcpd.conf &



#insmod /system/lib/modules/wl12xx_sdio.ko
#iw wlan0 del
#iw `ls /sys/class/ieee80211/` interface add wlan1 type managed
#setprop ctl.start hostapd_bin
#sleep 2
#setprop ctl.start ifcfg_softap
#sleep 2
#setprop ctl.start dhcpd_softap
