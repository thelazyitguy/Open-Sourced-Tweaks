ARCHS = arm64 arm64e
TARGET = iphone:clang:13.2.2:12.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = TempSpawn
${TWEAK_NAME}_FILES = Tweak.xm
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS += BackBoardServices
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += preferences

include $(THEOS_MAKE_PATH)/aggregate.mk

after-install::
	install.exec "sbreload"
