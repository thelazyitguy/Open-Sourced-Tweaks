ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PerfectAppSwitcher13Prefs
PerfectAppSwitcher13Prefs_FILES = PASAppearanceSettings.m PASRootHeaderView.mm PASRootListController.xm
PerfectAppSwitcher13Prefs_INSTALL_PATH = /Library/PreferenceBundles
PerfectAppSwitcher13Prefs_FRAMEWORKS = UIKit
PerfectAppSwitcher13Prefs_PRIVATE_FRAMEWORKS = Preferences
PerfectAppSwitcher13Prefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
PerfectAppSwitcher13Prefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PerfectAppSwitcher13Prefs.plist$(ECHO_END)
