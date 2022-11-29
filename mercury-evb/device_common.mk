# LOCAL_PATH MUST defined in Makefile top location
LOCAL_PATH := $(shell dirname $(lastword $(MAKEFILE_LIST)))

$(call inherit-product, device/softwinner/mercury-common/mercury-common.mk)
$(call inherit-product, $(LOCAL_PATH)/hal.mk)
$(call inherit-product, device/softwinner/common/pad.mk)

ifneq ($(wildcard $(LOCAL_PATH)/modules/modules),)
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(LOCAL_PATH)/modules/modules,$(TARGET_COPY_OUT_VENDOR)/modules)
endif

DEVICE_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlay \
                           $(DEVICE_PACKAGE_OVERLAYS)

# Disable APEX_LIBS_ABSENCE_CHECK
# We got offending entrie if enable check: libicui18n and libicuuc.
# Both are dependencies of libcedarx. We must fix the dependencies and then enable check.
DISABLE_APEX_LIBS_ABSENCE_CHECK := true

# build & split configs
PRODUCT_ENFORCE_RRO_TARGETS := framework-res
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
PRODUCT_FULL_TREBLE_OVERRIDE := true

PRODUCT_USE_DYNAMIC_PARTITIONS := true

ifeq ($(PRODUCT_USE_DYNAMIC_PARTITIONS),true)
PRODUCT_PACKAGES += \
    fastbootd \
    android.hardware.fastboot@1.0-impl
endif

CONFIG_LOW_RAM_DEVICE := true
ifeq ($(CONFIG_LOW_RAM_DEVICE),true)
    $(call inherit-product, $(LOCAL_PATH)/configs/go/go_base.mk)
    $(call inherit-product, build/target/product/go_defaults.mk)

    DEVICE_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlay_go \
                               $(DEVICE_PACKAGE_OVERLAYS)
    # Strip the local variable table and the local variable type table to reduce
    # the size of the system image. This has no bearing on stack traces, but will
    # leave less information available via JDWP.
    PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

    # Do not generate libartd.
    PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

    # Enable DM file preopting to reduce first boot time
    PRODUCT_DEX_PREOPT_GENERATE_DM_FILES :=true
    PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := verify

    # Reduces GC frequency of foreground apps by 50% (not recommanded for 512M devices)
    PRODUCT_SYSTEM_DEFAULT_PROPERTIES += dalvik.vm.foreground-heap-growth-multiplier=2.0

else # ifeq ($(CONFIG_LOW_RAM_DEVICE),true)
    $(call inherit-product, build/target/product/full_base.mk)

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=8m \
    dalvik.vm.heapgrowthlimit=256m \
    dalvik.vm.heapsize=512m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=8m

endif# ifeq ($(CONFIG_LOW_RAM_DEVICE),true)

# launcher
PRODUCT_PACKAGES += Launcher3QuickStep
# enable property split
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

# set product shipping(first) api level
PRODUCT_SHIPPING_API_LEVEL := 29

# secure config
BOARD_HAS_SECURE_OS := false

# drm config
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 3

# camera hal config
#USE_CAMERA_HAL_3_4 := true
#USE_CAMERA_HAL_1_0 := true
USE_CAMERA_HAL_AUTO_1_0 := true
BV3603D_ENABLE := 1

# dm-verity relative
#$(call inherit-product, build/target/product/verity.mk)
# PRODUCT_SUPPORTS_BOOT_SIGNER must be false,otherwise error will be find when boota check boot partition
#PRODUCT_SUPPORTS_BOOT_SIGNER := false
#PRODUCT_SUPPORTS_VERITY_FEC := false
#PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/by-name/system
#PRODUCT_VENDOR_VERITY_PARTITION := /dev/block/by-name/vendor
#PRODUCT_PACKAGES += \
#    slideshow \
#    verity_warning_images

PRODUCT_PACKAGES += \
    SoundRecorder

PRODUCT_PACKAGES += AllwinnerGmsIntegration

############################# WiFi/Bluetooth Support ############################
include device/softwinner/common/config/wireless/wireless_config.mk

############################# quectel 4g module support #########################
RIL_LIB_BASENAME := libquectel-ril

