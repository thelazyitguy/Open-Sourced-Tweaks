THEOS_DEVICE_IP = iphone
ARCHS = arm64 arm64e
TARGET = iphone:clang:13.2:13.2

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk
GO_EASY_ON_ME = 1

TWEAK_NAME = SunriseSunsetInfo
SunriseSunsetInfo_FILES = SunriseSunsetInfo.xm
SunriseSunsetInfo_CFLAGS = -fobjc-arc -Wno-logical-op-parentheses
SunriseSunsetInfo_LIBRARIES = sparkcolourpicker
SunriseSunsetInfo_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk