#!/system/bin/sh

killall udhcpd
ifconfig wlan0 down
killall hostapd_bin
rmmod wl12xx_sdio
