#!/system/bin/sh

killall udhcpd
ifconfig wlan0 down
killall hostapd_bin
/system/bin/rmmod wl12xx_sdio
