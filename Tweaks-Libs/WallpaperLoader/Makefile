FINALPACKAGE = 1

TARGET = iphone:clang::13.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WallpaperLoader

WallpaperLoader_FILES = Tweak.x
WallpaperLoader_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
