include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CacheClearer

CacheClearer_FILES = /mnt/d/codes/CacheClearer/Tweak.xm
CacheClearer_FRAMEWORKS = CydiaSubstrate UIKit MobileCoreServices CoreGraphics CoreFoundation Foundation
CacheClearer_PRIVATE_FRAMEWORKS = SpringBoardServices Preferences
CacheClearer_LDFLAGS = -Wl,-segalign,4000

export ARCHS = armv7 arm64
CacheClearer_ARCHS = armv7 arm64

include $(THEOS_MAKE_PATH)/tweak.mk
	
all::
