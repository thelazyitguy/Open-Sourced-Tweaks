ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PerfectCursor13Prefs
PerfectCursor13Prefs_FILES = PCSAppearanceSettings.m PCSRootHeaderView.mm PCSRootListController.xm
PerfectCursor13Prefs_INSTALL_PATH = /Library/PreferenceBundles
PerfectCursor13Prefs_FRAMEWORKS = UIKit
PerfectCursor13Prefs_PRIVATE_FRAMEWORKS = Preferences
PerfectCursor13Prefs_LIBRARIES = sparkcolourpicker
PerfectCursor13Prefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
PerfectCursor13Prefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PerfectCursor13Prefs.plist$(ECHO_END)
