ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PerfectSettings13Prefs
PerfectSettings13Prefs_FILES = PSTAppearanceSettings.m PSTRootHeaderView.mm PSTRootListController.xm
PerfectSettings13Prefs_INSTALL_PATH = /Library/PreferenceBundles
PerfectSettings13Prefs_FRAMEWORKS = UIKit
PerfectSettings13Prefs_PRIVATE_FRAMEWORKS = Preferences
PerfectSettings13Prefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
PerfectSettings13Prefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PerfectSettings13Prefs.plist$(ECHO_END)
