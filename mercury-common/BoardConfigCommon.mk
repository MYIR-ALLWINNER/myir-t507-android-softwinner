include device/softwinner/common/BoardConfigCommon.mk

TARGET_PLATFORM := auto
TARGET_BOARD_PLATFORM := mercury
TARGET_USE_NEON_OPTIMIZATION := true
$(call soong_config_add,vendor,board,$(TARGET_BOARD_PLATFORM))
$(call soong_config_add,vendor,platform,$(TARGET_PLATFORM))
TARGET_CPU_SMP := true

TARGET_BOARD_CHIP := sun50iw9p1
TARGET_BOARD_IC := t507
TARGET_BOOTLOADER_BOARD_NAME := exdroid
TARGET_BOOTLOADER_NAME := exdroid
TARGET_OTA_RESTORE_BOOT_STORAGE_DATA := true

BOARD_KERNEL_BASE := 0x40000000
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x80000 --ramdisk_offset 0x03000000 --dtb_offset 0x4000000 --header_version 0x2
BOARD_CHARGER_ENABLE_SUSPEND := true

USE_OPENGL_RENDERER := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
TARGET_USES_HWC2 := true
TARGET_GPU_TYPE := mali-g31
USE_IOMMU := true

# Primary Arch
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := cortex-a7
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi

TARGET_USES_64_BIT_BINDER := true
TARGET_SUPPORTS_32_BIT_APPS := true
TARGET_USES_G2D := true
TARGET_USES_DE30 := true

# Only GMS device need to support updatable apex
# Other devices could use flatten apex to get better performance
TARGET_FLATTEN_APEX := true

BOARD_HAS_RK_4G_MODEM ?= true
BOARD_HAVE_DONGLE ?= true

