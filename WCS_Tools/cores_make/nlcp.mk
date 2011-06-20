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

NLCP_RELEASE_VERSION:=r4
#r3-m1-rc5

WL12xx_DIR:=$(WORKSPACE_DIR)/wl12xx
WL12xx_REPO:=git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
WL12xx_HASH:=842de05

COMPAT_DIR:=$(WORKSPACE_DIR)/compat
COMPAT_REPO:=git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git
COMPAT_HASH:=d08656f

COMPAT_WIRELESS_DIR:=$(WORKSPACE_DIR)/compat-wireless-2.6
COMPAT_WIRELESS_REPO:=git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6.git
COMPAT_WIRELESS_HASH:=6f4e670

NLCP_PATCHES_PATH:=$(PATCHES_PATH)/wlan/nlcp
NLCP_WL12xx_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/$(NLCP_RELEASE_VERSION)/wl12xx
NLCP_COMPAT_WIRELESS_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/$(NLCP_RELEASE_VERSION)/compat-wireless-2.6
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
	cd $(WL12xx_DIR) ; git branch "Vanilla" ; git checkout Vanilla
	cd $(WL12xx_DIR) ; git am $(NLCP_WL12xx_PATCHES_DIR)/*patch
	cd $(WL12xx_DIR) ; git commit -a -m "initial modifications for wl12xx R4 release has been made"
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
	cd $(COMPAT_DIR) ; git branch "Vanilla" ; git checkout Vanilla
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
	cd $(COMPAT_WIRELESS_DIR) ; git branch "Vanilla" ; git checkout Vanilla
	cd $(COMPAT_WIRELESS_DIR) ; rm ./patches/03-*
	cd $(COMPAT_WIRELESS_DIR) ; rm ./patches/35-*
	cd $(COMPAT_WIRELESS_DIR) ; rm ./patches/40-*
	cd $(COMPAT_WIRELESS_DIR) ; patch --dry-run -p1 < $(NLCP_COMPAT_WIRELESS_PATCHES_DIR)/compat-wireless.09.patch
	cd $(COMPAT_WIRELESS_DIR) ; patch -p1 < $(NLCP_COMPAT_WIRELESS_PATCHES_DIR)/compat-wireless.09.patch
	cp $(KERNEL_DIR)/.gitignore $(COMPAT_WIRELESS_DIR)
	cd $(COMPAT_WIRELESS_DIR) ; git add .
	cd $(COMPAT_WIRELESS_DIR) ; git commit -a -m "initial modifications for wl12xx R4 release has been made"
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
	cd $(MYDROID)/hardware/libhardware_legacy ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/hardware.libhardware_legacy/0001-Revert*
	cd $(MYDROID)/system/core ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.core/0001*
	cd $(MYDROID)/system/core ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.core/0002*
	cd $(MYDROID)/system/core ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.core/0003-revert-android-dhcp-service-name-device-name-usage.patch
	cd $(MYDROID)/system/netd ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0001*
	cd $(MYDROID)/system/netd ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0002*
	cd $(MYDROID)/system/netd ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0003*
	cd $(MYDROID)/system/netd ; $(PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0004*
	@$(ECHO) "...done"
	
	@$(ECHO) "copying additional packages to mydroid directory..."
	if [ -d $(MYDROID)/external/crda ] ; then $(MOVE) $(MYDROID)/external/crda.org ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/external/crda $(MYDROID)/external/crda
	if [ -d $(MYDROID)/external/hostap ] ; then $(MOVE) $(MYDROID)/external/hostap.org ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/external/hostap $(MYDROID)/external/hostap
	if [ -d $(MYDROID)/external/iw ] ; then $(MOVE) $(MYDROID)/external/iw.org ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/external/iw $(MYDROID)/external/iw
	if [ -d $(MYDROID)/external/libnl ] ; then $(MOVE) $(MYDROID)/external/libnl.org ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/external/libnl $(MYDROID)/external/libnl
	if [ -d $(MYDROID)/external/ti-utils ] ; then $(MOVE) $(MYDROID)/external/ti-utils.org ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/external/ti-utils $(MYDROID)/external/ti-utils
	$(MKDIR) -p $(MYDROID)/hardware/wlan
	if [ -f $(MYDROID)/hardware/wlan/Android.mk ] ; then $(MOVE) $(MYDROID)/hardware/wlan/Android.mk $(MYDROID)/hardware/wlan/Android.mk.org ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/Android.mk $(MYDROID)/hardware/wlan/Android.mk
	if [ -d $(MYDROID)/hardware/wlan/fw ] ; then $(MOVE) $(MYDROID)/hardware/wlan/fw $(MYDROID)/hardware/wlan/fw.org ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/fw $(MYDROID)/hardware/wlan/fw
	if [ -d $(MYDROID)/hardware/wlan/initial_regdom ] ; then $(MOVE) $(MYDROID)/hardware/wlan/initial_regdom $(MYDROID)/hardware/wlan/initial_regdom.org ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/initial_regdom $(MYDROID)/hardware/wlan/initial_regdom
	if [ -d $(MYDROID)/hardware/wlan/wifi_conf ] ; then $(MOVE) $(MYDROID)/hardware/wlan/wifi_conf $(MYDROID)/hardware/wlan/wifi_conf.org ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/wifi_conf $(MYDROID)/hardware/wlan/wifi_conf
	if [ -d $(MYDROID)/hardware/wlan/wpa_supplicant_lib ] ; then $(MOVE) $(MYDROID)/hardware/wlan/wpa_supplicant_lib $(MYDROID)/hardware/wlan/wpa_supplicant_lib.org ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/wpa_supplicant_lib $(MYDROID)/hardware/wlan/wpa_supplicant_lib
	if [ -d $(MYDROID)/hardware/wlan/compat ] ; then $(MOVE) $(MYDROID)/hardware/wlan/compat $(MYDROID)/hardware/wlan/compat ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/compat $(MYDROID)/hardware/wlan/compat
	
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
	@$(ECHO) "...done"

	
nlcp-make-private:
	@$(ECHO) "nlcp make..."
	cd $(COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-refresh.sh
	cd $(COMPAT_WIRELESS_DIR) ; ./scripts/driver-select wl12xx
	$(MAKE) -C $(COMPAT_WIRELESS_DIR) KLIB=$(KERNEL_DIR) KLIB_BUILD=$(KERNEL_DIR) -j$(NTHREADS)
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
	$(MAKE) -C $(COMPAT_WIRELESS_DIR) KLIB=$(KERNEL_DIR) KLIB_BUILD=$(KERNEL_DIR) -j$(NTHREADS) clean
	@$(ECHO) "...done"

nlcp-distclean-private:
	@$(ECHO) "nlcp distclean..."
	$(MAKE) $(PROGRESS_NLCP_MYDROID_PATCHES)-distclean
	$(MAKE) $(PROGRESS_NLCP_KERNEL_PATCHES)-distclean
#	cd $(WL12xx_DIR) ; git reset --hard $(WL12xx_HASH)
#	cd $(COMPAT_DIR) ; git reset --hard $(COMPAT_HASH)
#	cd $(COMPAT_WIRELESS_DIR) ; git reset --hard $(COMPAT_WIRELESS_HASH)
	@$(ECHO) "removing wl12xx..."
	$(DEL) -rf $(WL12xx_DIR) $(PROGRESS_NLCP_FETCH_WL12xx) $(PROGRESS_NLCP_BRINGUP_WL12xx)
	@$(ECHO) "...done"
	@$(ECHO) "removing compat..."
	$(DEL) -rf $(COMPAT_DIR) $(PROGRESS_NLCP_FETCH_COMPAT) $(PROGRESS_NLCP_BRINGUP_COMPAT)
	@$(ECHO) "...done"	
	@$(ECHO) "removing compat wireless..."
	$(DEL) -rf $(COMPAT_WIRELESS_DIR) $(PROGRESS_NLCP_FETCH_COMPAT_WIRELESS) $(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS)
	@$(ECHO) "...done"
	@$(call print, "nlcp removed from workspace")

$(PROGRESS_NLCP_KERNEL_PATCHES)-distclean: $(PROGRESS_NLCP_KERNEL_PATCHES)
	@$(ECHO) "removing nlcp support from kernel..."
	cd $(KERNEL_DIR) ; $(REM_PATCH) -p1 < $(NLCP_KERNEL_PATCHES)/L27.INC1.13.1.kernel-config.nlcp-r3-rc5.patch
	cd $(KERNEL_DIR) ; $(REM_PATCH) -p1 < $(NLCP_KERNEL_PATCHES)/L27.INC1.13.1.kernel.nlcp-r3-rc5.patch
	@$(ECHO) "...done"
	@$(DEL) $(PROGRESS_NLCP_KERNEL_PATCHES)
	@$(call print, "nlcp kernel patches removed")

$(PROGRESS_NLCP_MYDROID_PATCHES)-distclean: $(PROGRESS_NLCP_MYDROID_PATCHES)
	@$(ECHO) "removing nlcp support from android..."
	cd $(MYDROID)/system/netd ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0004*
	cd $(MYDROID)/system/netd ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0003*
	cd $(MYDROID)/system/netd ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0002*
	cd $(MYDROID)/system/netd ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.netd/0001*
	cd $(MYDROID)/system/core ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.core/0003-revert-android-dhcp-service-name-device-name-usage.patch
	cd $(MYDROID)/system/core ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.core/0002*
	cd $(MYDROID)/system/core ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/system.core/0001*
	cd $(MYDROID)/hardware/libhardware_legacy ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/hardware.libhardware_legacy/0001-Revert*
	cd $(MYDROID)/frameworks/base ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/frameworks.base/0002*
	cd $(MYDROID)/frameworks/base ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/frameworks.base/0001*
	cd $(MYDROID)/external/wpa_supplicant_6 ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/external.wpa_supplicant_6/*
	cd $(MYDROID)/external/openssl ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/external.openssl/*
	cd $(MYDROID)/external/hostapd ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/external.hostapd/*
	cd $(MYDROID)/device/ti/blaze ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/device.ti.blaze/*
	cd $(MYDROID)/build ; $(REM_PATCH) -p1 < $(NLCP_ANDROID_PATCHES)/build/*	
	@$(ECHO) "...done"	
	@$(ECHO) "removing additional packages from mydroid directory..."
	$(DEL) -rf $(MYDROID)/external/crda
	if [ -d $(MYDROID)/external/crda.org ] ; then $(MOVE) $(MYDROID)/external/crda.org $(MYDROID)/external/crda ; fi	
	$(DEL) -rf $(MYDROID)/external/hostap
	if [ -d $(MYDROID)/external/hostap.org ] ; then $(MOVE) $(MYDROID)/external/hostap.org $(MYDROID)/external/hostap ; fi
	$(DEL) -rf $(MYDROID)/external/iw
	if [ -d $(MYDROID)/external/iw.org ] ; then $(MOVE) $(MYDROID)/external/iw.org $(MYDROID)/external/iw ; fi	
	$(DEL) -rf $(MYDROID)/external/libnl
	if [ -d $(MYDROID)/external/libnl.org ] ; then $(MOVE) $(MYDROID)/external/libnl.org $(MYDROID)/external/libnl ; fi
	$(DEL) -rf $(MYDROID)/external/ti-utils
	if [ -d $(MYDROID)/external/ti-utils.org ] ; then $(MOVE) $(MYDROID)/external/ti-utils.org $(MYDROID)/external/ti-utils ; fi
	$(MKDIR) -p $(MYDROID)/hardware/wlan
	$(DEL) -rf $(MYDROID)/hardware/wlan/Android.mk
	if [ -f $(MYDROID)/hardware/wlan/Android.mk.org ] ; then $(MOVE) $(MYDROID)/hardware/wlan/Android.mk.org $(MYDROID)/hardware/wlan/Android.mk ; fi
	$(DEL) -rf $(MYDROID)/hardware/wlan/fw
	if [ -d $(MYDROID)/hardware/wlan/fw.org ] ; then $(MOVE) $(MYDROID)/hardware/wlan/fw.org $(MYDROID)/hardware/wlan/fw ; fi
	$(DEL) -rf $(MYDROID)/hardware/wlan/initial_regdom
	if [ -d $(MYDROID)/hardware/wlan/initial_regdom.org ] ; then $(MOVE) $(MYDROID)/hardware/wlan/initial_regdom.org $(MYDROID)/hardware/wlan/initial_regdom ; fi
	$(DEL) -rf $(MYDROID)/hardware/wlan/wifi_conf
	if [ -d $(MYDROID)/hardware/wlan/wifi_conf.org ] ; then $(MOVE) $(MYDROID)/hardware/wlan/wifi_conf.org $(MYDROID)/hardware/wlan/wifi_conf ; fi
	$(DEL) -rf $(MYDROID)/hardware/wlan/wpa_supplicant_lib
	if [ -d $(MYDROID)/hardware/wlan/wpa_supplicant_lib.org ] ; then $(MOVE) $(MYDROID)/hardware/wlan/wpa_supplicant_lib.org $(MYDROID)/hardware/wlan/wpa_supplicant_lib ; fi
	$(DEL) -rf $(MYDROID)/hardware/wlan/compat
	if [ -d $(MYDROID)/hardware/wlan/compat ] ; then $(MOVE) $(MYDROID)/hardware/wlan/compat $(MYDROID)/hardware/wlan/compat ; fi
	@$(ECHO) "...done"
	@$(DEL) $(PROGRESS_NLCP_MYDROID_PATCHES)
	@$(call print, "android patches and packages removed")
