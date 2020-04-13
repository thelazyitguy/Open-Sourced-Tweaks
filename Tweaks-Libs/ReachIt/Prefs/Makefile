ARCHS = arm64 arm64e
TARGET = iphone:clang:13.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ReachItPrefs
$(BUNDLE_NAME)_FILES = Preferences.m KRLinkCell.m KRTableCell.m KRTwitterCell.m
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(BUNDLE_NAME).plist$(ECHO_END)