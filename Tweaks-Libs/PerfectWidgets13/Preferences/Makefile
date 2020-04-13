ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PerfectWidgets13Prefs
PerfectWidgets13Prefs_FILES = PWGAppearanceSettings.m PWGRootHeaderView.mm PWGRootListController.xm
PerfectWidgets13Prefs_INSTALL_PATH = /Library/PreferenceBundles
PerfectWidgets13Prefs_FRAMEWORKS = UIKit
PerfectWidgets13Prefs_PRIVATE_FRAMEWORKS = Preferences
PerfectWidgets13Prefs_LIBRARIES = sparkcolourpicker
PerfectWidgets13Prefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
PerfectWidgets13Prefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PerfectWidgets13Prefs.plist$(ECHO_END)
