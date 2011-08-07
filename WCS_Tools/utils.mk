################################################################################
#
# utils.mk
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

MAKE_START_TIME:=$(shell echo $$(( $$(date +%s) )))
GET_TIME = $$(date +%s)

# ------------------------------------------------------------------------------
# utilities
# ------------------------------------------------------------------------------

PATCH=patch -N
REM_PATCH=patch -R -N
COPY=/bin/cp
MOVE=/bin/mv
DEL=/bin/rm
LINK=/bin/ln
SYMLINK=/bin/ln -s
CHMOD=/bin/chmod
MKDIR=/bin/mkdir
RMDIR=/bin/rmdir
ECHO=/bin/echo
TAR=/bin/tar
FIND=/usr/bin/find
SED=/bin/sed
MKFS_EXT4=/sbin/mkfs.ext4


# ------------------------------------------------------------------------------
# functions
# ------------------------------------------------------------------------------

print = $(ECHO) -e "\033[7m$1\033[0m"
echo-to-file = $(ECHO) $(1) > $(2)

