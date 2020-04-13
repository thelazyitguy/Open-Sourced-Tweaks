ARCHS  = arm64 arm64e
ADDITIONAL_OBJCFLAGS = -fobjc-arc
SYSROOT = $(THEOS)/sdks/iPhoneOS12.1.sdk
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LookinLoader
$(TWEAK_NAME)_FILES = Tweak.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -Wdeprecated-declarations -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"
