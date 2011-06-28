local_target_dir := $(TARGET_OUT)/bin
LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := initial_regdom.sh
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_PATH := $(local_target_dir)
LOCAL_SRC_FILES := $(LOCAL_MODULE)
LOCAL_MODULE_CLASS := SCRIPT
include $(BUILD_PREBUILT)
