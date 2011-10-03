#!/system/bin/sh

#
# ap_start.sh
#
# hostap invocation script
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

insmod /system/lib/modules/wl12xx_sdio.ko
iw reg set `grep country_code= /data/misc/wifi/hostapd.conf | sed "s:country_code=::"`
iw reg get
iw wlan0 del
iw `ls /sys/class/ieee80211/` interface add wlan1 type managed
setprop ctl.start hostapd_bin
sleep 2
setprop ctl.start ifcfg_softap
sleep 2
setprop ctl.start dhcpd_softap
