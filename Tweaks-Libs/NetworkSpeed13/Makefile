THEOS_DEVICE_IP = ipad
ARCHS = arm64 arm64e
TARGET = iphone:clang:13.2:13.2

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk
GO_EASY_ON_ME = 1

TWEAK_NAME = NetworkSpeed13
NetworkSpeed13_FILES = NetworkSpeed13.xm
NetworkSpeed13_CFLAGS = -fobjc-arc -Wno-logical-op-parentheses
NetworkSpeed13_LIBRARIES = sparkcolourpicker
NetworkSpeed13_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk