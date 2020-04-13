THEOS_DEVICE_IP = iphone
ARCHS = arm64 arm64e
TARGET = iphone:clang:13.2:13.2

INSTALL_TARGET_PROCESSES = AppStore

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppStoreUpdatesTab13
BUNDLE_NAME = com.johnzaro.AppStoreUpdatesTab13

AppStoreUpdatesTab13_FILES = AppStoreUpdatesTab13.xm
AppStoreUpdatesTab13_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-variable
com.johnzaro.AppStoreUpdatesTab13_INSTALL_PATH = /var/mobile/Library

include $(THEOS)/makefiles/bundle.mk
include $(THEOS_MAKE_PATH)/tweak.mk
