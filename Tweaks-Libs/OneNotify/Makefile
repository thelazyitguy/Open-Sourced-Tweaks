# TARGET = simulator:clang::11.0
# ARCHS = x86_64
TARGET = iphone::9.0:11.0
ARCHS = armv7 armv7s arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = OneNotify
OneNotify_FILES = Tweak.xm
OneNotify_EXTRA_FRAMEWORKS += MenushkaPrefs

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += onenotifypreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
