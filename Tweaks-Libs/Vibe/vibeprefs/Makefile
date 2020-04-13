include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Vibe

Vibe_FILES = $(wildcard *.m)
Vibe_INSTALL_PATH = /Library/PreferenceBundles
Vibe_FRAMEWORKS = UIKit
Vibe_LIBRARIES = applist
Vibe_PRIVATE_FRAMEWORKS = Preferences AppSupport
Vibe_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
Vibe_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Vibe.plist$(ECHO_END)
