define get_display_config
$(strip \
	$(eval __cfg := $1)
	$(if $(wildcard $(__cfg)),,$(error Display config file $(__cfg) not found))
	$(eval _sectors := $(shell sed -n '/^$2=/p' $(__cfg) | awk -F= '{print $$2}'))
	$(shell echo $(_sectors))
)
endef
