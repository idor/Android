#
# calibrate.sh
#
# calibration of the wlan device over Blaze platform
# Script takes two arguments:
# 1. MAC address (e.g 08:00:28:12:34:56)
# 2. INI file for calibration (depend on device and FEM, full path required)
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

#!/system/bin/sh

export NEW_MAC_ADDRESS=$1
export INI_FILE=$2

#if [ "$NEW_MAC_ADDRESS" == "" ] ; then export NEW_MAC_ADDRESS=08:00:28:12:34:56 ; fi
#if [ "$INI_FILE" == "" ] ; then export INI_FILE=/system/etc/wifi/ini_files/128x/TQS_D_1.7.ini ; fi

echo Create reference NVS
calibrator set ref_nvs $INI_FILE

echo Copy reference NVS file
cat ./new-nvs.bin > /system/etc/firmware/ti-connectivity/wl1271-nvs.bin

echo Insert wl12xx SDIO module
insmod /system/lib/modules/wl12xx_sdio.ko

echo Calibrate device
calibrator wlan0 plt power_mode on
calibrator wlan0 plt tune_channel 0 7
calibrator wlan0 plt tx_bip 1 1 1 1 1 1 1 1
calibrator wlan0 plt power_mode off

echo Set MAC address in NVS file $NEW_MAC_ADDRESS
calibrator set nvs_mac ./new-nvs.bin $NEW_MAC_ADDRESS
#calibrator set nvs_mac ./new-nvs.bin 08:00:28:00:64:87

echo Remove wl12xx modules
rmmod wl12xx_sdio wl12xx
rmmod wl12xx

echo Copy calibrated NVS file
cat ./new-nvs.bin > /system/etc/firmware/ti-connectivity/wl1271-nvs.bin
insmod /system/lib/modules/wl12xx.ko

