################################################################################
#
# fm.mk
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

fm-private-pre-bringup-validation:
	@$(ECHO) "fm pre-bringup validation passed..."

fm-bringup-private:
	@$(ECHO) "fm bringup..."
	
fm-make-private:
	@$(ECHO) "fm make..."
	
fm-install-private:
	@$(MKDIR) -p $(MYFS_PATH)/system/etc/firmware

	@$(ECHO) "<<<BLUEZ>>> Copying FM Init scripts."
	@$(COPY) -vf $(FIRMWARE_PATH)/fm/* $(MYFS_PATH)/system/etc/firmware/
	@$(ECHO) "fm install..."
	
fm-clean-private:
	@$(ECHO) "fm clean..."
	
fm-distclean-private:
	@$(ECHO) "fm distclean..."
