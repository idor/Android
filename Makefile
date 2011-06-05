################################################################################
#
#	Makefile for Android project integrated with MCP2.x
#	Android Version	   	:	L27.INC1.13.1 OMAP4 GingerBread ES2
#	Platform	     	:	Blaze platform es2.2
#	Date				:	March. 2011
#
################################################################################

MAKEFLAGS += --no-print-directory
SHELL=/bin/bash

include defs.mk
include $(WIIST_PATH)/utils.mk
include $(WIIST_PATH)/repo.mk

.PHONY: all install clean distclean

bringup:
	@$(MKDIR) -p $(PROGRESS_DIR)
	@$(MAKE) ti-st-pre-bringup-validation
	@$(MAKE) bt-pre-bringup-validation
	@$(MAKE) gps-pre-bringup-validation
	@$(MAKE) fm-pre-bringup-validation
	@$(MAKE) wlan-sta-pre-bringup-validation
	@$(MAKE) wlan-softap-pre-bringup-validation
	
	@$(MAKE) mydroid-bringup
	@$(MAKE) kernel-bringup
	@$(MAKE) u-boot-bringup
	@$(MAKE) x-loader-bringup
	
	@$(MAKE) nlcp-bringup
	@$(MAKE) ti-st-bringup
	@$(MAKE) bt-bringup
	@$(MAKE) gps-bringup
	
	
	@$(MAKE) fm-bringup
	@$(MAKE) wlan-sta-bringup
	@$(MAKE) wlan-softap-bringup
	
	@$(call echo-to-file, "BRINGUP DONE", bringup)
	@$(call print, "BRINGUP DONE")
	@$(call print, "The bringup process took $$(( $(call GET_TIME)-$(MAKE_START_TIME) )) seconds")

all: bringup
	@$(MKDIR) -p $(PROGRESS_DIR)
	@if [ -d $(OUTPUT_PATH) ] ; then $(ECHO) removing $(OUTPUT_PATH) directory ; $(DEL) -rf $(OUTPUT_PATH) ; fi

	$(MAKE) u-boot-make
	$(MAKE) x-loader-make
	$(MAKE) kernel-make
	$(MAKE) mydroid-make

	$(MAKE) nlcp-make	
	$(MAKE) ti-st-make
	$(MAKE) bt-make
	$(MAKE) gps-make
	$(MAKE) fm-make
	$(MAKE) wlan-sta-make
	$(MAKE) wlan-softap-make
	
	@$(call print, "MAKE ALL DONE")
	@$(call print, "The build process took $$(( $(call GET_TIME)-$(MAKE_START_TIME) )) seconds")

install: all
	$(MAKE) install-only
	@$(call print, "The install process took $$(( $(call GET_TIME)-$(MAKE_START_TIME) )) seconds")

install-only:
	@if [ -d $(OUTPUT_PATH) ] ; then $(ECHO) removing $(OUTPUT_PATH) directory ; $(DEL) -rf $(OUTPUT_PATH) ; fi
	@$(MKDIR) -p $(BOOT_PATH)
	@$(MKDIR) -p $(MYFS_PATH)
	@$(MKDIR) -p $(EMMC_PATH)

	$(MAKE) u-boot-install
	$(MAKE) x-loader-install
	$(MAKE) kernel-install
	$(MAKE) mydroid-install
	
	$(MAKE) nlcp-install
	$(MAKE) ti-st-install
	$(MAKE) bt-install
	$(MAKE) gps-install
	$(MAKE) fm-install
	$(MAKE) wlan-sta-install
	$(MAKE) wlan-softap-install

	@cd $(OUTPUT_PATH_SD) ; $(TAR) cf $(OUTPUT_PATH_SD)/$(VERSION).sd.tar *
	
	@$(call print, "INSTALL DONE")
	
$(OUTPUT_PATH_SD)/$(VERSION).sd.tar: install
	
create-images: $(OUTPUT_PATH_SD)/$(VERSION).sd.tar
	

clean: bringup
	@if [ -d $(OUTPUT_PATH) ] ; then $(ECHO) removing $(OUTPUT_PATH) directory ; $(DEL) -rf $(OUTPUT_PATH) ; fi

	$(MAKE) u-boot-clean
	$(MAKE) x-loader-clean
	$(MAKE) kernel-clean
	$(MAKE) mydroid-clean
	
	$(MAKE) ti-st-clean
	$(MAKE) bt-clean
	$(MAKE) gps-clean
	$(MAKE) fm-clean
	$(MAKE) wlan-sta-clean
	$(MAKE) wlan-softap-clean
	
	@$(call print, "CLEAN DONE")
	@$(call print, "The clean process took $$(( $(call GET_TIME)-$(MAKE_START_TIME) )) seconds")
	
distclean:
	@if [ -f bringup ] ; then $(DEL) -rf bringup ; fi
	@if [ -d $(PROGRESS_DIR) ] ; then $(ECHO) removing $(PROGRESS_DIR) directory ; $(DEL) -rf $(PROGRESS_DIR) ; fi
	@if [ -d $(OUTPUT_PATH) ] ; then $(ECHO) removing $(OUTPUT_PATH) directory ; $(DEL) -rf $(OUTPUT_PATH) ; fi
	@if [ -d $(MANIFEST) ] ; then $(ECHO) removing $(MANIFEST) directory ; $(DEL) -rf $(MANIFEST) ; fi
	@if [ -d $(WORKSPACE_DIR) ] ; then $(ECHO) removing $(WORKSPACE_DIR) directory ; $(DEL) -rf $(WORKSPACE_DIR) ; fi
	@$(ECHO) synchronizing...
	@sync
	@$(call print, "DISTCLEAN DONE")
	@$(call print, "The distclean process took $$(( $(call GET_TIME)-$(MAKE_START_TIME) )) seconds")

include $(WIIST_PATH)/rules.mk
include $(WIIST_PATH)/wiist.mk

include $(MAKEFILES_PATH)/ti-st.mk
include $(MAKEFILES_PATH)/bt.mk
include $(MAKEFILES_PATH)/gps.mk
include $(MAKEFILES_PATH)/fm.mk
include $(MAKEFILES_PATH)/wlan_sta.mk
include $(MAKEFILES_PATH)/wlan_softap.mk
include $(MAKEFILES_PATH)/nlcp.mk
