INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_DEVICE_IP = 192.168.1.248

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MessagesPro
GO_EASY_ON_ME = 1
export TARGET = iphone:clang:13.2:13.2
MessagesPro_FILES = Tweak.xm
ARCHS = arm64 arm64e
MessagesPro_FRAMEWORKS = UIKit Foundation
MessagesPro_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
MessagesPro_CFLAGS = -fobjc-arc
MessagesPro_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += messagesproprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
