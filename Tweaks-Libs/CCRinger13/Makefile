include $(THEOS)/makefiles/common.mk

export TARGET = iphone:clang:11.2:11.0
export ARCHS = arm64

BUNDLE_NAME = CCRinger13
CCRinger13_BUNDLE_EXTENSION = bundle
CCRinger13_FILES = CCRinger13.m
CCRinger13_PRIVATE_FRAMEWORKS = ControlCenterUIKit
CCRinger13_INSTALL_PATH = /Library/ControlCenter/Bundles/

after-install::
	install.exec "killall -9 SpringBoard"

include $(THEOS_MAKE_PATH)/bundle.mk
SUBPROJECTS += ccringertweak
include $(THEOS_MAKE_PATH)/aggregate.mk
