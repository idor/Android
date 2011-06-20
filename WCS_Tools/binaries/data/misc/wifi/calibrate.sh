#!/system/bin/sh

export NEW_MAC_ADDRESS=$1

if [ $NEW_MAC_ADDRESS == "" ] ; then export NEW_MAC_ADDRESS=08:00:28:12:34:56 ; fi

echo Create reference NVS
calibrator set ref_nvs /data/TQS_D_1.7.ini

echo Copy reference NVS file
cat ./new-nvs.bin > /system/etc/firmware/ti-connectivity/wl1271-nvs.bin

echo Insert wl12xx SDIO module
/system/bin/insmod /system/lib/modules/wl12xx_sdio.ko

echo Calibrate device
calibrator wlan0 plt power_mode on
calibrator wlan0 plt tune_channel 0 7
calibrator wlan0 plt tx_bip 1 1 1 1 1 1 1 1
calibrator wlan0 plt power_mode off

echo Set MAC address in NVS file $NEW_MAC_ADDRESS
calibrator set nvs_mac ./new-nvs.bin $NEW_MAC_ADDRESS
#calibrator set nvs_mac ./new-nvs.bin 08:00:28:00:64:87

echo Remove wl12xx modules
/system/bin/rmmod wl12xx_sdio wl12xx
/system/bin/rmmod wl12xx

echo Copy calibrated NVS file
cat ./new-nvs.bin > /system/etc/firmware/ti-connectivity/wl1271-nvs.bin
/system/bin/insmod /system/lib/modules/wl12xx.ko


