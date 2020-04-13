ARCHS = armv7s arm64 arm64e
FINALPACKAGE=1

SHARED_CFLAGS = -fobjc-arc
ADDITIONAL_OBJCFLAGS = -fobjc-arc

THEOS_DEVICE_IP=192.168.0.12

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Sposify
Sposify_FILES = $(wildcard Project/*.m Project/*.mm Project/*.x Project/*.xm)


include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS)/makefiles/bundle.mk

after-install::
	install.exec "killall -9 Spotify"
