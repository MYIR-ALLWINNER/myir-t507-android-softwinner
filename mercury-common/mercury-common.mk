# inherit common.mk
$(call inherit-product-if-exists, device/softwinner/common/common.mk)

DEVICE_PACKAGE_OVERLAYS := \
    device/softwinner/mercury-common/overlay \
    $(DEVICE_PACKAGE_OVERLAYS)

PRODUCT_COPY_FILES += \
    device/softwinner/mercury-common/init.sun50iw9p1.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.sun50iw9p1.rc \
    device/softwinner/mercury-common/init.sun50iw9p1.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.sun50iw9p1.usb.rc \
    device/softwinner/mercury-common/ueventd.sun50iw9p1.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc

# display
PRODUCT_COPY_FILES += \
    device/softwinner/mercury-common/init.display.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.display.rc

# video
PRODUCT_COPY_FILES += \
    device/softwinner/mercury-common/configs/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    device/softwinner/mercury-common/configs/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    device/softwinner/mercury-common/configs/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    device/softwinner/mercury-common/configs/mediacodec-arm.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy

USE_XML_AUDIO_POLICY_CONF := 1
PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    device/softwinner/mercury-common/configs/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    device/softwinner/mercury-common/configs/audio_policy_volumes_drc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes_drc.xml \
    device/softwinner/mercury-common/configs/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml \
    hardware/libhardware_legacy/audio/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf \
    device/softwinner/mercury-common/configs/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    device/softwinner/mercury-common/configs/cfg-videoplayer.xml:system/etc/cfg-videoplayer.xml \
    device/softwinner/mercury-common/configs/auto_ahub_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/auto_ahub_paths.xml \
    device/softwinner/mercury-common/configs/auto_codec_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/auto_codec_paths.xml \
    device/softwinner/mercury-common/configs/ac100_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/ac100_paths.xml

# bootanimation
PRODUCT_COPY_FILES += \
    device/softwinner/mercury-common/bootanimation.zip:system/media/bootanimation.zip
    #device/softwinner/mercury-common/boot.mp4:system/media/

# setting default audio output/input
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.audio.output.active=AUDIO_I2S2 \
    vendor.audio.input.active=AUDIO_I2S2

# audio default output standby_ms
#PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
#    ro.audio.flinger_standbytime_ms=50

#usb and backup permissions file
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml

# 131072=opengles 2.0
# 196608=opengles 3.0
# 196609=opengles 3.1
# 196610=opengles 3.2
PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=131072

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.sys.cputype=QuadCore-T507

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.lmk.use_psi=true

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.config.per_app_memcg=false

# Enabling type-precise GC results in larger optimized DEX files.  The
# additional storage requirements for ".odex" files can cause /system
# to overflow on some devices, so this is configured separately for
# each product.
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.product.firmware=T507-Q-v1.0

# if DISPLAY_BUILD_NUMBER := true then
# BUILD_DISPLAY_ID := $(BUILD_ID).$(BUILD_NUMBER)
# required by gms.
#DISPLAY_BUILD_NUMBER := true
#HAS_BUILD_NUMBER := true
#BUILD_NUMBER := $(shell date +%Y%m%d-%H%M%S)

PRODUCT_PROPERTY_OVERRIDES += \
    drm.service.enabled=true

PRODUCT_PACKAGES += \
    MiracastReceiver \
    WallpaperPicker2 \
    ESFileExplorer

PRODUCT_PACKAGES += \
    libwvhidl \
    libwvdrmengine \
    libvtswidevine

PRODUCT_PACKAGES += \
    isomountservice \
    libisomountmanager_jni \
    libisomountmanagerservice

GLOBAL_REMOVED_PACKAGES  += \
    Email \
    Contacts \
    frameworks-base-overlays \
    frameworks-base-overlays-debug

ifeq ($(BOARD_HAS_SECURE_OS), true)
SECURE_OS_OPTEE := yes
PRODUCT_PACKAGES += \
    libteec \
    tee_supplicant

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
	ro.surface_flinger.protected_contents=true

# keymaster version (0 or 2 or 4)
BOARD_KEYMASTER_VERSION := 4
SECURE_OS_SIGN_KEY_VER := 2

ifeq ($(SECURE_OS_SIGN_KEY_VER), 2)
TA_COPY_SUB_DIR = sign_key_v2/
else
TA_COPY_SUB_DIR = ./
endif

