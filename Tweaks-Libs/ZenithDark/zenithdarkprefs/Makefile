ARCHS = arm64 arm64e
SDK = iPhoneOS12.4
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ZenithDarkPrefs
ZenithDarkPrefs_FILES = ZNDarkPrefsRootListController.m
ZenithDarkPrefs_INSTALL_PATH = /Library/PreferenceBundles
ZenithDarkPrefs_FRAMEWORKS = UIKit
ZenithDarkPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ZenithDarkPrefs.plist$(ECHO_END)
