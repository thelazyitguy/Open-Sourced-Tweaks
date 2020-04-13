# Respring on make install
INSTALL_TARGET_PROCESSES = SpringBoard

# Comment this out to enable debug versions
PACKAGE_VERSION=$(THEOS_PACKAGE_BASE_VERSION)

ARCHS = armv6 armv7 arm64 arm64e

# Target iOS 10+ Devices, and use the iOS 11.2 SDK
TARGET = iphone:clang:11.2:10.0

# Declare the location of the (patched) SDK we use
SYSROOT = $(THEOS)/sdks/iPhoneOS11.2.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Pivot

Pivot_FILES = Pivot.xm
Pivot_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += pivotprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
