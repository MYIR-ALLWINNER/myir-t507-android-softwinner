define soong_config_add
$(strip \
    $(if $(1),,$(error Parameter 1 namespace empty))
    $(if $(2),,$(error Parameter 2 configkey empty))
    $(eval SOONG_CONFIG_NAMESPACES := $(sort $(1) $(SOONG_CONFIG_NAMESPACES)))
    $(eval SOONG_CONFIG_$(1) := $(sort $(2) $(SOONG_CONFIG_$(1))))
    $(eval SOONG_CONFIG_$(1)_$(2) := $(3))
)
endef

# For auto load partition size config
define get_sys_partition_path
$(strip \
    $(if $(wildcard $(TOP_DIR)../*/device/config/chips),
        $(eval __chip_path := $(shell cd $(TOP_DIR)../*/device/config/chips && pwd))
        $(eval __sys_partition_path := $(__chip_path)/$(TARGET_BOARD_IC)/configs/$(PRODUCT_BOARD)/android),
        $(eval __chip_path := $(shell cd $(TOP_DIR)../*/tools/pack/chips && pwd))
        $(eval __sys_partition_path := $(__chip_path)/$(TARGET_BOARD_CHIP)/configs/$(PRODUCT_BOARD))
    )
    $(shell echo $(__sys_partition_path))
)
endef

define get_partition_size
$(strip \
    $(eval __def := $(call get_sys_partition_path)/sys_partition.fex)
    $(if $(strip $(1)),,$(error Parameter 1 partition name empty))
    $(if $(strip $(2)),$(eval __cfg := $(2)),$(eval __cfg := $(__def)))
    $(if $(wildcard $(__cfg)),,$(error Config file $(__cfg) not found))
    $(eval __sectors := $(shell sed -n '/^\s*name\s*=\s*$(1)\s*$$/,/^\s*user_type\s*=/p' $(__cfg) | awk -F= '/size/{print $$2}'))
    $(if $(__sectors),,$(error Cannot find size config for partition $(1)))
    $(shell expr 512 \* $(__sectors))
)
endef
