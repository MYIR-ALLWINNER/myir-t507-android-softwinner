# BoardConfig.mk
#
# Product-specific compile-time definitions.
#
# LOCAL_PATH MUST defined in Makefile top location
LOCAL_PATH := $(shell dirname $(lastword $(MAKEFILE_LIST)))

include device/softwinner/mercury-common/BoardConfigCommon.mk
-include device/softwinner/mercury-evb/display.mk

ifeq ($(PRODUCT_BOARD),qa)
    include vendor/aw/public/qatools/BoardConfig.mk
endif

# Enable dex-preoptimization to speed up first boot sequence
#WITH_DEXPREOPT := true
#DONT_DEXPREOPT_PREBUILTS := false

#Reserve0
# if use sunxi dtbo, set this filed, or dont set it
SUNXI_DTBO_FILE := $(call get_display_config,$(DISPLAY_CONFIG_FILE),SUNXI_DTBO_FILE)
DTBO_INDEX := $(call get_display_config,$(DISPLAY_CONFIG_FILE),DTBO_INDEX)
BOARD_ROOT_EXTRA_FOLDERS += Reserve0

BOARD_AVB_ENABLE := true
BOARD_AVB_VBMETA_SYSTEM := system
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 1

BOARD_AVB_VBMETA_VENDOR := vendor
BOARD_AVB_VBMETA_VENDOR_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_VBMETA_VENDOR_ALGORITHM := SHA256_RSA2048
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_VENDOR_ROLLBACK_INDEX_LOCATION := 2

BOARD_PREBUILT_DTBOIMAGE := $(LOCAL_PATH)/dtbo.img
BOARD_DTBOIMG_PARTITION_SIZE := $(call get_partition_size,dtbo,$(PARTITION_CFG_FILE))

BOARD_BOOTIMAGE_PARTITION_SIZE := $(call get_partition_size,boot,$(PARTITION_CFG_FILE))
ifneq ($(PRODUCT_BOARD),qa)
BOARD_KERNEL_CMDLINE += selinux=1 androidboot.selinux=enforcing androidboot.dtbo_idx=$(DTBO_INDEX) androidboot.selinux=permissive
else
BOARD_KERNEL_CMDLINE += selinux=1 androidboot.selinux=permissive androidboot.dtbo_idx=$(DTBO_INDEX) androidboot.selinux=permissive
endif
BOARD_FLASH_BLOCK_SIZE := 4096
BOARD_CACHEIMAGE_PARTITION_SIZE  := $(call get_partition_size,cache, $(PARTITION_CFG_FILE))
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_RECOVERYIMAGE_PARTITION_SIZE := $(call get_partition_size,recovery,$(PARTITION_CFG_FILE))

ifeq ($(PRODUCT_USE_DYNAMIC_PARTITIONS),true)
    BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
    BOARD_SUPER_IMAGE_IN_UPDATE_PACKAGE := true
    BOARD_SUPER_PARTITION_SIZE := $(call get_partition_size,super,$(PARTITION_CFG_FILE))
    BOARD_SUPER_PARTITION_GROUPS := sb
    BOARD_SB_SIZE := $(shell expr $(BOARD_SUPER_PARTITION_SIZE) - 8388608 )
    BOARD_SB_PARTITION_LIST := system vendor product
else
    BOARD_SYSTEMIMAGE_PARTITION_SIZE := $(call get_partition_size,system,$(PARTITION_CFG_FILE))
    BOARD_VENDORIMAGE_PARTITION_SIZE := $(call get_partition_size,vendor,$(PARTITION_CFG_FILE))
    BOARD_PRODUCTIMAGE_PARTITION_SIZE := $(call get_partition_size,product,$(PARTITION_CFG_FILE))
endif

# Enable SquashFS for /system
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_SQUASHFS_COMPRESSOR := lz4
BOARD_SYSTEMIMAGE_SQUASHFS_BLOCK_SIZE := 65536
BOARD_SYSTEMIMAGE_SQUASHFS_COMPRESSOR_OPT := -Xhc

# # Enable SquashFS for /vendor
BOARD_USES_VENDORIMAGE := true
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_SQUASHFS_COMPRESSOR :=  lz4
BOARD_VENDORIMAGE_SQUASHFS_BLOCK_SIZE := 65536
BOARD_VENDORIMAGE_SQUASHFS_COMPRESSOR_OPT := -Xhc
TARGET_COPY_OUT_VENDOR := vendor

#BOARD_USES_METADATA_PARTITION := true

# Build a separate product.img partition
BOARD_USES_PRODUCTIMAGE := true
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_SQUASHFS_COMPRESSOR :=  lz4
BOARD_PRODUCTIMAGE_SQUASHFS_BLOCK_SIZE := 65536
BOARD_PRODUCTIMAGE_SQUASHFS_COMPRESSOR_OPT := -Xhc
TARGET_COPY_OUT_PRODUCT := product

TARGET_USERIMAGES_USE_F2FS := true

BOARD_VNDK_VERSION := current

PRODUCT_PUBLIC_SEPOLICY_DIRS := $(LOCAL_PATH)/sepolicy/public
PRODUCT_PRIVATE_SEPOLICY_DIRS := $(LOCAL_PATH)/sepolicy/private

#time for health alarm
BOARD_PERIODIC_CHORES_INTERVAL_FAST := 86400
BOARD_PERIODIC_CHORES_INTERVAL_SLOW := 86400

# Enable SVELTE malloc
MALLOC_SVELTE := true

# recovery touch high threshold
TARGET_RECOVERY_UI_TOUCH_HIGH_THRESHOLD := 200
# recovery fs table
TARGET_RECOVERY_FSTAB := $(LOCAL_PATH)/fstab.sun50iw9p1

DEVICE_MANIFEST_FILE += $(LOCAL_PATH)/configs/manifest.xml
DEVICE_MATRIX_FILE := $(LOCAL_PATH)/configs/compatibility_matrix.xml

# When PRODUCT_SHIPPING_API_LEVEL >= 27, TARGET_USES_MKE2FS must be true
TARGET_USES_MKE2FS := true

# wifi and bt configuration
# 1. Wifi Configuration for evb
#BOARD_WIFI_VENDOR := realtek
#BOARD_USR_WIFI    := rtl8723ds
#WIFI_DRIVER_MODULE_NAME := "8723ds"
#WIFI_DRIVER_MODULE_PATH := "/vendor/modules/8723ds.ko"
#WIFI_DRIVER_MODULE_ARG  := "ifname=wlan0 if2name=p2p0"

# 1. Wifi Configuration for myd-yt507
BOARD_WIFI_VENDOR := broadcom
BOARD_USR_WIFI    := ap6212a
WIFI_DRIVER_MODULE_NAME := "bcmdhd"
WIFI_DRIVER_MODULE_PATH := "/vendor/modules/bcmdhd.ko"
WIFI_DRIVER_MODULE_ARG  := "ifname=wlan0 if2name=p2p0"


# 2. Bluetooth Configuration for evb
#BOARD_BLUETOOTH_VENDOR  := realtek
#BOARD_HAVE_BLUETOOTH_NAME := rtl8723ds
# 2. Bluetooth Configuration for evb
BOARD_BLUETOOTH_VENDOR  := broadcom
BOARD_HAVE_BLUETOOTH_NAME := ap6212a



# sensor
SW_BOARD_USES_SENSORS_TYPE := aw
