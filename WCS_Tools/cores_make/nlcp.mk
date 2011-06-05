###############################################################################
#
#	Makefile for Android project integrated with NLCP
#	Android Version	   	:	L27.INC1.13.1 OMAP4430 GingerBread ES2.2
#	Platform	     	:	Blaze platform es2.2
#	Date				:	May. 2011
#
###############################################################################

################################################################################
# nlcp make arguments
################################################################################

#include $(PWD)/defs.mk
include defs.mk

NLCP_RELEASE_VERSION:=r3-m1-rc5

WL12xx_DIR:=$(WORKSPACE_DIR)/wl12xx
WL12xx_REPO:=git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
#WL12xx_REPO:=/data/wlan_wcs_android/Android/wl12xx.git
WL12xx_HASH:=842de05

COMPAT_DIR:=$(WORKSPACE_DIR)/compat
COMPAT_REPO:=git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git
COMPAT_HASH:=d08656f

COMPAT_WIRELESS_DIR:=$(WORKSPACE_DIR)/compat-wireless-2.6
COMPAT_WIRELESS_REPO:=git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6.git
COMPAT_WIRELESS_HASH:=6f4e670

NLCP_PATCHES_PATH:=$(PATCHES_PATH)/wlan/nlcp
NLCP_WL12xx_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/$(NLCP_RELEASE_VERSION)/wl12xx
NLCP_KERNEL_PATCHES:=$(NLCP_PATCHES_PATH)/kernel
NLCP_ANDROID_PATCHES:=$(NLCP_PATCHES_PATH)/android

GIT_COMPAT_TREE:=$(COMPAT_DIR)
GIT_TREE:=$(WL12xx_DIR)

PROGRESS_NLCP_FETCH_WL12xx:=$(PROGRESS_DIR)/nlcp.wl12xx.fetched
PROGRESS_NLCP_FETCH_COMPAT:=$(PROGRESS_DIR)/nlcp.compat.fetched
PROGRESS_NLCP_FETCH_COMPAT_WIRELESS:=$(PROGRESS_DIR)/nlcp.compat-wireless.fetched

PROGRESS_NLCP_BRINGUP_WL12xx:=$(PROGRESS_DIR)/nlcp.wl12xx.bringup
PROGRESS_NLCP_BRINGUP_COMPAT:=$(PROGRESS_DIR)/nlcp.compat.bringup
PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS:=$(PROGRESS_DIR)/nlcp.compat-wireless.bringup

PROGRESS_NLCP_KERNEL_PATCHES:=$(PROGRESS_DIR)/nlcp.kernel.patched
PROGRESS_NLCP_MYDROID_PATCHES:=$(PROGRESS_DIR)/nlcp.mydroid.patched

export GIT_COMPAT_TREE
export GIT_TREE

################################################################################
# rules
################################################################################

nlcp-private-pre-bringup-validation:
	@$(ECHO) "nlcp pre-bringup validation passed..."

