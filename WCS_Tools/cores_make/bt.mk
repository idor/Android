################################################################################
#
#	Makefile for Android project integrated with NLCP/MCP2x
#	Android Version	   	:	L27.INC1.13.1 OMAP4 GingerBread ES2
#	Platform	     	:	Blaze platform es2.2
#	Date				:	May. 2011
#
################################################################################

bt-private-pre-bringup-validation:




bt-bringup-private:

ifeq ($(CONFIG_BTIPS), y)
	@$(ECHO) "<<<BTIPS>>> bt bringup..."
	@$(ECHO) "################################################################################################################################"

	@$(ECHO) "<<<BTIPS>>> Copying HCI driver."
	cp -Rfv $(SNAPSHOT_PATH)/MCP_Common/STK/ti-hci/ $(KERNEL_DIR)/drivers/misc/

	@$(ECHO) "<<<BTIPS>>> Patching /drivers/misc/Makefile"
	@cd $(KERNEL_DIR)/drivers/misc/ ; $(PATCH) -p0 < $(PATCHES_PATH)/BTIPS/drivers_misc_makefile.patch 

	@$(ECHO) "<<<BTIPS>>> Patching /drivers/misc/Kconfig"
	@cd $(KERNEL_DIR)/drivers/misc/ ; $(PATCH) -p0 < $(PATCHES_PATH)/BTIPS/drivers_misc_kconfig.patch 

	@$(ECHO) "<<<BTIPS>>> Patching /drivers/misc/ti-st/st_kim.c"
	@cd $(KERNEL_DIR)/drivers/misc/ti-st/ ; $(PATCH) -p0 < $(PATCHES_PATH)/BTIPS/st_kim_chg_baud_in_bts_fix.patch

	@$(ECHO) "<<<BTIPS>>> Patching UIM."
	@cd $(MYDROID)/hardware/ti/wpan/ti_st/uim-sysfs/ ; $(PATCH) -p0 < $(PATCHES_PATH)/BTIPS/sysfs-uim_add_hci_support.patch

	@$(ECHO) "<<<BTIPS>>> Patching Symb. links"
	@cd $(MYDROID) ; $(PATCH) -p1 < $(SNAPSHOT_PATH)/EBTIPS/adaptors/Android/2.3/_PATCHES/0002-build_with_sym_links.patch

	@$(ECHO) "<<<BTIPS>>> Running mount_view.sh for GB script"
	@cd $(SCRIPT_FOLDER_ROOT)/android_blaze/ ; ./mount_view.sh


	@$(ECHO) "<<<BTIPS>>> Updating .config"
	$(MAKE) -C $(KERNEL_DIR) -j$(NTHREADS) ARCH=arm distclean	
	$(MAKE) -C $(KERNEL_DIR) ARCH=arm $(KERNEL_PLATFORM_CONFIG)


	@$(ECHO) "<<<BTIPS>>> Patching .config for BTIPS HID support & HCI DRV."
	@cd $(KERNEL_DIR) ; $(PATCH) -p0 < $(PATCHES_PATH)/BTIPS/btips_hid_dot_config_plus_hci_support.patch

	@$(ECHO) "<<<BTIPS>>> UPDATING API + buildspec.mk"
	$(COPY) -Rfp $(MYDROID)/device/ti/blaze/buildspec.mk.default $(MYDROID)/buildspec.mk
	$(MAKE) -C $(MYDROID) -j$(NTHREADS) update-api


	@$(ECHO) "<<<BTIPS>>> bt bringup...DONE"
else
	@$(ECHO) "<<<BLUEZ>>> bt bringup..."
	@$(ECHO) "################################################################################################################################"

endif


bt-make-private:

ifeq ($(CONFIG_BTIPS), y)
	@$(ECHO) "<<<BTIPS>>> bt make..."
else
	@$(ECHO) "<<<BLUEZ>>> bt make..."
endif



	
bt-install-private:

	@$(ECHO) "<<<BTIPS>>> & <<<BLUEZ>>> Creating system folders."

	# For both BTIPS & BLUEZ
	@$(MKDIR) -p $(MYFS_PATH)/system/etc/firmware	
	@$(MKDIR) -p $(MYFS_PATH)/tmp	
	@$(MKDIR) -p $(MYFS_PATH)/usr


