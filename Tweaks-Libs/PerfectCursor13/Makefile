THEOS_DEVICE_IP = iphone
ARCHS = arm64 arm64e
TARGET = iphone:clang:13.2:13.2

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PerfectCursor13
PerfectCursor13_FILES = PerfectCursor13.xm
PerfectCursor13_CFLAGS = -fobjc-arc -Wno-logical-op-parentheses
PerfectCursor13_LIBRARIES = sparkcolourpicker
PerfectCursor13_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk