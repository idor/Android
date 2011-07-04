#!/system/bin/sh

export SLEEP_TIME=10

wpa_cli -ip2p_wlan0 p2p_find

if [[ $# > 0 ]]; then
	SLEEP_TIME=$1
fi

sleep $SLEEP_TIME

wpa_cli -ip2p_wlan0 p2p_peers
wpa_cli -ip2p_wlan0 p2p_stop_find
