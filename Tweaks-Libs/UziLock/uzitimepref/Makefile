include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = UziTimePref
UziTimePref_FILES = utpRootListController.m
UziTimePref_INSTALL_PATH = /Library/PreferenceBundles
UziTimePref_FRAMEWORKS = UIKit
UziTimePref_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/UziTimePref.plist$(ECHO_END)
