include device/softwinner/mercury-evb/device_common.mk
include device/softwinner/mercury-evb/display.mk

LOCAL_PATH := $(shell dirname $(lastword $(MAKEFILE_LIST)))
# touchscreen
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    sys.touchscreen.module=$(call get_display_config,$(DISPLAY_CONFIG_FILE),TOUCHSCREEN_MODULE) \
    persist.camera.count=2 \
    persist.camera.0.index=0 \
    persist.camera.0.faceing=0 \
    persist.camera.0.previewsize=1920x1080,1280x720,640x480 \
    persist.camera.0.defaultpreviewsize=1280x720 \
    persist.camera.0.picturesize=2592x1944,1920x1080,1280x720,640x480 \
    persist.camera.0.defaultpicturesize=1280x720 \
    persist.camera.1.index=2 \
    persist.camera.1.faceing=1 \
    persist.camera.1.previewsize=1920x1080,1280x720,640x480 \
    persist.camera.1.defaultpreviewsize=1280x720 \
    persist.camera.1.picturesize=2592x1944,1920x1080,1280x720,640x480 \
    persist.camera.1.defaultpicturesize=1280x720

PRODUCT_PROPERTY_OVERRIDES := \
	ro.sf.lcd_density=$(call get_display_config,$(DISPLAY_CONFIG_FILE),LCD_DENSITY) \
	$(PRODUCT_PROPERTY_OVERRIDES)


TOUCHSCREEN_IDC := $(call get_display_config,$(DISPLAY_CONFIG_FILE),TOUCHSCREEN_IDC)
ifneq ($(TOUCHSCREEN_IDC),)
ifneq ($(wildcard $(LOCAL_PATH)/touchconfigs/$(TOUCHSCREEN_IDC)),)
PRODUCT_COPY_FILES += \
		$(LOCAL_PATH)/touchconfigs/$(TOUCHSCREEN_IDC):$(TARGET_COPY_OUT_VENDOR)/usr/idc/$(TOUCHSCREEN_IDC) \

else
PRODUCT_COPY_FILES += \
		$(LOCAL_PATH)/touchconfigs/touch_internal.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/$(TOUCHSCREEN_IDC) \

endif
endif

TOUCHSCREEN_ROTATION := $(call get_display_config,$(DISPLAY_CONFIG_FILE),TOUCHSCREEN_ROTATION)
ifneq ($(TOUCHSCREEN_ROTATION),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
	ro.input_flinger.primary_touch.rotation=$(TOUCHSCREEN_ROTATION) \
	persist.camera.count=2 \
	persist.camera.0.index=0 \
	persist.camera.0.faceing=0 \
	persist.camera.0.previewsize=1920x1080,1280x720,640x480 \
	persist.camera.0.defaultpreviewsize=1280x720 \
	persist.camera.0.picturesize=2592x1944,1920x1080,1280x720,640x480 \
	persist.camera.0.defaultpicturesize=1280x720 \
	persist.camera.1.index=2 \
	persist.camera.1.faceing=1 \
	persist.camera.1.previewsize=1920x1080,1280x720,640x480 \
	persist.camera.1.defaultpreviewsize=1280x720 \
	persist.camera.1.picturesize=2592x1944,1920x1080,1280x720,640x480 \
	persist.camera.1.defaultpicturesize=1280x720
endif

PRODUCT_NAME := mercury_evb
# PRODUCT_BOARD must equals the board name in kernel
PRODUCT_BOARD := evb
PRODUCT_MODEL := MYC-YT507H

DE0_TYPE := $(call get_display_config,$(DISPLAY_CONFIG_FILE),DE0_TYPE)
DE1_TYPE := $(call get_display_config,$(DISPLAY_CONFIG_FILE),DE1_TYPE)
PRI_DISP_TYPE := $(call get_display_config,$(DISPLAY_CONFIG_FILE),PRI_DISP_TYPE)
SEC_DISP_TYPE := $(call get_display_config,$(DISPLAY_CONFIG_FILE),SEC_DISP_TYPE)
UI_WIDTH := $(call get_display_config,$(DISPLAY_CONFIG_FILE),UI_WIDTH)
UI_HEIGHT := $(call get_display_config,$(DISPLAY_CONFIG_FILE),UI_HEIGHT)

PRODUCT_COPY_FILES += \
	device/softwinner/mercury-evb/tools/boot.mp4:data/boot.mp4
