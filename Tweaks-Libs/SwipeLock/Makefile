ARCHS = arm64 arm64e
TARGET = iphone:clang:13.0:13.0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SwipeLock
${TWEAK_NAME}_FILES = Tweak.x
${TWEAK_NAME}_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit


include $(THEOS_MAKE_PATH)/tweak.mk
