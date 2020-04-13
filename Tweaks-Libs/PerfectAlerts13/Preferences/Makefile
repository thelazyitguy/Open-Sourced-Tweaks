ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PerfectAlerts13Prefs
PerfectAlerts13Prefs_FILES = PALAppearanceSettings.m PALRootHeaderView.mm PALRootListController.xm
PerfectAlerts13Prefs_INSTALL_PATH = /Library/PreferenceBundles
PerfectAlerts13Prefs_FRAMEWORKS = UIKit
PerfectAlerts13Prefs_PRIVATE_FRAMEWORKS = Preferences
PerfectAlerts13Prefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
PerfectAlerts13Prefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PerfectAlerts13Prefs.plist$(ECHO_END)
