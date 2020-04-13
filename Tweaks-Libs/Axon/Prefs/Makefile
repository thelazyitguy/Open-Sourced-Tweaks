include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e 
BUNDLE_NAME = AxonPrefs
$(BUNDLE_NAME)_FILES = Preferences.m AXNListItemsController.m KRLinkCell.m KRTableCell.m KRTwitterCell.m
$(BUNDLE_NAME)_INSTALL_PATH = /Library/PreferenceBundles
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = Preferences
# $(BUNDLE_NAME)_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
ADDITIONAL_OBJCFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(BUNDLE_NAME).plist$(ECHO_END)
