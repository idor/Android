################################################################################
#
#	Makefile for Android project integrated with NLCP/MCP2x
#	Android Version	   	:	L27.INC1.13.1 OMAP4 GingerBread ES2
#	Platform	     	:	Blaze platform es2.2
#	Date				:	May. 2011
#
################################################################################

ti-st-private-pre-bringup-validation:
	@$(ECHO) "<<<ST>>> ti-st pre-bringup validation passed..."



ti-st-bringup-private:
	@$(ECHO) "<<<ST>>> ti-st bringup..."


	
ti-st-make-private:
	@$(ECHO) "<ST> ti-st make..."




	
ti-st-install-private:
	@$(ECHO) "<<<ST>>> Modules install..."
#	@$(COPY) -rvf $(KERNEL_DIR)/drivers/misc/ti-st/st_drv.ko $(MYFS_PATH)

	@$(ECHO) "<<<ST>>> Copying gps_drv end other driveres."
	@$(COPY) -rvf $(KERNEL_DIR)/drivers/staging/ti-st/*.ko $(MYFS_PATH)

ifeq ($(CONFIG_BTIPS), y)
	@$(ECHO) "<<<ST>>> ti-hci install."
	@$(COPY) -rvf $(KERNEL_DIR)/drivers/misc/ti-hci/hci_if_drv.ko $(MYFS_PATH)

else
	@$(ECHO) "<<<ST>>> BlueZ IF install."
	@$(COPY) -rvf $(KERNEL_DIR)/drivers/bluetooth/btwilink.ko $(MYFS_PATH)

endif	


	
	
ti-st-clean-private:
	@$(ECHO) "<<<ST>>> ti-st clean..."



ti-st-distclean-private:
	@$(ECHO) "<<<ST>>> ti-st distclean..."
