ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NetworkSpeed13Prefs
NetworkSpeed13Prefs_FILES = NSPAppearanceSettings.m NSPRootHeaderView.mm NSPRootListController.xm
NetworkSpeed13Prefs_INSTALL_PATH = /Library/PreferenceBundles
NetworkSpeed13Prefs_FRAMEWORKS = UIKit
NetworkSpeed13Prefs_PRIVATE_FRAMEWORKS = Preferences
NetworkSpeed13Prefs_LIBRARIES = sparkcolourpicker
NetworkSpeed13Prefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
NetworkSpeed13Prefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NetworkSpeed13Prefs.plist$(ECHO_END)