$(PROGRESS_NLCP_FETCH_WL12xx):
	@$(ECHO) "getting wl12xx repository..."
	git clone $(WL12xx_REPO) $(WL12xx_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_WL12xx))
	@$(call print, "wl12xx repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_WL12xx): $(PROGRESS_NLCP_FETCH_WL12xx)
	@$(ECHO) "wl12xx bringup..."
	cd $(WL12xx_DIR) ; git reset --hard $(WL12xx_HASH)
	cd $(WL12xx_DIR) ; git am $(NLCP_WL12xx_PATCHES_DIR)/*patch
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_WL12xx))
	@$(call print, "wl12xx bringup done")

$(PROGRESS_NLCP_FETCH_COMPAT):
	@$(ECHO) "getting compat repository..."
	git clone $(COMPAT_REPO) $(COMPAT_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_COMPAT))
	@$(call print, "compat repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_COMPAT): $(PROGRESS_NLCP_FETCH_COMPAT)
	@$(ECHO) "compat bringup..."
	cd $(COMPAT_DIR) ; git reset --hard $(COMPAT_HASH)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_COMPAT))
	@$(call print, "compat bringup done")
	
$(PROGRESS_NLCP_FETCH_COMPAT_WIRELESS):
	@$(ECHO) "getting compat wireless repository..."
	git clone $(COMPAT_WIRELESS_REPO) $(COMPAT_WIRELESS_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_COMPAT_WIRELESS))
	@$(call print, "compat wireless repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS): $(PROGRESS_NLCP_FETCH_COMPAT_WIRELESS)
	@$(ECHO) "compat wireless bringup..."
	cd $(COMPAT_WIRELESS_DIR) ; git reset --hard $(COMPAT_WIRELESS_HASH)
	cd $(COMPAT_WIRELESS_DIR) ; rm -rf ./patches/03-*
	cd $(COMPAT_WIRELESS_DIR) ; rm -rf ./patches/35-*
	cd $(COMPAT_WIRELESS_DIR) ; rm -rf ./patches/40-*	
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS))
	@$(call print, "compat wireless bringup done")

$(PROGRESS_NLCP_KERNEL_PATCHES): $(PROGRESS_BRINGUP_KERNEL)
	@$(ECHO) "patching kernel for nlcp..."
	cd $(KERNEL_DIR) ; $(PATCH) -p1 --dry-run < $(NLCP_KERNEL_PATCHES)/L27.INC1.13.1.kernel.nlcp-r3-rc5.patch
	cd $(KERNEL_DIR) ; $(PATCH) -p1 --dry-run < $(NLCP_KERNEL_PATCHES)/L27.INC1.13.1.kernel-config.nlcp-r3-rc5.patch
	cd $(KERNEL_DIR) ; $(PATCH) -p1 < $(NLCP_KERNEL_PATCHES)/L27.INC1.13.1.kernel.nlcp-r3-rc5.patch
	cd $(KERNEL_DIR) ; $(PATCH) -p1 < $(NLCP_KERNEL_PATCHES)/L27.INC1.13.1.kernel-config.nlcp-r3-rc5.patch
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_KERNEL_PATCHES))
	@$(call print, "nlcp kernel patches done")

$(PROGRESS_NLCP_MYDROID_PATCHES): $(PROGRESS_BRINGUP_MYDROID)
	@$(ECHO) "patching android for nlcp..."
	cd $(MYDROID)/build ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/build/*
	cd $(MYDROID)/device/ti/blaze ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/device.ti.blaze/*
	cd $(MYDROID)/external/hostapd ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/external.hostapd/*
	cd $(MYDROID)/external/openssl ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/external.openssl/*
	cd $(MYDROID)/external/wpa_supplicant_6 ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/external.wpa_supplicant_6/*
	cd $(MYDROID)/frameworks/base ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/frameworks.base/0001*
	cd $(MYDROID)/frameworks/base ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/frameworks.base/0002*
# TODO: one more patch is needed - vishal email (?!)
	cd $(MYDROID)/hardware/libhardware_legacy ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/hardware.libhardware_legacy/*
	cd $(MYDROID)/system/core ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.core/0001*
	cd $(MYDROID)/system/core ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.core/0002*
	cd $(MYDROID)/system/core ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.core/0003-revert-android-dhcp-service-name-device-name-usage.patch
	cd $(MYDROID)/system/netd ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0001*
	cd $(MYDROID)/system/netd ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0002*
	cd $(MYDROID)/system/netd ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0003*
	@$(ECHO) "...done"
	@$(ECHO) "copying additional packages to mydroid directory..."
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/external/* $(MYDROID)/external/
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/* $(MYDROID)/hardware/		
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_MYDROID_PATCHES))
	@$(call print, "android patches and packages done")

nlcp-bringup-private: 	$(PROGRESS_NLCP_BRINGUP_WL12xx) \
						$(PROGRESS_NLCP_BRINGUP_COMPAT) \
						$(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS) \
						$(PROGRESS_NLCP_KERNEL_PATCHES) \
						$(PROGRESS_NLCP_MYDROID_PATCHES)
	@$(ECHO) "nlcp bringup..."
	cd $(COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-refresh.sh
	cd $(COMPAT_WIRELESS_DIR) ; ./scripts/driver-select wl12xx
	cp $(KERNEL_DIR)/.gitignore $(COMPAT_WIRELESS_DIR)
	cd $(COMPAT_WIRELESS_DIR) ; git add .
	cd $(COMPAT_WIRELESS_DIR) ; git commit -a -m "Initial"	
	@$(ECHO) "...done"

	
nlcp-make-private:
	@$(ECHO) "nlcp make..."
	$(MAKE) -C $(COMPAT_WIRELESS_DIR) KLIB=$(KERNEL_DIR) KLIB_BUILD=$(KERNEL_DIR)
	@$(ECHO) "...done"
	
nlcp-install-private:
	@$(ECHO) "nlcp install..."
	$(MKDIR) -p $(MYFS_PATH)/system/lib/modules
	@$(ECHO) "copy modules from compat-wireless"
	$(FIND) $(COMPAT_WIRELESS_DIR) -name "*.ko" -exec cp -f {}  $(MYFS_PATH)/system/lib/modules/ \;
	@$(ECHO) "copy modules from kernel"
	$(FIND) $(KERNEL_DIR)/drivers/staging -name "*.ko" -exec cp -v {} $(MYFS_PATH) \;
	@$(ECHO) "copy TQS_D_1.7.ini"
	$(MKDIR) -p $(MYFS_PATH)/data
	$(COPY) $(NLCP_PATCHES_PATH)/TQS_D_1.7.ini $(MYFS_PATH)/data
	@$(ECHO) "patching init.omap4430.rc"
	cd $(MYFS_PATH) ; $(PATCH) -p1 --dry-run < $(NLCP_PATCHES_PATH)/nlcp.init.omap4430.rc.patch
	cd $(MYFS_PATH) ; $(PATCH) -p1 < $(NLCP_PATCHES_PATH)/nlcp.init.omap4430.rc.patch
	@$(ECHO) "...done"
	
nlcp-clean-private:
	@$(ECHO) "nlcp clean..."

nlcp-distclean-private:
	@$(ECHO) "nlcp distclean..."



