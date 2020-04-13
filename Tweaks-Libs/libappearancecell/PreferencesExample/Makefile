include $(THEOS)/makefiles/common.mk

TARGET = iphone:clang:latest:latest
ARCHS = arm64 arm64e

BUNDLE_NAME = libappearancecell_demo

libappearancecell_demo_FILES = ACDRootListController.m
libappearancecell_demo_INSTALL_PATH = /Library/PreferenceBundles
libappearancecell_demo_FRAMEWORKS = UIKit
libappearancecell_demo_LIBRARIES = appearancecell
libappearancecell_demo_PRIVATE_FRAMEWORKS = Preferences
libappearancecell_demo_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/libappearancecell_demo.plist$(ECHO_END)

after-install::
	killlall -9 Preferences