# keymaster ta
ifeq ($(BOARD_KEYMASTER_VERSION), 0)
PRODUCT_COPY_FILES += \
    device/softwinner/common/optee_ta/$(TA_COPY_SUB_DIR)/d6bebe60-be3e-4046-b239891e0a594860.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/d6bebe60-be3e-4046-b239891e0a594860.ta
else ifeq ($(BOARD_KEYMASTER_VERSION), 4)
PRODUCT_COPY_FILES += \
    device/softwinner/common/optee_ta/$(TA_COPY_SUB_DIR)/663d017b-102d-4fe0-c086523e1c754846.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/663d017b-102d-4fe0-c086523e1c754846.ta

# keystore algorithm info
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.keystore_desede=true
else
PRODUCT_COPY_FILES += \
    device/softwinner/common/optee_ta/$(TA_COPY_SUB_DIR)/f5f7b549-ba64-44fe-9b74f3fc357c7c61.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/f5f7b549-ba64-44fe-9b74f3fc357c7c61.ta

# hardware keymaster hal
PRODUCT_PACKAGES += \
    keystore.mercury

endif

# gatekeeper ta
PRODUCT_COPY_FILES += \
    device/softwinner/common/optee_ta/$(TA_COPY_SUB_DIR)/2233b43b-cec6-449a-9509469f5023e425.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/2233b43b-cec6-449a-9509469f5023e425.ta

ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL), 1)
PRODUCT_PACKAGES += \
    liboemcrypto
PRODUCT_COPY_FILES += \
    device/softwinner/common/optee_ta/$(TA_COPY_SUB_DIR)/a98befed-d679-ce4a-a3c827dcd51d21ed.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/a98befed-d679-ce4a-a3c827dcd51d21ed.ta \
    device/softwinner/common/optee_ta/$(TA_COPY_SUB_DIR)/4d78d2ea-a631-70fb-aaa787c2b5773052.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/4d78d2ea-a631-70fb-aaa787c2b5773052.ta \
    device/softwinner/common/optee_ta/$(TA_COPY_SUB_DIR)/e41f7029-c73c-344a-8c5bae90c7439a47.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/e41f7029-c73c-344a-8c5bae90c7439a47.ta
endif # ifeq ($(BOARD_WIDEVINE_OEMCRYPTO_LEVEL), 1)

else # ifeq ($(BOARD_HAS_SECURE_OS), true)
SECURE_OS_OPTEE := no
# if has no secure os, widevine level must set to 3
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 3
endif # ifeq ($(BOARD_HAS_SECURE_OS), true)
#playready
BOARD_USE_PLAYREADY := 1
BOARD_PLAYREADY_USE_SECUREOS := 0
BOARD_USE_PLAYREADY_TYPE := 0

ifeq ($(BOARD_USE_PLAYREADY), 1)
BOARD_USE_PLAYREADY_TYPE := 1
PRODUCT_PACKAGES += \
    libplayreadydrmplugin \
    libplayreadypk

PRODUCT_COPY_FILES += \
    hardware/aw/playready/keys/bgroupcert.dat:vendor/etc/playready/bgroupcert.dat \
    hardware/aw/playready/keys/zgpriv_protected.dat:vendor/etc/playready/zgpriv_protected.dat
endif

ifeq ($(BOARD_PLAYREADY_USE_SECUREOS), 1)
BOARD_USE_PLAYREADY_TYPE := 2
PRODUCT_COPY_FILES += \
    device/softwinner/common/optee_ta/b713fbe8-bf5e-2442-83b8c78b53bed4c8.ta:$(TARGET_COPY_OUT_VENDOR)/lib/optee_armtz/b713fbe8-bf5e-2442-83b8c78b53bed4c8.ta
endif

# secure storage support
PRODUCT_PACKAGES += \
    libsst \
    sst_test_v2
# admanager and systemmix
PRODUCT_PACKAGES += \
    libsystemmix_jni \
    systemmixservice \
    libsystemmixservice \
    libsystemmix \
    libadmanager_jni \

# Do not include Makefile before this in the current file, or else the MAKEFILE_LIST will be changed,
# finally resulting in that we get the wrong TARGET_GPU_TYPE
include hardware/aw/gpu/product_config.mk
