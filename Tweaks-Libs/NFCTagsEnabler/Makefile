THEOS_DEVICE_IP = iphone
ARCHS = arm64
TARGET = iphone:clang:13.2:13.2

INSTALL_TARGET_PROCESSES = Shortcuts

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NFCTagsEnabler
NFCTagsEnabler_FILES = NFCTagsEnabler.xm
NFCTagsEnabler_CFLAGS = -fobjc-arc
NFCTagsEnabler_PRIVATEFRAMEWORKS = WorkflowKit

include $(THEOS_MAKE_PATH)/tweak.mk
