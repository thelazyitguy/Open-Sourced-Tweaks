PACKAGE_VERSION = 0.0.2.1
TARGET = iphone:latest:10.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = QuadHighCurrent
QuadHighCurrent_FILES = Tweak.xm

SUBPROJECTS = CCModule Switch

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk