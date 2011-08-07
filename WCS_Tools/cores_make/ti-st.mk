################################################################################
#
# ti-st.mk
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

ti-st-private-pre-bringup-validation:
	@$(ECHO) "<<<ST>>> ti-st pre-bringup validation passed..."

ti-st-bringup-private:
	@$(ECHO) "<<<ST>>> ti-st bringup..."
	
ti-st-make-private:
	@$(ECHO) "<ST> ti-st make..."
	
ti-st-install-private:
	@$(ECHO) "<<<ST>>> Modules install..."
#	@$(COPY) -rvf $(KERNEL_DIR)/drivers/misc/ti-st/st_drv.ko $(MYFS_PATH)

	@$(ECHO) "<<<ST>>> Copying gps_drv end other driveres."
	@$(COPY) -rvf $(KERNEL_DIR)/drivers/staging/ti-st/*.ko $(MYFS_PATH)

	@$(ECHO) "<<<ST>>> BlueZ IF install."
	@$(COPY) -rvf $(KERNEL_DIR)/drivers/bluetooth/btwilink.ko $(MYFS_PATH)	
	
ti-st-clean-private:
	@$(ECHO) "<<<ST>>> ti-st clean..."

ti-st-distclean-private:
	@$(ECHO) "<<<ST>>> ti-st distclean..."
