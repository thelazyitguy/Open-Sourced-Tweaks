include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = OneNotifyPreferences
OneNotifyPreferences_FILES = ONPRootListController.m
OneNotifyPreferences_EXTRA_FRAMEWORKS += MenushkaPrefs
OneNotifyPreferences_INSTALL_PATH = /Library/PreferenceBundles
OneNotifyPreferences_FRAMEWORKS = UIKit
OneNotifyPreferences_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/OneNotifyPreferences.plist$(ECHO_END)
