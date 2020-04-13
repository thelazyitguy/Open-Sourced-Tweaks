ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SunriseSunsetInfoPrefs
SunriseSunsetInfoPrefs_FILES = SSIAppearanceSettings.m SSIRootHeaderView.mm SSIRootListController.xm
SunriseSunsetInfoPrefs_INSTALL_PATH = /Library/PreferenceBundles
SunriseSunsetInfoPrefs_FRAMEWORKS = UIKit
SunriseSunsetInfoPrefs_PRIVATE_FRAMEWORKS = Preferences
SunriseSunsetInfoPrefs_LIBRARIES = sparkcolourpicker
SunriseSunsetInfoPrefs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
SunriseSunsetInfoPrefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/SunriseSunsetInfoPrefs.plist$(ECHO_END)
