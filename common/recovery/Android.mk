LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_CLANG := true
LOCAL_CFLAGS += -Wall
ifeq ($(TARGET_OTA_RESTORE_BOOT_STORAGE_DATA), true)
    LOCAL_CPPFLAGS += -DRESTORE_BOOT_STORAGE_DATA=true
else
    LOCAL_CPPFLAGS += -DRESTORE_BOOT_STORAGE_DATA=false
endif
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := librecovery_updater_common
LOCAL_SRC_FILES := \
    recovery_updater.cpp \
    BurnNandBoot.cpp \
    BurnSdBoot.cpp \
    Utils.cpp \

LOCAL_STATIC_LIBRARIES := \
    libbase \
    libziparchive \

LOCAL_C_INCLUDES += bootable/recovery
LOCAL_C_INCLUDES += bootable/recovery/edify/include
LOCAL_C_INCLUDES += bootable/recovery/otautil/include
LOCAL_C_INCLUDES += bootable/recovery/updater/include

include $(BUILD_STATIC_LIBRARY)

