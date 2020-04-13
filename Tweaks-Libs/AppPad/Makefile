ARCHS = armv7 arm64 arm64e
TARGET = iphone:latest:9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppPad

AppPad_FILES = Tweak.x
AppPad_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
