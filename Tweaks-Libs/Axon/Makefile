INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e 
TARGET = iphone:clang:13.2:11.0
#SYSROOT = $(THEOS)/sdks/iPhoneOS11.2.sdk
PACKAGE_VERSION=$(THEOS_PACKAGE_BASE_VERSION)
include $(THEOS)/makefiles/common.mk

SUBPROJECTS += Tweak Prefs

include $(THEOS_MAKE_PATH)/aggregate.mk
