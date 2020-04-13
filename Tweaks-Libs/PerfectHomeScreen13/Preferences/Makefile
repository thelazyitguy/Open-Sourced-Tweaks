ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PerfectHomeScreen13Prefs
PerfectHomeScreen13Prefs_FILES = PHSAppearanceSettings.m PHSRootHeaderView.mm PHSRootListController.xm
PerfectHomeScreen13Prefs_INSTALL_PATH = /Library/PreferenceBundles
PerfectHomeScreen13Prefs_FRAMEWORKS = UIKit
PerfectHomeScreen13Prefs_PRIVATE_FRAMEWORKS = Preferences
PerfectHomeScreen13Prefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
PerfectHomeScreen13Prefs_LIBRARIES += sparkapplist sparkcolourpicker
PerfectHomeScreen13Prefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PerfectHomeScreen13Prefs.plist$(ECHO_END)
