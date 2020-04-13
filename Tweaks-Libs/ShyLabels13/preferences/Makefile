include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ShyLabels
ShyLabels_FILES = $(wildcard *.m)
ShyLabels_INSTALL_PATH = /Library/PreferenceBundles
ShyLabels_FRAMEWORKS = CoreGraphics UIKit
ShyLabels_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/ShyLabels.plist$(ECHO_END)
