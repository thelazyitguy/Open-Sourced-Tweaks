ARCHS = arm64
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ShyLabels13
ShyLabels13_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += preferences

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "killall -9 SpringBoard"
