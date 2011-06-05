################################################################################
#
#	Makefile for Android project integrated with NLCP/MCP2x
#	Android Version	   	:	L27.INC1.13.1 OMAP4 GingerBread ES2
#	Platform	     	:	Blaze platform es2.2
#	Date				:	May. 2011
#
################################################################################

# -----------------------------------------------------------------------------
# mydroid repository definitions
# -----------------------------------------------------------------------------
OMAPMANIFEST_REPO = $(GIT_PROTOCOL_PREFIX)git.omapzoom.org/platform/omapmanifest.git
OMAPMANIFEST_TAG = RLS27.13.1_Gingerbread.xml
OMAPMANIFEST_HASH = 

# -----------------------------------------------------------------------------
# kernel repository definitions
# -----------------------------------------------------------------------------
KERNEL_REPO = $(GIT_PROTOCOL_PREFIX)git.omapzoom.org/kernel/omap.git
KERNEL_TAG_HASH = c2573e171d3991810ebe7d933f5646eaaaf019c7

# -----------------------------------------------------------------------------
# x-loader repository definitions
# -----------------------------------------------------------------------------
XLOADER_REPO = $(GIT_PROTOCOL_PREFIX)git.omapzoom.org/repo/x-loader.git
XLOADER_TAG_HASH = 1aee45bbcf4f94cd4558315f5a5464ae33ce84b4

# -----------------------------------------------------------------------------
# u-boot repository definitions
# -----------------------------------------------------------------------------
# Note: 
# L27.INC1.11.1 u-boot release is corrupted - sd card boot is not available,
# we are using an older version 
UBOOT_REPO = $(GIT_PROTOCOL_PREFIX)git.omapzoom.org/repo/u-boot.git
UBOOT_TAG_HASH = bf5e493e24af4cc400eaac23ef428325fb06918c
# release version:
# UBOOT_TAG_HASH = 601ff71c8d46b5e90e13613974a16d10f2006bb3
