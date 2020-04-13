
ARCHS = armv6 armv7 arm64 arm64e
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PivotPrefs

PivotPrefs_FILES = PVTRootListController.m
PivotPrefs_INSTALL_PATH = /Library/PreferenceBundles
PivotPrefs_FRAMEWORKS = UIKit
PivotPrefs_PRIVATE_FRAMEWORKS = Preferences
PivotPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PivotPrefs.plist$(ECHO_END)
