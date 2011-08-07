################################################################################
#
# gps.mk
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

gps-private-pre-bringup-validation:
	@$(ECHO) "gps pre-bringup validation passed..."

gps-bringup-private:
	@$(ECHO) "gps bringup..."
	
	##### GPS NEW #####
	#Run the part1_GB .sh script (this is located under path GPS_HOSTSW\linux\gps\GB; please note that this will setup also setup the build environment
	$(SNAPSHOT_PATH)/GPS_HOSTSW/linux/gps/GB/part1_GB.sh
	##### GPS NEW END #####
	$(call print, "GPS BRINGUP DONE" )
	
gps-make-private:
	@$(ECHO) "gps make..."
	
gps-install-private:
	@$(ECHO) "gps install..."
	#this will bring all the needed files to [/mydroid/out/target/product/omap4?/root]
	$(SNAPSHOT_PATH)/GPS_HOSTSW/linux/gps/GB/part2_GB.sh
	@$(ECHO) "<<<GPS>>> Modifying init.rc."
	/bin/cat $(INITRC_PATH)/gps.rc.addon >> $(MYFS_PATH)/init.rc
	
gps-clean-private:
	@$(ECHO) "gps clean..."

gps-distclean-private:
	@$(ECHO) "gps distclean..."
