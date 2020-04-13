TARGET = :clang
ARCHS = armv7 arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = FastUnlockX
FastUnlockX_FILES = CPDDFUXRootListController.mm
FastUnlockX_INSTALL_PATH = /Library/PreferenceBundles
FastUnlockX_FRAMEWORKS = UIKit MessageUI Social CoreGraphics
FastUnlockX_PRIVATE_FRAMEWORKS = Preferences
FastUnlockX_LDFLAGS = -lMobileGestalt

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FastUnlockX.plist$(ECHO_END)
