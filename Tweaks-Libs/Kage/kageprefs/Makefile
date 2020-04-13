ARCHS = arm64 arm64e
TARGET = iphone:clang:11.2:11.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = kageprefs

kageprefs_FILES = KgeRootListController.m
kageprefs_INSTALL_PATH = /Library/PreferenceBundles
kageprefs_FRAMEWORKS = UIKit
kageprefs_PRIVATE_FRAMEWORKS = Preferences
kageprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/kageprefs.plist$(ECHO_END)
