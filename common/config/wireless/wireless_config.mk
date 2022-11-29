# Note: Only call this makefile under product path in <device>.mk.
# Need to add in BoardConfig.mk
#
# Wi-Fi:
# BOARD_WIFI_VENDOR := <wifi chip vendor>
# BOARD_USR_WIFI    := <wifi chip name>
# WIFI_DRIVER_MODULE_PATH := <full driver module path with mode name>
# WIFI_DRIVER_MODULE_NAME := <driver modle name in lsmod>
# WIFI_DRIVER_MODULE_ARG  := <args when insmod, optional>
#
# Bluetooth:
# BOARD_BLUETOOTH_VENDOR    := <bluetooth chip vendor>
# BOARD_HAVE_BLUETOOTH_NAME := <bluetooth chip name, optional>

PARENT_MAKEFILE := $(lastword $(PARENT_PRODUCT_FILES))
PRODUCT_PATH    := $(shell dirname $(PARENT_MAKEFILE))
WIRELESS_CONFIG_PATH := device/softwinner/common/config/wireless

include device/softwinner/common/config/vendorcommand.mk

define get_file_config
$(strip \
    $(if $(1),,$(error Parameter 1 config name is empty))
    $(if $(2),,$(error Parameter 2 config file is empty))
    $(eval __local_config := $(shell sed -n '/^\s*$(1)\s*[:?]*=/h;$${x;p}' $(2) 2>/dev/null))
    $(eval __final_config := $(shell echo $(__local_config) | awk -F= '{print $$2}'))
    $(if $(__local_config),$(__final_config),$($(1)))
)
endef

CONFIG_FILE_LIST       := device/softwinner/common/BoardConfigCommon.mk
CONFIG_FILE_LIST       += $(shell sed -n '/^\s*#/d;/BoardConfigCommon.mk/p' $(PRODUCT_PATH)/BoardConfig.mk | awk '{print $$NF}')
CONFIG_FILE_LIST       += $(PRODUCT_PATH)/BoardConfig.mk

TARGET_DEVICE          ?= $(shell basename $(PRODUCT_PATH))
BOARD_WIFI_VENDOR      := $(call get_file_config,BOARD_WIFI_VENDOR,$(CONFIG_FILE_LIST))
BOARD_USR_WIFI         := $(call get_file_config,BOARD_USR_WIFI,$(CONFIG_FILE_LIST))
BOARD_BLUETOOTH_VENDOR := $(call get_file_config,BOARD_BLUETOOTH_VENDOR,$(CONFIG_FILE_LIST))

SUPPORTED_WIFI_VENDOR      := broadcom realtek xradio sprd ssv common
SUPPORTED_BLUETOOTH_VENDOR := broadcom realtek xradio sprd common

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml

