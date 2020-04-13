THEOS_DEVICE_IP = ipad
ARCHS = arm64 arm64e
TARGET = iphone:clang:13.2:13.2

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk
GO_EASY_ON_ME = 1

TWEAK_NAME = RAMInfo13
RAMInfo13_FILES = RAMInfo13.xm
RAMInfo13_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
RAMInfo13_LIBRARIES = sparkcolourpicker
RAMInfo13_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk