ARCHS = armv7 arm64 arm64e
TARGET = iphone:clang:10.3:10.3

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = RoundedPageDots
RoundedPageDots_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
