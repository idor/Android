LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	reglib.c \
	crda.c \
	keys-ssl.c

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH) \
	external/libnl/include \
	external/openssl/include

LOCAL_CFLAGS := -DUSE_SSL -DPUBKEY_DIR=\"\"

LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES := libnl libcrypto
LOCAL_MODULE := crda

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	reglib.c \
	keys-ssl.c \
	regdbdump.c \
	print-regdom.c

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH) \
	external/libnl/include \
	external/openssl/include

LOCAL_CFLAGS := -DUSE_SSL -DPUBKEY_DIR=\"\"

LOCAL_MODULE_TAGS := optional
LOCAL_SHARED_LIBRARIES := libnl libcrypto
LOCAL_MODULE := regdbdump

include $(BUILD_EXECUTABLE)


include $(CLEAR_VARS)
LOCAL_MODULE_CLASS = FIRMWARE
LOCAL_MODULE := regulatory.bin
LOCAL_MODULE_PATH := $(TARGET_OUT)/lib/crda
LOCAL_SRC_FILES := $(LOCAL_MODULE)
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)
