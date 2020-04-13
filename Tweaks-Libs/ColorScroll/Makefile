INSTALL_TARGET_PROCESSES = SpringBoard

export TARGET = iphone:clang:11.2:9.0
export ARCHS = armv7 arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ColorScroll

ColorScroll_FILES = Tweak.xm
ColorScroll_CFLAGS = -fobjc-arc
ColorScroll_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += colorscrollprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
