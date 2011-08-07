################################################################################
#
# defs.mk
#
# Makefile for Android project integrated with NLCP (general definitions)
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
# general project definitions
################################################################################

ifndef DEFS_MK_INCLUDED
DEFS_MK_INCLUDED:=included

VERSION:=L27.INC1.13.1

YOUR_PATH:=$(PWD)
export YOUR_PATH

################################################################################
# specific WIIST definitions
################################################################################

INTERNALS_PATH?=
WIIST_PATH:=$(PWD)/WCS_Tools
PATCHES_PATH:=$(WIIST_PATH)/patches
BINARIES_PATH=$(WIIST_PATH)/binaries
MAKEFILES_PATH:=$(WIIST_PATH)/cores_make
INITRC_PATH:=$(WIIST_PATH)/init.rc
FIRMWARE_PATH:=$(WIIST_PATH)/firmware

################################################################################
# 
################################################################################

TRASH_DIR:=$(PWD)/.trash
WORKSPACE_DIR=$(PWD)/workspace

MANIFEST:=$(WORKSPACE_DIR)/omapmanifest
export MANIFEST

MYDROID:=$(WORKSPACE_DIR)/mydroid
export MYDROID

KERNEL_VERSION:=android-2.6.35
KERNEL_DIR:=$(WORKSPACE_DIR)/kernel/$(KERNEL_VERSION)
UBOOT_DIR:=$(WORKSPACE_DIR)/u-boot
XLOADER_DIR:=$(WORKSPACE_DIR)/x-loader
export KERNEL_DIR

WLAN_PROJ_NAME:=mcp_2.x
HOST_PLATFORM:=sdc4430
export HOST_PLATFORM

JAVA_HOME:=/usr/lib/jvm/java-6-sun
export JAVA_HOME

CROSS_COMPILE:=arm-none-linux-gnueabi-
export CROSS_COMPILE

ARCH=arm
export ARCH

CROSS_COMPILE_PATH:=/apps/android/arm-2010q1
PATH:=$(JAVA_HOME)/bin:$(UBOOT_DIR)/tools:$(CROSS_COMPILE_PATH)/bin:$(PATH)
export PATH

ifndef NTHREADS
NTHREADS:=8
endif

################################################################################
# platform configuration
################################################################################

UBOOT_PLATFORM_CONFIG:=omap4430sdp_config
XLOADER_PLATFORM_CONFIG:=omap4430sdp_config
KERNEL_PLATFORM_CONFIG:=android_4430_defconfig

################################################################################
# output paths
################################################################################

OUTPUT_IMG_DIR=$(MYDROID)/out/target/product/blaze

OUTPUT_PATH:=$(YOUR_PATH)/output
OUTPUT_PATH_SD:=$(OUTPUT_PATH)/sd
MYFS_PATH:=$(OUTPUT_PATH_SD)/rootfs
BOOT_PATH:=$(OUTPUT_PATH_SD)/boot
EMMC_PATH:=$(OUTPUT_PATH)/eMMC

################################################################################
# project configration
################################################################################

CONFIG_NLCP?=y
CONFIG_BT?=y
CONFIG_TIST?=y
CONFIG_FM?=y
CONFIG_GPS?=n

WLAN_STA_SOURCE_PATH?=
WLAN_SOFTAP_SOURCE_PATH?=
# TODO: remove default value for bt/gps/fm source path
BT_SOURCE_PATH?=$(WLAN_STA_SOURCE_PATH)
GPS_SOURCE_PATH?=$(WLAN_STA_SOURCE_PATH)
FM_SOURCE_PATH?=$(WLAN_STA_SOURCE_PATH)

################################################################################
# progress files
################################################################################

PROGRESS_DIR:=$(PWD)/.progress

PROGRESS_FETCH_MANIFEST:=$(PROGRESS_DIR)/manifest.fetched
PROGRESS_FETCH_MYDROID:=$(PROGRESS_DIR)/mydroid.fetched
PROGRESS_FETCH_KERNEL:=$(PROGRESS_DIR)/kernel.fetched
PROGRESS_FETCH_UBOOT:=$(PROGRESS_DIR)/u-boot.fetched
PROGRESS_FETCH_XLOADER:=$(PROGRESS_DIR)/x-loader.fetched

PROGRESS_FETCH_METHOD:=$(PROGRESS_DIR)/bringup-fetch-method

PROGRESS_BRINGUP_MYDROID:=$(PROGRESS_DIR)/mydroid.bringup
PROGRESS_BRINGUP_KERNEL:=$(PROGRESS_DIR)/kernel.bringup
PROGRESS_BRINGUP_UBOOT:=$(PROGRESS_DIR)/u-boot.bringup
PROGRESS_BRINGUP_XLOADER:=$(PROGRESS_DIR)/x-loader.bringup

PROGRESS_BRINGUP_TIST:=$(PROGRESS_DIR)/ti-st.bringup
PROGRESS_BRINGUP_GPS:=$(PROGRESS_DIR)/gps.bringup
PROGRESS_BRINGUP_BT:=$(PROGRESS_DIR)/bt.bringup
PROGRESS_BRINGUP_FM:=$(PROGRESS_DIR)/fm.bringup
PROGRESS_BRINGUP_NLCP:=$(PROGRESS_DIR)/nlcp.bringup

################################################################################
# private progress files
################################################################################




################################################################################
# mount_view exported variables
################################################################################
SNAPSHOT_PATH ?= $(WLAN_STA_SOURCE_PATH)
MCP_SNAPVIEW_ROOT:=$(SNAPSHOT_PATH)/../
ANDROID_HOME:=$(WORKSPACE_DIR)

SCRIPT_FOLDER_ROOT:=$(BINARIES_PATH)/firmware/init_script

export MCP_SNAPVIEW_ROOT
export ANDROID_HOME

# GPS Definitions
MYDROID_PATH:=$(MYDROID)
TEMP_PATH:=$(SNAPSHOT_PATH)
product_tag:=blaze
sd2:=$(MYFS_PATH)

MAKE_PROJECT:=y
export MAKE_PROJECT
export MYDROID_PATH
export TEMP_PATH
export SNAPSHOT_PATH
export MYDROID
export SCRIPT_FOLDER_ROOT
export product_tag
export sd2

endif #DEFS_MK_INCLUDED



