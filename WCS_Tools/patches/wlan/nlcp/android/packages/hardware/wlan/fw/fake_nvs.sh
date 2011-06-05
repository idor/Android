#!/bin/bash

cp wl1271-nvs.bin.sample wl1271-nvs.bin

# fake MAC address in NVS file
dd if=/dev/random of=wl1271-nvs.bin seek=3 bs=1 count=4 conv=notrunc
dd if=/dev/random of=wl1271-nvs.bin seek=10 bs=1 count=1 conv=notrunc

# make sure the MAC is not a multicast MAC (first byte will be 0)
dd if=/dev/zero of=wl1271-nvs.bin seek=11 bs=1 count=1 conv=notrunc
