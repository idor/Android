################################################################################
#
# nlcp.mk
#
# Makefile for Android project integrated with NLCP
#
# Android Version	:	L27.INC1.13.1 OMAP4 GingerBread ES2
# Platform	     	:	Blaze platform es2.2
# Date				:	July 2011
#
# Copyright (C) 2011 Texas Instruments Incorporated - http://www.ti.com/
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
################################################################################
# nlcp make arguments
################################################################################

#include $(PWD)/defs.mk
include defs.mk

NLCP_RELEASE_VERSION:=RLS_R4_10
NLCP_SP_VERSION:=1
NLCP_MAIN_REPO:=git://github.com/idor

WL12xx_REPO:=$(NLCP_MAIN_REPO)/wl12xx.git
WL12xx_DIR:=$(WORKSPACE_DIR)/wl12xx
WL12xx_BRANCH:=R4-kernel-3.0.4
WL12xx_TAG:=a971bbd2d41c5836b8885fff06c16f8ac7102b48

COMPAT_DIR:=$(WORKSPACE_DIR)/compat
COMPAT_REPO:=git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git
COMPAT_HASH:=c03570efe213adbab12e869a2426cf95b6d2b45b
COMPAT_PULL_BRANCH:=linux-3.0.y

COMPAT_WIRELESS_DIR:=$(WORKSPACE_DIR)/compat-wireless
COMPAT_WIRELESS_REPO:=git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless.git
COMPAT_WIRELESS_BRANCH:=linux-3.0.y
COMPAT_WIRELESS_HASH:=
#COMPAT_WIRELESS_DIR:=$(WORKSPACE_DIR)/compat-wireless-2.6
#COMPAT_WIRELESS_REPO:=git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6.git
#COMPAT_WIRELESS_HASH:=6f4e670

NLCP_PATCHES_PATH:=$(PATCHES_PATH)/wlan/nlcp
NLCP_WL12xx_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/r4/wl12xx
NLCP_COMPAT_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/r4/compat
NLCP_COMPAT_WIRELESS_PATCHES_DIR:=$(NLCP_PATCHES_PATH)/r4/compat-wireless
NLCP_KERNEL_PATCHES:=$(NLCP_PATCHES_PATH)/kernel
NLCP_ANDROID_PATCHES:=$(NLCP_PATCHES_PATH)/android

NLCP_BINARIES_PATH=$(NLCP_PATCHES_PATH)/binaries

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
	
nlcp-private-pre-make-validation:
#	cd $(HOSTAP_DIR) ; git checkout hostapd_vanilla
	@$(ECHO) "nlcp pre-make validation passed..."

$(PROGRESS_NLCP_FETCH_WL12xx):
	@$(ECHO) "getting wl12xx repository..."
	git clone $(WL12xx_REPO) $(WL12xx_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_WL12xx))
	@$(call print, "wl12xx repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_WL12xx): $(PROGRESS_NLCP_FETCH_WL12xx)
	@$(ECHO) "wl12xx bringup..."
	cd $(WL12xx_DIR) ; git checkout origin/$(WL12xx_BRANCH) -b $(WL12xx_BRANCH)
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
	cd $(COMPAT_DIR) ; git checkout $(COMPAT_HASH) -b vanilla
	cd $(COMPAT_DIR) ; git pull origin $(COMPAT_PULL_BRANCH)
	$(COPY) $(WL12xx_DIR)/include/linux/if.h $(COMPAT_DIR)/include/linux/if.h
#	cd $(COMPAT_DIR) ; git reset --hard $(COMPAT_HASH)
#	cd $(COMPAT_DIR) ; git checkout -b vanilla
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
	cd $(COMPAT_WIRELESS_DIR) ; git checkout origin/$(COMPAT_WIRELESS_BRANCH) -b $(COMPAT_WIRELESS_BRANCH)
	cd $(COMPAT_WIRELESS_DIR) ; git am $(NLCP_COMPAT_WIRELESS_PATCHES_DIR)/*.patch
	
#	cd $(COMPAT_WIRELESS_DIR) ; git reset --hard $(COMPAT_WIRELESS_HASH)
#	cd $(COMPAT_WIRELESS_DIR) ; git checkout -b vanilla
#	cd $(COMPAT_WIRELESS_DIR) ; rm ./patches/03-*
#	cd $(COMPAT_WIRELESS_DIR) ; rm ./patches/35-*
#	cd $(COMPAT_WIRELESS_DIR) ; rm ./patches/40-*
#	cd $(COMPAT_WIRELESS_DIR) ; $(PATCH) --dry-run -p1 < $(NLCP_COMPAT_WIRELESS_PATCHES_DIR)/compat-wireless.09.patch
#	cd $(COMPAT_WIRELESS_DIR) ; $(PATCH) -p1 < $(NLCP_COMPAT_WIRELESS_PATCHES_DIR)/compat-wireless.09.patch
#	cp $(KERNEL_DIR)/.gitignore $(COMPAT_WIRELESS_DIR)
#	cd $(COMPAT_WIRELESS_DIR) ; git add .
#	cd $(COMPAT_WIRELESS_DIR) ; git commit -a -m "initial modifications for wl12xx R4 release has been made"
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS))
	@$(call print, "compat wireless bringup done")

$(PROGRESS_NLCP_KERNEL_PATCHES): $(PROGRESS_BRINGUP_KERNEL)
	@$(ECHO) "patching kernel for nlcp..."
	cd $(KERNEL_DIR) ; $(PATCH) -p1 --dry-run < $(NLCP_KERNEL_PATCHES)/L27.INC1.13.1.kernel-config.nlcp-r3-rc5.patch
	cd $(KERNEL_DIR) ; $(PATCH) -p1 < $(NLCP_KERNEL_PATCHES)/L27.INC1.13.1.kernel-config.nlcp-r3-rc5.patch
	cd $(KERNEL_DIR) ; git am $(NLCP_KERNEL_PATCHES)/00*
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_KERNEL_PATCHES))
	@$(call print, "nlcp kernel patches done")	
	
HOSTAP_REPO:=$(NLCP_MAIN_REPO)/hostap.git
HOSTAP_DIR:=$(MYDROID)/external/hostap
HOSTAP_BRANCH:=R4.1
HOSTAP_TAG:=$(NLCP_RELEASE_VERSION)

PROGRESS_NLCP_FETCH_HOSTAP:=$(PROGRESS_DIR)/nlcp.hostap.fetched
PROGRESS_NLCP_BRINGUP_HOSTAP:=$(PROGRESS_DIR)/nlcp.hostap.bringup

$(PROGRESS_NLCP_FETCH_HOSTAP): $(PROGRESS_BRINGUP_MYDROID)
	@$(ECHO) "getting hostapd/supplicant repository..."
	if [ -d $(MYDROID)/hostapd ] ; then $(MOVE) $(MYDROID)/hostapd $(TRASH_DIR)/hostapd; fi
	git clone $(HOSTAP_REPO) $(HOSTAP_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_HOSTAP))
	@$(call print, "hostapd/supplicant repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_HOSTAP): $(PROGRESS_NLCP_FETCH_HOSTAP)
	@$(ECHO) "hostapd/supplicant bringup..."
	$(MKDIR) -p $(HOSTAP_DIR)
	cd $(HOSTAP_DIR) ; git checkout remotes/origin/$(HOSTAP_BRANCH) -b $(HOSTAP_BRANCH)
#	cd $(HOSTAP_DIR) ; git reset --hard $(HOSTAP_TAG)
#	cd $(HOSTAP_DIR) ; git commit -a -m "initial modifications for wl12xx R4 release has been made"
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_HOSTAP))
	@$(call print, "hostapd/supplicant bringup done")

IW_REPO:=$(NLCP_MAIN_REPO)/iw.git
IW_DIR:=$(MYDROID)/external/iw
IW_BRANCH:=android
IW_TAG:=$(NLCP_RELEASE_VERSION)

PROGRESS_NLCP_FETCH_IW:=$(PROGRESS_DIR)/nlcp.iw.fetched
PROGRESS_NLCP_BRINGUP_IW:=$(PROGRESS_DIR)/nlcp.iw.bringup

$(PROGRESS_NLCP_FETCH_IW): $(PROGRESS_BRINGUP_MYDROID)
	@$(ECHO) "getting iw repository..."
	if [ -d $(IW_DIR) ] ; then $(MOVE) $(IW_DIR) $(TRASH_DIR)/iw ; fi
	git clone $(IW_REPO) $(IW_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_IW))
	@$(call print, "iw repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_IW): $(PROGRESS_NLCP_FETCH_IW)
	@$(ECHO) "iw bringup..."
	cd $(IW_DIR) ; git checkout $(IW_TAG) -b vanilla
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_IW))
	@$(call print, "iw bringup done")

CRDA_REPO:=$(NLCP_MAIN_REPO)/crda.git
CRDA_DIR:=$(MYDROID)/external/crda
CRDA_BRANCH:=android
CRDA_TAG:=$(NLCP_RELEASE_VERSION)

PROGRESS_NLCP_FETCH_CRDA:=$(PROGRESS_DIR)/nlcp.crda.fetched
PROGRESS_NLCP_BRINGUP_CRDA:=$(PROGRESS_DIR)/nlcp.crda.bringup

$(PROGRESS_NLCP_FETCH_CRDA): $(PROGRESS_BRINGUP_MYDROID)
	@$(ECHO) "getting crda repository..."
	if [ -d $(CRDA_DIR) ] ; then $(MOVE) $(CRDA_DIR) $(TRASH_DIR)/crda ; fi
	git clone $(CRDA_REPO) $(CRDA_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_CRDA))
	@$(call print, "crda repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_CRDA): $(PROGRESS_NLCP_FETCH_CRDA)
	@$(ECHO) "crda bringup..."
	cd $(CRDA_DIR) ; git checkout $(CRDA_TAG) -b vanilla
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_CRDA))
	@$(call print, "crda bringup done")

LIBNL_REPO:=$(NLCP_MAIN_REPO)/libnl.git
LIBNL_DIR:=$(MYDROID)/external/libnl
LIBNL_BRANCH:=libnl_android
LIBNL_TAG:=$(NLCP_RELEASE_VERSION)

PROGRESS_NLCP_FETCH_LIBNL:=$(PROGRESS_DIR)/nlcp.libnl.fetched
PROGRESS_NLCP_BRINGUP_LIBNL:=$(PROGRESS_DIR)/nlcp.libnl.bringup

$(PROGRESS_NLCP_FETCH_LIBNL): $(PROGRESS_BRINGUP_MYDROID)
	@$(ECHO) "getting libnl repository..."
	if [ -d $(LIBNL_DIR) ] ; then $(MOVE) $(LIBNL_DIR) $(TRASH_DIR)/libnl ; fi
	git clone $(LIBNL_REPO) $(LIBNL_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_LIBNL))
	@$(call print, "libnl repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_LIBNL): $(PROGRESS_NLCP_FETCH_LIBNL)
	@$(ECHO) "libnl bringup..."
	cd $(LIBNL_DIR) ; git checkout $(LIBNL_TAG) -b vanilla
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_LIBNL))
	@$(call print, "libnl bringup done")

#OPENSSL_REPO:=$(NLCP_MAIN_REPO)/openssl.git
#OPENSSL_DIR:=$(MYDROID)/external/openssl
#OPENSSL_BRANCH:=openssl_arm
#OPENSSL_TAG:=$(NLCP_RELEASE_VERSION)
#
#PROGRESS_NLCP_FETCH_OPENSSL:=$(PROGRESS_DIR)/nlcp.openssl.fetched
#PROGRESS_NLCP_BRINGUP_OPENSSL:=$(PROGRESS_DIR)/nlcp.openssl.bringup
#
#$(PROGRESS_NLCP_FETCH_OPENSSL): $(PROGRESS_BRINGUP_MYDROID)
#	@$(ECHO) "getting openssl repository..."
#	git clone $(OPENSSL_REPO) $(OPENSSL_DIR)
#	@$(ECHO) "...done"
#	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_OPENSSL))
#	@$(call print, "openssl repository fetched")
#	
#$(PROGRESS_NLCP_BRINGUP_OPENSSL): $(PROGRESS_NLCP_FETCH_OPENSSL)
#	@$(ECHO) "openssl bringup..."
#	cd $(OPENSSL_DIR) ; git checkout $(OPENSSL_TAG) -b vanilla
#	@$(ECHO) "...done"
#	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_OPENSSL))
#	@$(call print, "openssl bringup done")

TI_UTILS_REPO:=$(NLCP_MAIN_REPO)/ti-utils.git
TI_UTILS_DIR:=$(MYDROID)/external/ti-utils
TI_UTILS_BRANCH:=master
TI_UTILS_TAG:=$(NLCP_RELEASE_VERSION)

PROGRESS_NLCP_FETCH_TI_UTILS:=$(PROGRESS_DIR)/nlcp.ti-utils.fetched
PROGRESS_NLCP_BRINGUP_TI_UTILS:=$(PROGRESS_DIR)/nlcp.ti-utils.bringup

$(PROGRESS_NLCP_FETCH_TI_UTILS): $(PROGRESS_BRINGUP_MYDROID)
	@$(ECHO) "getting ti-utils repository..."
	if [ -d $(TI_UTILS_DIR) ] ; then $(MOVE) $(TI_UTILS_DIR) $(TRASH_DIR)/ti-utils ; fi
	git clone $(TI_UTILS_REPO) $(TI_UTILS_DIR)
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_FETCH_TI_UTILS))
	@$(call print, "ti-utils repository fetched")
	
$(PROGRESS_NLCP_BRINGUP_TI_UTILS): $(PROGRESS_NLCP_FETCH_TI_UTILS)
	@$(ECHO) "ti-utils bringup..."
	cd $(TI_UTILS_DIR) ; git checkout $(TI_UTILS_TAG) -b vanilla
	@$(ECHO) "...done"
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_BRINGUP_TI_UTILS))
	@$(call print, "ti-utils bringup done")
	
nlcp-update-firmware-files:			$(PROGRESS_NLCP_BRINGUP_TI_UTILS)
#	latest firmwares are managed at the ti-utils project: mydroid/external/ti-utils/firmware,
#	we move it to the android fw hardware project (which installs it)
	@$(MKDIR) -p $(MYDROID)/hardware/wlan/fw
	@$(ECHO) "Updating latest firmware binaries from ti-utils project..."
	@$(COPY) -f $(TI_UTILS_DIR)/firmware/wl1271-fw-multirole-plt.bin $(MYDROID)/hardware/wlan/fw
	@$(COPY) -f $(TI_UTILS_DIR)/firmware/wl1271-fw-multirole-roc.bin $(MYDROID)/hardware/wlan/fw
	@$(COPY) -f $(TI_UTILS_DIR)/firmware/wl128x-fw-multirole-plt.bin $(MYDROID)/hardware/wlan/fw
	@$(COPY) -f $(TI_UTILS_DIR)/firmware/wl128x-fw-multirole-roc.bin $(MYDROID)/hardware/wlan/fw
	@$(ECHO) "...done"
	
.PHONY += nlcp-update-firmware-files

$(PROGRESS_NLCP_MYDROID_PATCHES): 	$(PROGRESS_BRINGUP_MYDROID) \
									$(PROGRESS_NLCP_BRINGUP_HOSTAP) \
									$(PROGRESS_NLCP_BRINGUP_IW) \
									$(PROGRESS_NLCP_BRINGUP_CRDA) \
									$(PROGRESS_NLCP_BRINGUP_LIBNL) \
									$(PROGRESS_NLCP_BRINGUP_TI_UTILS) \
									$(PROGRESS_NLCP_BRINGUP_WL12xx)
	@$(ECHO) "patching android for nlcp..."
	cd $(MYDROID)/build; 						git am $(NLCP_ANDROID_PATCHES)/build/*
	cd $(MYDROID)/device/ti/blaze; 				git am $(NLCP_ANDROID_PATCHES)/device.ti.blaze/*.patch
	cd $(MYDROID)/external/hostapd; 			git am $(NLCP_ANDROID_PATCHES)/external.hostapd/*.patch
	cd $(MYDROID)/external/openssl; 			git am $(NLCP_ANDROID_PATCHES)/external.openssl/*.patch
	cd $(MYDROID)/external/ti-utils; 			git am $(NLCP_ANDROID_PATCHES)/external.ti-utils/*.patch
	cd $(MYDROID)/external/wpa_supplicant_6; 	git am $(NLCP_ANDROID_PATCHES)/external.wpa_supplicant_6/*.patch
	cd $(MYDROID)/frameworks/base;				git am $(NLCP_ANDROID_PATCHES)/frameworks.base/*.patch
	cd $(MYDROID)/hardware/libhardware_legacy;	git am $(NLCP_ANDROID_PATCHES)/hardware.libhardware_legacy/*.patch
	cd $(MYDROID)/system/core; 					git am $(NLCP_ANDROID_PATCHES)/system.core/*.patch
	cd $(MYDROID)/system/netd; 					git am $(NLCP_ANDROID_PATCHES)/system.netd/*.patch
	@$(ECHO) "...done"
	
	@$(ECHO) "copying additional packages to mydroid directory..."
	$(MKDIR) -p $(TRASH_DIR)/hardware/wlan
	$(MKDIR) -p $(MYDROID)/hardware/wlan
	if [ -f $(MYDROID)/hardware/wlan/Android.mk ] ; then $(MOVE) $(MYDROID)/hardware/wlan/Android.mk $(TRASH_DIR)/hardware/wlan/ ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/Android.mk $(MYDROID)/hardware/wlan/Android.mk		
	if [ -d $(MYDROID)/hardware/wlan/initial_regdom ] ; then $(MOVE) $(MYDROID)/hardware/wlan/initial_regdom $(TRASH_DIR)/hardware/wlan/ ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/initial_regdom $(MYDROID)/hardware/wlan/initial_regdom	
	if [ -d $(MYDROID)/hardware/wlan/wifi_conf ] ; then $(MOVE) $(MYDROID)/hardware/wlan/wifi_conf $(TRASH_DIR)/hardware/wlan/ ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/wifi_conf $(MYDROID)/hardware/wlan/wifi_conf
	@$(ECHO) "...done"
	if [ -d $(MYDROID)/hardware/wlan/fw ] ; then $(MOVE) $(MYDROID)/hardware/wlan/fw $(TRASH_DIR)/hardware/wlan/ ; fi
	$(COPY) -r $(NLCP_ANDROID_PATCHES)/packages/hardware/wlan/fw $(MYDROID)/hardware/wlan/fw
	$(MAKE) nlcp-update-firmware-files
	@$(call echo-to-file, "DONE", $(PROGRESS_NLCP_MYDROID_PATCHES))
	@$(call print, "android patches and packages done")

nlcp-sync-ver-private:	$(PROGRESS_NLCP_BRINGUP_WL12xx) \
						$(PROGRESS_NLCP_KERNEL_PATCHES) \
						$(PROGRESS_NLCP_MYDROID_PATCHES)
	cd $(CRDA_DIR); 	git fetch ; git reset --hard $(NLCP_RELEASE_VERSION)
	cd $(LIBNL_DIR); 	git fetch ; git reset --hard $(NLCP_RELEASE_VERSION)
	cd $(TI_UTILS_DIR); git fetch ; git reset --hard $(NLCP_RELEASE_VERSION)
	cd $(IW_DIR); 		git fetch ; git reset --hard $(NLCP_RELEASE_VERSION)
	cd $(HOSTAP_DIR); 	git fetch ; git reset --hard $(NLCP_RELEASE_VERSION)
	cd $(WL12xx_DIR); 	git fetch ; git reset --hard $(NLCP_RELEASE_VERSION)
	$(MAKE) nlcp-update-firmware-files
	
nlcp-sync-repo-latest:	$(PROGRESS_NLCP_BRINGUP_WL12xx) \
						$(PROGRESS_NLCP_KERNEL_PATCHES) \
						$(PROGRESS_NLCP_MYDROID_PATCHES)
	cd $(CRDA_DIR); 	git fetch origin ; git merge remotes/origin/$(CRDA_BRANCH)
	cd $(LIBNL_DIR); 	git fetch origin ; git merge remotes/origin/$(LIBNL_BRANCH)
	cd $(TI_UTILS_DIR); git fetch origin ; git merge remotes/origin/$(TI_UTILS_BRANCH)
	cd $(IW_DIR); 		git fetch origin ; git merge remotes/origin/$(IW_BRANCH)
	cd $(HOSTAP_DIR); 	git fetch origin ; git merge remotes/origin/$(HOSTAP_BRANCH)
	cd $(WL12xx_DIR); 	git fetch origin ; git merge remotes/origin/$(WL12xx_BRANCH)
	$(MAKE) nlcp-update-firmware-files

nlcp-bringup-private: 	$(PROGRESS_NLCP_BRINGUP_WL12xx) \
						$(PROGRESS_NLCP_BRINGUP_COMPAT) \
						$(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS) \
						$(PROGRESS_NLCP_KERNEL_PATCHES) \
						$(PROGRESS_NLCP_MYDROID_PATCHES)
	@$(ECHO) "nlcp bringup..."
	cd $(COMPAT_WIRELESS_DIR) ; sh ./scripts/admin-refresh.sh
	cd $(COMPAT_WIRELESS_DIR) ; ./scripts/driver-select wl12xx
	@$(ECHO) "...done"

	
nlcp-make-private:		nlcp-update-firmware-files \
						$(PROGRESS_NLCP_BRINGUP_COMPAT) \
						$(PROGRESS_NLCP_BRINGUP_COMPAT_WIRELESS) \
						$(PROGRESS_NLCP_BRINGUP_WL12xx)
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
	@$(ECHO) "patching init.omap4430.rc"
	cd $(MYFS_PATH) ; $(PATCH) -p1 --dry-run < $(NLCP_PATCHES_PATH)/nlcp.init.omap4430.rc.patch
	cd $(MYFS_PATH) ; $(PATCH) -p1 < $(NLCP_PATCHES_PATH)/nlcp.init.omap4430.rc.patch
	@$(ECHO) "copying additinal binaries to file system"
	$(COPY) -rf $(NLCP_BINARIES_PATH)/* $(MYFS_PATH)
	$(CHMOD) -R 777 $(MYFS_PATH)/data/misc/wifi/*
#	@$(ECHO) "copying firmware binaries to file system"
#	$(COPY) -rf $(WL12xx_DIR)/firmware/ti-connectivity/* $(MYFS_PATH)/system/etc/firmware/ti-connectivity
	@$(ECHO) "...done"
	
nlcp-clean-private:
	@$(ECHO) "nlcp clean..."
	$(MAKE) -C $(COMPAT_WIRELESS_DIR) KLIB=$(KERNEL_DIR) KLIB_BUILD=$(KERNEL_DIR) -j$(NTHREADS) clean
	@$(ECHO) "...done"

nlcp-distclean-private:
	@$(ECHO) "nlcp distclean..."
	$(MAKE) $(PROGRESS_NLCP_MYDROID_PATCHES)-distclean
	$(MAKE) $(PROGRESS_NLCP_KERNEL_PATCHES)-distclean
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
	if [ -d $(TRASH_DIR)/crda ] ; $(MOVE) $(TRASH_DIR)/crda $(MYDROID)/external/crda ; fi
	$(DEL) -rf $(MYDROID)/external/hostap
	if [ -d $(TRASH_DIR)/hostapd ] ; $(MOVE) $(TRASH_DIR)/hostapd $(MYDROID)/external/hostapd ; fi
	$(DEL) -rf $(MYDROID)/external/iw
	if [ -d $(TRASH_DIR)/iw ] ; $(MOVE) $(TRASH_DIR)/iw $(MYDROID)/external/iw ; fi
	$(DEL) -rf $(MYDROID)/external/libnl
	if [ -d $(TRASH_DIR)/libnl ] ; $(MOVE) $(TRASH_DIR)/libnl $(MYDROID)/external/libnl ; fi
	$(DEL) -rf $(MYDROID)/external/ti-utils
	if [ -d $(TRASH_DIR)/ti-utils ] ; $(MOVE) $(TRASH_DIR)/ti-utils $(MYDROID)/external/ti-utils ; fi
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
	@$(ECHO) "...done"
	@$(DEL) $(PROGRESS_NLCP_MYDROID_PATCHES)
	@$(call print, "android patches and packages removed")
