THEOS_DEVICE_IP = iphone
ARCHS = arm64 arm64e
TARGET = iphone:clang:13.2:13.2

INSTALL_TARGET_PROCESSES = SpringBoard
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PerfectWidgets13
PerfectWidgets13_FILES = PerfectWidgets13.xm
PerfectWidgets13_CFLAGS = -fobjc-arc
PerfectWidgets13_LIBRARIES = sparkcolourpicker
PerfectWidgets13_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk