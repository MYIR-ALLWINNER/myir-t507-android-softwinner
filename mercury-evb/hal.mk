
# Gralloc
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.mapper@2.0-impl

# HW Composer
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service \
    hwcomposer.mercury \
    gralloc.mercury
# Audio
PRODUCT_PACKAGES += \
    audio.primary.mercury \
    sound_trigger.primary.mercury \
    android.hardware.audio@2.0-service \
    android.hardware.audio@5.0-impl \
    android.hardware.audio.effect@5.0-impl \
    android.hardware.soundtrigger@2.0-impl

# keymaster HAL
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# CAMERA
ifeq ($(USE_CAMERA_HAL_AUTO_1_0),true)
PRODUCT_PACKAGES += \
    camera.device@1.0-impl \
    android.hardware.camera.provider@2.4-service \
    android.hardware.camera.provider@2.4-impl \
    libcamera \
    libawcamera \
    libAWCamRecorder \
    libawwater_mark \
    camera.mercury
else
PRODUCT_PACKAGES += \
    camera.device@3.2-impl \
    android.hardware.camera.provider@2.4-service-lazy \
    android.hardware.camera.provider@2.4-impl \
    libcamera \
    camera.mercury
endif
# Memtrack
PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    memtrack.mercury \
    memtrack.default

# drm
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service-lazy \
    android.hardware.drm@1.2-service-lazy.widevine \
    android.hardware.drm@1.2-service-lazy.clearkey

# ION
PRODUCT_PACKAGES += \
    libion

# Light Hal
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service-lazy \
    android.hardware.light@2.0-impl \
    lights.mercury

# Sensor 2.0
PRODUCT_PACKAGES += \
    android.hardware.sensors@2.0-service

#power
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-service \
    android.hardware.power@1.0-impl \
    power.mercury

# usb
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

#health
PRODUCT_PACKAGES += \
    android.hardware.health@2.0-service \
    android.hardware.health@2.0-impl
#configstore
PRODUCT_PACKAGES += \
    android.hardware.configstore@1.1-service
