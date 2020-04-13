ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PerfectLockScreen13Prefs
PerfectLockScreen13Prefs_FILES = PLSAppearanceSettings.m PLSRootHeaderView.mm PLSRootListController.xm
PerfectLockScreen13Prefs_INSTALL_PATH = /Library/PreferenceBundles
PerfectLockScreen13Prefs_FRAMEWORKS = UIKit
PerfectLockScreen13Prefs_PRIVATE_FRAMEWORKS = Preferences
PerfectLockScreen13Prefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
PerfectLockScreen13Prefs_LIBRARIES += sparkapplist sparkcolourpicker
PerfectLockScreen13Prefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PerfectLockScreen13Prefs.plist$(ECHO_END)
