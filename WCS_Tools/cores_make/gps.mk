################################################################################
#
#	Makefile for Android project integrated with NLCP/MCP2x
#	Android Version	   	:	L27.INC1.13.1 OMAP4 GingerBread ES2
#	Platform	     	:	Blaze platform es2.2
#	Date				:	May. 2011
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
