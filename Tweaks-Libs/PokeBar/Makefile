INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PokeBar

PokeBar_FILES = Tweak.xm
PokeBar_CFLAGS = -fobjc-arc
export ARCHS = arm64e
export SDKVERSION = 13.2
THEOS_DEVICE_IP = iPhone.local

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
