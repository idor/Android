#!/system/bin/sh

#
# p2p_start.sh
#
# p2p invocation script
#
# Copyright (C) {2011} Texas Instruments Incorporated - http://www.ti.com/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# 	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and  
# limitations under the License.
#

export IP_ADDR=10.0.0.1
export IP_MASK=255.0.0.0
export DEV_NAME=p2p_blaze1
export GO_INTENT=7

mkdir -p /data/misc/wifi/sockets
insmod /system/lib/modules/wl12xx_sdio.ko
setprop ctl.start p2p_supplicant
sleep 5
wpa_cli -ip2p_wlan0 set device_name $DEV_NAME
wpa_cli -ip2p_wlan0 set p2p_go_intent $GO_INTENT
 
ifconfig wlan0 $IP_ADDR netmask $IP_MASK