ifeq ($(CONFIG_BTIPS), y)

	@$(ECHO) "<<<BTIPS>>> bt install..."
	@$(MKDIR) -p $(MYFS_PATH)/data/data/com.ti.fmrxapp
	@$(COPY) -Rvfp $(SCRIPT_FOLDER_ROOT)/android_blaze/fm/presets.txt $(MYFS_PATH)/data/data/com.ti.fmrxapp

	# copy PAN scrips
	@$(ECHO) "<<<BTIPS>>> Copying PAN scripts, configuration and binaries"
	@$(MKDIR) -p $(MYFS_PATH)/data/btips/TI/scripts
	@$(MKDIR) -p $(MYFS_PATH)/var/lib/misc
	@$(MKDIR) -p $(MYFS_PATH)/var/run
	@$(MKDIR) -p $(MYFS_PATH)/system/bin
	@$(COPY) -vf $(SCRIPT_FOLDER_ROOT)/android_blaze/pan/*.sh $(MYFS_PATH)/data/btips/TI/scripts/
	@$(COPY) -vf $(SCRIPT_FOLDER_ROOT)/android_blaze/pan/dnsmasq $(MYFS_PATH)/system/bin/
	@$(COPY) -vf $(SCRIPT_FOLDER_ROOT)/android_blaze/pan/tcpdump $(MYFS_PATH)/system/bin/
	@$(COPY) -vf $(SCRIPT_FOLDER_ROOT)/android_blaze/pan/20-dns.conf $(MYFS_PATH)/system/etc/dhcpcd/dhcpcd-hooks/
	@$(COPY) -vf $(SCRIPT_FOLDER_ROOT)/android_blaze/pan/dhcpcd.conf $(MYFS_PATH)/system/etc/dhcpcd/
	@$(COPY) -vf $(SCRIPT_FOLDER_ROOT)/android_blaze/pan/dnsmasq_gn.conf $(MYFS_PATH)/system/etc/
	@$(COPY) -vf $(SCRIPT_FOLDER_ROOT)/android_blaze/pan/dnsmasq_nap.conf $(MYFS_PATH)/system/etc/

	@$(ECHO) "<<<BTIPS>>> Creating additiolnal folders."
	@$(MKDIR) -p $(MYFS_PATH)/data/btips/TI/BTInitScript
	@$(MKDIR) -p $(MYFS_PATH)/data/btips/TI/opp	
	@$(MKDIR) -p $(MYFS_PATH)/data/btips/TI/ftproot	
	@$(MKDIR) -p $(MYFS_PATH)/data/btips/TI/ftproot_c	
	@$(MKDIR) -p $(MYFS_PATH)/data/btips/TI/images/bip/xml	
	@$(MKDIR) -p $(MYFS_PATH)/data/btips/TI/bip	
	@$(MKDIR) -p $(MYFS_PATH)/data/btips/TI/bpp

	@$(ECHO) "<<<BTIPS>>> Copying BT + FM Init scripts."
	@$(COPY) -Rvf $(SCRIPT_FOLDER_ROOT)/../init_script/android_zoom/* $(MYFS_PATH)/data/btips/TI/BTInitScript/

	@$(ECHO) "<<<BTIPS>>> Modifying init.rc."
	/bin/cat $(INITRC_PATH)/BTIPS.rc.addon >> $(MYFS_PATH)/init.rc

else	

	@$(ECHO) "<<<BLUEZ>>> Copying FM Init scripts."
	@$(COPY) -Rvf $(SCRIPT_FOLDER_ROOT)/../init_script/android_zoom/fm_rx_init_1283.1.bts $(MYFS_PATH)/system/etc/firmware/
	@$(COPY) -Rvf $(SCRIPT_FOLDER_ROOT)/../init_script/android_zoom/fm_rx_init_1283.2.bts $(MYFS_PATH)/system/etc/firmware/
	@$(COPY) -Rvf $(SCRIPT_FOLDER_ROOT)/../init_script/android_zoom/fm_tx_init_1283.1.bts $(MYFS_PATH)/system/etc/firmware/
	@$(COPY) -Rvf $(SCRIPT_FOLDER_ROOT)/../init_script/android_zoom/fm_tx_init_1283.2.bts $(MYFS_PATH)/system/etc/firmware/
	@$(COPY) -Rvf $(SCRIPT_FOLDER_ROOT)/../init_script/android_zoom/fmc_init_1283.1.bts   $(MYFS_PATH)/system/etc/firmware/
	@$(COPY) -Rvf $(SCRIPT_FOLDER_ROOT)/../init_script/android_zoom/fmc_init_1283.2.bts   $(MYFS_PATH)/system/etc/firmware/

	@$(ECHO) "<<<BLUEZ>>> Modifying init.rc."
	/bin/cat $(INITRC_PATH)/BLUEZ.rc.addon >> $(MYFS_PATH)/init.rc

endif

	@$(ECHO) "<<<BTIPS>>> & <<<BLUEZ>>> Copying BT scripts" 
	@$(COPY) -vf $(SCRIPT_FOLDER_ROOT)/../init_script/android_zoom/tiinit_7.2.31.bts $(MYFS_PATH)/system/etc/firmware/TIInit_7.2.31.bts
	@$(COPY) -vf $(SCRIPT_FOLDER_ROOT)/../init_script/android_zoom/tiinit_7.6.15.bts $(MYFS_PATH)/system/etc/firmware/TIInit_7.6.15.bts
	@$(COPY) -vf $(SCRIPT_FOLDER_ROOT)/../init_script/android_zoom/tiinit_10.6.15.bts $(MYFS_PATH)/system/etc/firmware/TIInit_10.6.15.bts


bt-clean-private:

ifeq ($(CONFIG_BTIPS), y)
	@$(ECHO) "<<<BTIPS>>> bt clean..."
else
	@$(ECHO) "<<<BLUEZ>>> bt clean..."
endif




bt-distclean-private:

ifeq ($(CONFIG_BTIPS), y)
	@$(ECHO) "<<<BTIPS>>> bt softap distclean..."
else
	@$(ECHO) "<<<BLUEZ>>> bt softap distclean..."
endif

