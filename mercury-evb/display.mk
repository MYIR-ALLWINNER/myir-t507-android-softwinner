-include include device/softwinner/mercury-evb/ConfigCommand.mk
LOCAL_PATH := $(shell dirname $(lastword $(MAKEFILE_LIST)))
# pri_disp+sec_disp
# lvds+hdmi --> lcd_hdmi.cfg
# duallvds+hdmi --> duallvds_hdmi.cfg
# hdmi+lvds --> hdmi_vbyone_lcd.cfg
# hdmi+duallvds --> hdmi_duallvds.cfg
# hdmi+edp --> hdmi_edp.cfg
# edp+hdmi --> edp_hdmi.cfg
# rgb+hdmi --> rgb_hdmi.cfg
# hdmi+rgb --> hdmi_rgb.cfg

#DISPLAY_CONFIG_FILE := $(LOCAL_PATH)/displayConfigs/lcd_hdmi.cfg
DISPLAY_CONFIG_FILE := $(LOCAL_PATH)/displayConfigs/lvds_720p.cfg