ifneq (,$(findstring $(BOARD_WIFI_VENDOR),$(SUPPORTED_WIFI_VENDOR)))
    PRODUCT_PACKAGES += \
        android.hardware.wifi@1.0-service-lazy \
        libwpa_client \
        wpa_supplicant \
        hostapd \
        wificond \
        wifilogd \
        wpa_supplicant.conf

    PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml

    PRODUCT_PROPERTY_OVERRIDES += wifi.interface=wlan0

    DEVICE_MANIFEST_FILE += $(WIRELESS_CONFIG_PATH)/manifest/manifest_wifi.xml

    WPA_SUPPLICANT_VERSION      := VER_0_8_X
    BOARD_WPA_SUPPLICANT_DRIVER := NL80211
    BOARD_HOSTAPD_DRIVER        := NL80211

    ifneq ($(BOARD_WIFI_VENDOR),common)
        PRODUCT_PROPERTY_OVERRIDES += persist.vendor.wlan_vendor=$(BOARD_WIFI_VENDOR)
        PRODUCT_COPY_FILES += $(WIRELESS_CONFIG_PATH)/initrc/init.wireless.wlan.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.wireless.wlan.rc
    endif

    ifeq ($(BOARD_WIFI_VENDOR),broadcom)
        BOARD_WLAN_DEVICE           := bcmdhd
        BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
        BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd
        PRODUCT_PROPERTY_OVERRIDES  += wifi.direct.interface=p2p-dev-wlan0
        $(call inherit-product-if-exists, hardware/aw/wireless/partner/ampak/firmware/device-wlan.mk)
    else ifeq ($(BOARD_WIFI_VENDOR),realtek)
        BOARD_WLAN_DEVICE           := rtl
        BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_rtl
        BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_rtl
        PRODUCT_COPY_FILES += $(call find-copy-subdir-files,"wifi_efuse_*.map",$(PRODUCT_PATH)/configs,$(TARGET_COPY_OUT_VENDOR)/etc/wifi)
        PRODUCT_PROPERTY_OVERRIDES  += wifi.direct.interface=p2p0
        PRODUCT_CFI_INCLUDE_PATHS   += hardware/realtek/wlan/wpa_supplicant_8_lib
        $(call inherit-product-if-exists, hardware/realtek/wlan/config/config.mk)
    else ifeq ($(BOARD_WIFI_VENDOR),xradio)
        BOARD_WLAN_DEVICE           := xradio
        BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_xr
        BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_xr
        PRODUCT_PROPERTY_OVERRIDES  += wifi.direct.interface=p2p-dev-wlan0
        PRODUCT_CFI_INCLUDE_PATHS   += hardware/xradio/wlan/wpa_supplicant_8_lib
        $(call inherit-product-if-exists, hardware/xradio/wlan/kernel-firmware/xradio-wlan.mk)
    else ifeq ($(BOARD_WIFI_VENDOR),sprd)
        BOARD_WLAN_DEVICE           := sprd
        BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_sprd
        BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_sprd
        PRODUCT_PROPERTY_OVERRIDES  += wifi.direct.interface=p2p-dev-wlan0
        PRODUCT_CFI_INCLUDE_PATHS   += hardware/sprd/wlan/wpa_supplicant_8_lib
        $(call inherit-product-if-exists, hardware/sprd/wlan/firmware/$(BOARD_USR_WIFI)/device-sprd.mk)
    else ifeq ($(BOARD_WIFI_VENDOR),ssv)
        BOARD_WLAN_DEVICE           := ssv
        BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_ssv
        BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_ssv
        PRODUCT_PROPERTY_OVERRIDES  += wifi.direct.interface=p2p-dev-wlan0
        PRODUCT_CFI_INCLUDE_PATHS   += hardware/ssv/wlan/wpa_supplicant_8_lib
        $(call inherit-product-if-exists, hardware/ssv/wlan/firmware/$(BOARD_USR_WIFI)/device-ssv.mk)
    else ifeq ($(BOARD_WIFI_VENDOR),common)
        BOARD_WLAN_DEVICE           := common
        BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_common
        BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_common
        PRODUCT_CFI_INCLUDE_PATHS   += hardware/aw/wireless/wlan/wpa_supplicant_8_lib
        $(call inherit-product-if-exists, hardware/aw/wireless/wlan/firmware/firmware.mk)
    endif
endif

