DEVICE_PACKAGE_OVERLAYS := \
    device/softwinner/common/overlay

PRODUCT_COPY_FILES += \
    device/softwinner/common/init.common.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.common.rc \

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml

#media
$(call inherit-product-if-exists, frameworks/av/media/libcedarc/libcdclist.mk)
$(call inherit-product-if-exists, frameworks/av/media/libcedarx/libcdxlist.mk)

# ota tools
PRODUCT_HOST_PACKAGES += brotli

# This package has no sense, just for remove pre-defined packages in other makefile.
# How to use: Add all packages which needed to remove to GLOBAL_REMOVED_PACKAGES.
PRODUCT_PACKAGES += PackageOverride

# tools
PRODUCT_PACKAGES += \
    mtop \
    preinstall \
    iperf \
    Dialer \
    Camera2 \
    DVR \
    forlinx_adc_test \
    forlinx_evtest_test \
    forlinx_watchdog_test


# build file_contexts.bin for dragonface
PRODUCT_PACKAGES += file_contexts.bin

PRODUCT_CHECK_ELF_FILES := true

# Audio
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.usb.default \
    audio.r_submix.default

# f2fs format tool for recovery
PRODUCT_PACKAGES += mkfs.f2fs

USE_XML_AUDIO_POLICY_CONF := 1

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

# gms express required property
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.base_build=noah

# scense_control
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.p_bootcomplete=true \
    persist.vendor.p_debug=false \
    persist.vendor.p_benchmark=true \
    persist.vendor.p_music=true

# sf control
PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.disable_backpressure=1

TARGET_SYSTEM_PROP := $(TARGET_SYSTEM_PROP) $(LOCAL_PATH)/system.prop

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.strictmode.disable=1

# for debug
PRODUCT_PACKAGES += kmsgd awlogd

PRODUCT_PROPERTY_OVERRIDES += \
    ro.logd.size=524288 \
    ro.logd.size.main=4194304 \
    ro.logd.size.system=1048576 \
    ro.logd.size.crash=4194304 \

ifneq (,$(filter true,$(PRODUCT_DEBUG)))
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.debug.logpersistd=true
endif

# OEM Unlock reporting
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.oem_unlock_supported=1

# bin: busybox and cpu_monitor
$(call inherit-product-if-exists, vendor/aw/public/tool.mk)

#display service
$(call inherit-product-if-exists, vendor/aw/public/package/display/display.mk)

#display hal
$(call inherit-product-if-exists, hardware/aw/display/config.mk)
