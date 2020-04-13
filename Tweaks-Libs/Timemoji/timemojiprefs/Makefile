ARCHS = arm64 arm64e

include ../../theos/makefiles/common.mk

BUNDLE_NAME = Timemojiprefs
Timemojiprefs_FILES = PRootListController.m
Timemojiprefs_INSTALL_PATH = /Library/PreferenceBundles
Timemojiprefs_FRAMEWORKS = UIKit
Timemojiprefs_PRIVATE_FRAMEWORKS = Preferences
Timemojiprefs_EXTRA_FRAMEWORKS += CepheiPrefs


include ../../theos/makefiles/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Timemojiprefs.plist$(ECHO_END)
