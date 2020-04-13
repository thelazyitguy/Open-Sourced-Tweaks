ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Kage

Kage_FILES = Tweak.x
Kage_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += kageprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
