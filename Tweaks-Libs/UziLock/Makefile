include $(THEOS)/makefiles/common.mk

TWEAK_NAME = UziTime
UziTime_FILES = Tweak.xm

THEOS_DEVICE_IP=192.168.0.11

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += uzitimepref
include $(THEOS_MAKE_PATH)/aggregate.mk
