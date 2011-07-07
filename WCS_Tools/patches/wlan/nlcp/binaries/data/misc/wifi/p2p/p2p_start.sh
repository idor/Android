#!/system/bin/sh

export IP_ADDR=10.0.0.1
export IP_MASK=255.0.0.0
export DEV_NAME=p2p_blaze1
export GO_INTENT=7

stop
setprop ctl.stop wpa_supplicant
mkdir -p /data/misc/wifi/sockets
insmod /system/lib/modules/wl12xx_sdio.ko
setprop ctl.start p2p_supplicant
sleep 5
wpa_cli -ip2p_wlan0 set device_name $DEV_NAME
wpa_cli -ip2p_wlan0 set p2p_go_intent $GO_INTENT
 
ifconfig wlan0 $IP_ADDR netmask $IP_MASK

