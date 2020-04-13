ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = RAMInfo13Prefs
RAMInfo13Prefs_FILES = RINAppearanceSettings.m RINRootHeaderView.mm RINRootListController.xm
RAMInfo13Prefs_INSTALL_PATH = /Library/PreferenceBundles
RAMInfo13Prefs_FRAMEWORKS = UIKit
RAMInfo13Prefs_PRIVATE_FRAMEWORKS = Preferences
RAMInfo13Prefs_LIBRARIES = sparkcolourpicker
RAMInfo13Prefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
RAMInfo13Prefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/RAMInfo13Prefs.plist$(ECHO_END)
