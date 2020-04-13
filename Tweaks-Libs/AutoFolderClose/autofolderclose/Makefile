ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = AutoFolderClose
AutoFolderClose_FILES = AutoFolderClose.mm
AutoFolderClose_INSTALL_PATH = /Library/PreferenceBundles
AutoFolderClose_FRAMEWORKS = UIKit MessageUI CoreGraphics
AutoFolderClose_PRIVATE_FRAMEWORKS = Preferences
AutoFolderClose_EXTRA_FRAMEWORKS += CepheiPrefs

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AutoFolderClose.plist$(ECHO_END)
