################################################################################
#
#	Makefile for Android project integrated with NLCP/MCP2x
#	Android Version	   	:	L27.INC1.13.1 OMAP4 GingerBread ES2
#	Platform	     	:	Blaze platform es2.2
#	Date				:	May. 2011
#
################################################################################

SOFTAP_FOLDER_NAME=$(WLAN_PROJ_NAME)_softAP

wlan-softap-private-pre-bringup-validation:
	@$(ECHO) "wlan softap pre-bringup validation passed..."

wlan-softap-bringup-private:
	@$(ECHO) "wlan softap bringup..."
	@$(ECHO) "copying WLAN sources from $(SOFTAP_FOLDER_NAME).."
	@$(MKDIR) -p $(MYDROID)/hardware/ti/wlan/$(SOFTAP_FOLDER_NAME)
	@$(COPY) -rf $(WLAN_SOFTAP_SOURCE_PATH)/WiLink/* $(MYDROID)/hardware/ti/wlan/$(SOFTAP_FOLDER_NAME)
	@echo AAA > $(MYDROID)/hardware/ti/wlan/$(SOFTAP_FOLDER_NAME)/a.o ; $(FIND) $(MYDROID)/hardware/ti/wlan/$(SOFTAP_FOLDER_NAME) -name *.o | xargs rm
	@$(DEL)  -f $(MYDROID)/hardware/ti/wlan/$(SOFTAP_FOLDER_NAME)/CUDK/hostapd/Android.mk
	@$(ECHO) "patching BoardConfig.mk..."
	@$(SED) "s:BOARD_SOFTAP_DEVICE.*\:= wl1283:BOARD_SOFTAP_DEVICE\:= $(WLAN_PROJ_NAME):" $(MYDROID)/device/ti/blaze/BoardConfig.mk > tmp_con
	@$(COPY) -f tmp_con $(MYDROID)/device/ti/blaze/BoardConfig.mk ;
	@$(ECHO) "patching hostapd..."
	@cd $(MYDROID)/external/hostapd ; $(PATCH) --dry-run -p1 < $(PATCHES_PATH)/wlan/softap/hostapd.patch
	@cd $(MYDROID)/external/hostapd ; $(PATCH) -p1 < $(PATCHES_PATH)/wlan/softap/hostapd.patch > /dev/null
	
wlan-softap-make-private:
	@$(ECHO) "wlan softap make..."
	@$(MAKE) -C $(MYDROID)/hardware/ti/wlan/$(SOFTAP_FOLDER_NAME)/platforms/os/linux TI_HOST_OS=ANDROID SDIO_TYPE=standard TNETW=1283 USE_ANDROID_APPS_ONLY=y BUILD_LOGGER=n
	
wlan-softap-install-private:
	@$(ECHO) "wlan softap install..."
	@$(MKDIR) -p $(MYFS_PATH)/system/etc/wifi/softap
	@$(MKDIR) -p $(MYFS_PATH)/tmp
	@$(CHMOD) 777 $(MYFS_PATH)/tmp
	@$(COPY) $(MYDROID)/hardware/ti/wlan/$(SOFTAP_FOLDER_NAME)/platforms/os/linux/tiap_drv.ko $(MYFS_PATH)/system/etc/wifi/softap
	@$(COPY) $(MYDROID)/hardware/ti/wlan/$(SOFTAP_FOLDER_NAME)/platforms/os/linux/firmware_ap.bin $(MYFS_PATH)/system/etc/wifi/softap
	@$(COPY) $(MYDROID)/hardware/ti/wlan/$(SOFTAP_FOLDER_NAME)/platforms/os/linux/tiwlan_dual.ini $(MYFS_PATH)/system/etc/wifi/softap
	@$(COPY) $(MYDROID)/hardware/ti/wlan/$(SOFTAP_FOLDER_NAME)/platforms/os/linux/tiwlan.ini $(MYFS_PATH)/system/etc/wifi/softap
	@$(MOVE) $(MYFS_PATH)/system/etc/wifi/softap/tiwlan.ini $(MYFS_PATH)/system/etc/wifi/softap/tiwlan_single.ini
	@$(LINK) -sf tiwlan_dual.ini $(MYFS_PATH)/system/etc/wifi/softap/tiwlan_ap.ini
	
wlan-softap-clean-private:
	@$(ECHO) "wlan softap clean..."

wlan-softap-distclean-private:
	@$(ECHO) "wlan softap distclean..."
	@$(DEL) -rf $(MYDROID)/hardware/ti/wlan/$(SOFTAP_FOLDER_NAME)
	@$(SED) "s:BOARD_SOFTAP_DEVICE.*\:= $(WLAN_PROJ_NAME):BOARD_SOFTAP_DEVICE\:= wl1283:" $(MYDROID)/device/ti/blaze/BoardConfig.mk > tmp_con
	@$(COPY) -f tmp_con $(MYDROID)/device/ti/blaze/BoardConfig.mk
	@cd $(MYDROID)/external/hostapd ; $(REM_PATCH) --dry-run -p1 < $(PATCHES_PATH)/wlan/softap/hostapd.patch
	@cd $(MYDROID)/external/hostapd ; $(REM_PATCH) -p1 < $(PATCHES_PATH)/wlan/softap/hostapd.patch
	
	
