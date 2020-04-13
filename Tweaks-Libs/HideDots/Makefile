ARCHS = arm64 arm64e

export TARGET = iphone:clang:11.2


include $(THEOS)/makefiles/common.mk


TWEAK_NAME = HideDots
HideDots_FILES = Tweak.xm
HideDots_EXTRA_FRAMEWORKS += Cephei




include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += hidedotspref
include $(THEOS_MAKE_PATH)/aggregate.mk
