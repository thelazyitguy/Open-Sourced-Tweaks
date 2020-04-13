include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = colorscrollprefs

colorscrollprefs_FILES = CSPRootListController.m
colorscrollprefs_INSTALL_PATH = /Library/PreferenceBundles
colorscrollprefs_FRAMEWORKS = UIKit
colorscrollprefs_LIBRARIES = colorpicker
colorscrollprefs_PRIVATE_FRAMEWORKS = Preferences
colorscrollprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/colorscrollprefs.plist$(ECHO_END)
