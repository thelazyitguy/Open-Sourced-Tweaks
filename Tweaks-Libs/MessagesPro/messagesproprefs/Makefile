include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MessagesProPrefs

MessagesProPrefs_FILES = MPPRootListController.m
ARCHS = arm64 arm64e
MessagesProPrefs_INSTALL_PATH = /Library/PreferenceBundles
MessagesProPrefs_FRAMEWORKS = UIKit
MessagesProPrefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs
MessagesProPrefs_PRIVATE_FRAMEWORKS = Preferences
MessagesProPrefs_CFLAGS = -fobjc-arc
MessagesProPrefs_LIBRARIES = colorpicker
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MessagesProPrefs.plist$(ECHO_END)
