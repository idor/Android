#!/system/bin/sh

killall udhcpd
ifconfig wlan1 down
killall hostapd_bin
rmmod wl12xx_sdio
