ARCHS = arm64 arm64e
SDK = iPhoneOS12.4
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ZenithDark

ZenithDark_FILES = Tweak.xm
ZenithDark_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += zenithdarkprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "sbreload"