export ARCHS = arm64 arm64e
export TARGET = iphone:clang:12.2:12.2
export THEOS_DEVICE_IP=192.168.1.148
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DarkKeys
DarkKeys_FILES = Tweak.xm

CFLAGS += -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += darkkeysprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