ifneq (,$(findstring $(BOARD_BLUETOOTH_VENDOR),$(SUPPORTED_BLUETOOTH_VENDOR)))
    PRODUCT_PACKAGES += \
        android.hardware.bluetooth@1.0-impl \
        android.hardware.bluetooth@1.0-service \
        android.hardware.bluetooth@1.0-service.rc \
        android.hidl.memory@1.0-impl \
        Bluetooth \
        libbt-vendor \
        audio.a2dp.default

    PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
        frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

    PRODUCT_SYSTEM_DEFAULT_PROPERTIES += bluetooth.enable_timeout_ms=8000
    PRODUCT_PROPERTY_OVERRIDES += persist.vendor.bluetooth_port=/dev/ttyS1
    PRODUCT_PROPERTY_OVERRIDES += ro.bt.bdaddr_path=/sys/class/addr_mgt/addr_bt

    DEVICE_MANIFEST_FILE += $(WIRELESS_CONFIG_PATH)/manifest/manifest_bluetooth.xml

    BOARD_HAVE_BLUETOOTH := true
    BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(PRODUCT_PATH)/configs/bluetooth/

    ifneq ($(BOARD_BLUETOOTH_VENDOR),common)
        PRODUCT_PROPERTY_OVERRIDES += persist.vendor.bluetooth_vendor=$(BOARD_BLUETOOTH_VENDOR)
        PRODUCT_COPY_FILES += $(WIRELESS_CONFIG_PATH)/initrc/init.wireless.bluetooth.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.wireless.bluetooth.rc
    endif

    ifeq ($(BOARD_BLUETOOTH_VENDOR),broadcom)
        BOARD_HAVE_BLUETOOTH_BCM := true
        BOARD_CUSTOM_BT_CONFIG := $(PRODUCT_PATH)/configs/bluetooth/vnd_$(TARGET_DEVICE).txt
        PRODUCT_COPY_FILES += $(PRODUCT_PATH)/configs/bluetooth/bt_vendor.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/bt_vendor.conf
        $(call inherit-product-if-exists, hardware/aw/wireless/partner/ampak/firmware/device-bt.mk)
    else ifeq ($(BOARD_BLUETOOTH_VENDOR),realtek)
        BOARD_HAVE_BLUETOOTH_RTK := true
        PRODUCT_COPY_FILES += $(PRODUCT_PATH)/configs/bluetooth/rtkbt.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/rtkbt.conf
        $(call inherit-product-if-exists, hardware/realtek/bluetooth/firmware/rtlbtfw_cfg.mk)
    else ifeq ($(BOARD_BLUETOOTH_VENDOR),xradio)
        BOARD_HAVE_BLUETOOTH_XRADIO := true
        BOARD_CUSTOM_BT_CONFIG := $(PRODUCT_PATH)/configs/bluetooth/vnd_$(TARGET_DEVICE).txt
        PRODUCT_COPY_FILES += $(PRODUCT_PATH)/configs/bluetooth/bt_vendor.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/bt_vendor.conf
        $(call inherit-product-if-exists, hardware/xradio/bt/firmware/xradio-bt.mk)
    else ifeq ($(BOARD_BLUETOOTH_VENDOR),sprd)
        BOARD_HAVE_BLUETOOTH_SPRD := true
        BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(TOP_DIR)hardware/sprd/libbt/conf/sprd/marlin3/include
        $(call inherit-product-if-exists, hardware/sprd/libbt/conf/sprd/runtime/bt_copy_file.mk)
    else ifeq ($(BOARD_BLUETOOTH_VENDOR),common)
        BOARD_HAVE_BLUETOOTH_COMMON := true
        BOARD_CUSTOM_BT_CONFIG := $(PRODUCT_PATH)/configs/bluetooth/vnd_$(TARGET_DEVICE).txt
        PRODUCT_COPY_FILES += $(PRODUCT_PATH)/configs/bluetooth/bt_vendor.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/bt_vendor.conf
        PRODUCT_COPY_FILES += $(PRODUCT_PATH)/configs/bluetooth/rtkbt.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/rtkbt.conf
        PRODUCT_PACKAGES += libbt-xradio libbt-broadcom libbt-realtek libbt-sprd wireless_hwinfo
        $(call inherit-product-if-exists, hardware/aw/wireless/bluetooth/firmware/firmware.mk)
    endif
    $(call soong_config_add,vendor,board_bluetooth_vendor,$(BOARD_BLUETOOTH_VENDOR))
else
    GLOBAL_REMOVED_PACKAGES += Bluetooth
endif

