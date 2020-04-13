ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PerfectPhotos13Prefs
PerfectPhotos13Prefs_FILES = PPTAppearanceSettings.m PPTRootHeaderView.mm PPTRootListController.xm
PerfectPhotos13Prefs_INSTALL_PATH = /Library/PreferenceBundles
PerfectPhotos13Prefs_FRAMEWORKS = UIKit
PerfectPhotos13Prefs_PRIVATE_FRAMEWORKS = Preferences
PerfectPhotos13Prefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
PerfectPhotos13Prefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PerfectPhotos13Prefs.plist$(ECHO_END)