############################### 3G Dongle Support ###############################
# Radio Packages and Configuration Flie
$(call inherit-product-if-exists, vendor/aw/public/prebuild/lib/librild/radio_common.mk)

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/fstab.sun50iw9p1:$(TARGET_COPY_OUT_RAMDISK)/fstab.sun50iw9p1 \
    $(LOCAL_PATH)/fstab.sun50iw9p1:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.sun50iw9p1

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/kernel:kernel \
    $(LOCAL_PATH)/init.device.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.device.rc \
    $(LOCAL_PATH)/init.recovery.sun50iw9p1.rc:root/init.recovery.sun50iw9p1.rc \
    $(LOCAL_PATH)/modules/modules/gt9xxnew_ts.ko:recovery/root/gt9xxnew_ts.ko

PRODUCT_COPY_FILES += \
    device/softwinner/common/config/tablet_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/camera.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/camera.cfg \
    $(LOCAL_PATH)/configs/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml \
    $(LOCAL_PATH)/configs/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/configs/gsensor.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/gsensor.cfg \
    device/softwinner/common/config/awbms_config:$(TARGET_COPY_OUT_VENDOR)/etc/awbms_config \

PRODUCT_COPY_FILES += \
    hardware/aw/camera/1_0/libstd/libstdc++.so:$(TARGET_COPY_OUT_VENDOR)/lib/libstdc++.so


# preferred activity
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/preferred-apps/custom.xml:system/etc/preferred-apps/custom.xml

ifeq ($(BV3603D_ENABLE), 1)
360_OUT_PATH := out/target/product/mercury-demo/system/etc/aw3603D
$(shell mkdir -p $(360_OUT_PATH))
$(shell cp -rf frameworks/av/services/camera/libcameraservice/awCamera/aw3603D/data/* $(360_OUT_PATH)/)
#PRODUCT_COPY_FILES += \
#    $(call find-copy-subdir-files,*,frameworks/av/services/camera/libcameraservice/awCamera/aw3603D/data,system/etc/aw3603D)
endif

ifeq ($(USE_CAMERA_HAL_AUTO_1_0),true)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*.bmp,frameworks/av/services/camera/libcameraservice/awCamera/water_mark/watermark,system/watermark)
endif
# audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio_mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_mixer_paths.xml \

#lmkd whitelist
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/lmkd_whitelist:$(TARGET_COPY_OUT_SYSTEM)/etc/lmkd_whitelist

PRODUCT_PROPERTY_OVERRIDES += \
    ro.frp.pst=/dev/block/by-name/frp

ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
PRODUCT_DEBUG := false
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.usb.config=adb \
    ro.adb.secure=0
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.adb.secure=1
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=160

ifeq ($(CONFIG_LOW_RAM_DEVICE),true)
# limit dex2oat threads to improve thermals
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.boot-dex2oat-threads=4 \
    dalvik.vm.dex2oat-threads=3 \
    dalvik.vm.image-dex2oat-threads=4

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat-flags=--no-watch-dog \
    dalvik.vm.jit.codecachesize=0

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=8m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=8m
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.lmk.use_new_strategy=false \
    ro.lmk.downgrade_pressure=94 \
    ro.lmk.upgrade_pressure=50

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.timezone=Asia/Shanghai \
    persist.sys.country=US \
    persist.sys.language=en

# stoarge
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.fw.force_adoptable=true

#booevent true=enable bootevent,false=disable bootevent
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.bootevent=true

# for adiantum encryption
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.crypto.fde_algorithm=adiantum \
    ro.crypto.fde_sector_size=4096 \
    ro.crypto.volume.contents_mode=adiantum \
    ro.crypto.volume.filenames_mode=adiantum

# for ota
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.build.version.ota=9.0.1 \
    ro.vendor.sys.ota.license=a468243df01f65575218136bdcc17d47a25ccc96b604d6a6b5d62c5f8c96dde1fcba2e168eab23d8

# display
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.display.smart_backlight=1 \
    persist.display.enhance_mode=0 \

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_AAPT_CONFIG := tvdpi xlarge hdpi xhdpi large mdpi
PRODUCT_AAPT_PREF_CONFIG := mdpi

PRODUCT_BRAND := Allwinner
PRODUCT_DEVICE := mercury-evb
PRODUCT_MANUFACTURER := Allwinner

# config must defined in device special makefile.
# PRODUCT_NAME  := xxxx
# PRODUCT_BOARD := xxxx
# PRODUCT_MODEL := xxxx

$(call inherit-product-if-exists, vendor/aw/public/tool.mk)
