################################################################################
#
#	Makefile for Android project integrated with NLCP/MCP2x
#	Android Version	   	:	L27.INC1.13.1 OMAP4 GingerBread ES2
#	Platform	     	:	Blaze platform es2.2
#	Date				:	May. 2011
#
################################################################################

################################################################################
# WLAN make arguments
################################################################################

wlan-sta-private-pre-bringup-validation:
	@$(ECHO) "wlan station pre-bringup validation passed..."

wlan-sta-bringup-private:
	@$(ECHO) "wlan station bringup..."
	@$(MKDIR) -p $(MYDROID)/hardware/ti/wlan/$(WLAN_PROJ_NAME)
	@$(COPY) -rf $(WLAN_STA_SOURCE_PATH)/WiLink/* $(MYDROID)/hardware/ti/wlan/$(WLAN_PROJ_NAME)
	@echo AAA> $(MYDROID)/hardware/ti/wlan/$(WLAN_PROJ_NAME)/a.o ; find $(MYDROID)/hardware/ti/wlan/$(WLAN_PROJ_NAME) -name *.o | xargs rm
	@cd $(MYDROID)/external/wpa_supplicant_6/wpa_supplicant ; $(PATCH) --dry-run -p1 < $(PATCHES_PATH)/wlan/sta/wpasuppl.patch
	@cd $(MYDROID)/external/wpa_supplicant_6/wpa_supplicant ; $(PATCH) -p1 < $(PATCHES_PATH)/wlan/sta/wpasuppl.patch > /dev/null
	@$(SED) "s:BOARD_WLAN_DEVICE.*\:= wl1283:BOARD_WLAN_DEVICE\:= $(WLAN_PROJ_NAME):" $(MYDROID)/device/ti/blaze/BoardConfig.mk > tmp_con
	@$(COPY) -f tmp_con $(MYDROID)/device/ti/blaze/BoardConfig.mk
	cd $(KERNEL_DIR)/include ; $(LINK) -sf asm-generic asm
	
wlan-sta-make-private:
	@$(ECHO) "wlan station make..."
	@$(MAKE) -C $(MYDROID)/hardware/ti/wlan/$(WLAN_PROJ_NAME)/platforms/os/linux SDIO_TYPE=standard TNETW=1283 USE_ANDROID_APPS_ONLY=y BUILD_LOGGER=n TI_HOST_OS=ANDROID
	
wlan-sta-install-private:
	@$(ECHO) "wlan station install..."
	@$(MKDIR) -p $(MYFS_PATH)/data/misc/wifi
	@$(MKDIR) -p $(MYFS_PATH)/var/run/wpa_supplicant
	@$(MKDIR) -p $(MYFS_PATH)/lib/modules/2.6.35.7-00181-gfe0249b
	@$(COPY) $(MYDROID)/hardware/ti/wlan/$(WLAN_PROJ_NAME)/platforms/os/linux/tiwlan_drv.ko $(MYFS_PATH)/system/etc/wifi
	@$(COPY) $(MYDROID)/hardware/ti/wlan/$(WLAN_PROJ_NAME)/platforms/os/linux/firmware.bin $(MYFS_PATH)/system/etc/wifi
	@$(COPY) $(MYDROID)/hardware/ti/wlan/$(WLAN_PROJ_NAME)/platforms/os/linux/tiwlan_dual.ini $(MYFS_PATH)/system/etc/wifi
	@$(COPY) $(MYDROID)/hardware/ti/wlan/$(WLAN_PROJ_NAME)/platforms/os/linux/tiwlan.ini $(MYFS_PATH)/system/etc/wifi
	
	$(MOVE) $(MYFS_PATH)/system/etc/wifi/tiwlan.ini $(MYFS_PATH)/system/etc/wifi/tiwlan_single.ini
	@$(LINK) -sf tiwlan_dual.ini $(MYFS_PATH)/system/etc/wifi/tiwlan.ini
	@$(LINK) -sf wlan_loader $(MYFS_PATH)/system/bin/tiwlan_loader
	
	$(COPY) -f $(MYDROID)/hardware/ti/wlan/$(WLAN_PROJ_NAME)/config/wpa_supplicant.conf  $(MYFS_PATH)/data/misc/wifi/wpa_supplicant.conf
	
	$(MKDIR) -p $(OUTPUT_PATH)/wlan/sta
	$(COPY) $(MYDROID)/hardware/ti/wlan/$(WLAN_PROJ_NAME)/platforms/os/linux/*Binaries*.tar $(OUTPUT_PATH)/wlan/sta
	
wlan-sta-clean-private:
	@$(ECHO) "wlan station clean..."

wlan-sta-distclean-private:
	@$(ECHO) "wlan station distclean..."
	@$(DEL) -rf $(MYDROID)/hardware/ti/wlan/$(WLAN_PROJ_NAME)
	@$(DEL) -f $(KERNEL_DIR)/include/asm
	cd $(MYDROID)/external/wpa_supplicant_6/wpa_supplicant ; $(REM_PATCH) --dry-run -p1 < $(PATCHES_PATH)/wlan/sta/wpasuppl.patch
	cd $(MYDROID)/external/wpa_supplicant_6/wpa_supplicant ; $(REM_PATCH) -p1 < $(PATCHES_PATH)/wlan/sta/wpasuppl.patch > /dev/null
	sed "s:BOARD_WLAN_DEVICE.*\:= $(WLAN_PROJ_NAME):BOARD_WLAN_DEVICE\:= wl1283:" $(MYDROID)/device/ti/blaze/BoardConfig.mk > tmp_con
	$(COPY) -f tmp_con $(MYDROID)/device/ti/blaze/BoardConfig.mk


