INSTALL_TARGET_PROCESSES = SpringBoard
TARGET = iphone:clang::10.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Vibe

Vibe_FILES = Tweak.xm
Vibe_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += vibeprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
