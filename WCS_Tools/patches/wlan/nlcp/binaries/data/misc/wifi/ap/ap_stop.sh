#!/system/bin/sh

killall udhcpd
ifconfig wlan0 down
killall logwrapper
killall hostapd_bin
sleep 2
rmmod wl12xx_sdio

#setprop ctl.stop dhcpd_softap
#ifconfig wlan1 down
#sleep 1
#setprop ctl.stop hostapd_bin
#sleep 2
#rmmod wl12xx_sdio


