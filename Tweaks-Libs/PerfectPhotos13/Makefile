THEOS_DEVICE_IP = iphone
ARCHS = arm64 arm64e
TARGET = iphone:clang:13.2:13.2

INSTALL_TARGET_PROCESSES = MobileSlideShow Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PerfectPhotos13
PerfectPhotos13_FILES = PerfectPhotos13.xm
PerfectPhotos13_CFLAGS = -fobjc-arc
PerfectPhotos13_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
