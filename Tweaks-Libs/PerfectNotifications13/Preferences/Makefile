ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PerfectNotifications13Prefs
PerfectNotifications13Prefs_FILES = PNCAppearanceSettings.m PNCRootHeaderView.mm PNCRootListController.xm
PerfectNotifications13Prefs_INSTALL_PATH = /Library/PreferenceBundles
PerfectNotifications13Prefs_FRAMEWORKS = UIKit
PerfectNotifications13Prefs_PRIVATE_FRAMEWORKS = Preferences
PerfectNotifications13Prefs_LIBRARIES = sparkcolourpicker
PerfectNotifications13Prefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
PerfectNotifications13Prefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PerfectNotifications13Prefs.plist$(ECHO_END)
