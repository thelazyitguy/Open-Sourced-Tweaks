ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = DateUnderTime13Prefs
DateUnderTime13Prefs_FILES = DUTAppearanceSettings.m DUTRootHeaderView.mm DUTRootListController.xm
DateUnderTime13Prefs_INSTALL_PATH = /Library/PreferenceBundles
DateUnderTime13Prefs_FRAMEWORKS = UIKit
DateUnderTime13Prefs_PRIVATE_FRAMEWORKS = Preferences
DateUnderTime13Prefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
DateUnderTime13Prefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/DateUnderTime13Prefs.plist$(ECHO_END)
