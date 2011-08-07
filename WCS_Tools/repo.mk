################################################################################
#
# repo.mk
#
# Makefile for Android project integrated with NLCP
# repositories definitions
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

# -----------------------------------------------------------------------------
# mydroid repository definitions
# -----------------------------------------------------------------------------
OMAPMANIFEST_REPO = git://git.omapzoom.org/platform/omapmanifest.git
OMAPMANIFEST_TAG = RLS27.13.1_Gingerbread.xml
OMAPMANIFEST_HASH = 

# -----------------------------------------------------------------------------
# kernel repository definitions
# -----------------------------------------------------------------------------
KERNEL_REPO = git://git.omapzoom.org/kernel/omap.git
KERNEL_TAG_HASH = c2573e171d3991810ebe7d933f5646eaaaf019c7

# -----------------------------------------------------------------------------
# x-loader repository definitions
# -----------------------------------------------------------------------------
XLOADER_REPO = git://git.omapzoom.org/repo/x-loader.git
XLOADER_TAG_HASH = 1aee45bbcf4f94cd4558315f5a5464ae33ce84b4

# -----------------------------------------------------------------------------
# u-boot repository definitions
# -----------------------------------------------------------------------------
# Note: 
# L27.INC1.11.1 u-boot release is corrupted - sd card boot is not available,
# we are using an older version (L27.INC1.10.1) 
UBOOT_REPO = git://git.omapzoom.org/repo/u-boot.git
UBOOT_TAG_HASH = bf5e493e24af4cc400eaac23ef428325fb06918c
# official release version:
# UBOOT_TAG_HASH = 601ff71c8d46b5e90e13613974a16d10f2006bb3
