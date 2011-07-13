#!/system/bin/sh

killall udhcpd
ifconfig wlan0 down
killall logwrapper
killall hostapd_bin
sleep 2
rmmod wl12xx_sdio
