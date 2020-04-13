include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e
TARGET = iphone:clang:13.0:12.4

BUNDLE_NAME = LockWidgetsHyperion
$(BUNDLE_NAME)_LIBRARIES = lockwidgets
$(BUNDLE_NAME)_CFLAGS = -fobjc-arc
$(BUNDLE_NAME)_FILES = $(wildcard *.m) $(wildcard *.mm)
$(BUNDLE_NAME)_FRAMEWORKS = UIKit
$(BUNDLE_NAME)_INSTALL_PATH = /Library/Hyperion/Widgets

include $(THEOS_MAKE_PATH)/bundle.mk

BUNDLE_PATH = $($(BUNDLE_NAME)_INSTALL_PATH)/$(BUNDLE_NAME).bundle

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)$(BUNDLE_PATH)$(ECHO_END)
	$(ECHO_NOTHING)cp Info.plist $(THEOS_STAGING_DIR)$(BUNDLE_PATH)/Info.plist$(ECHO_END)
	$(ECHO_NOTHING)cp Preferences.plist $(THEOS_STAGING_DIR)$(BUNDLE_PATH)/Preferences.plist$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"