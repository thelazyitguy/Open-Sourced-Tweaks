ARCHS = armv7 arm64 arm64e
TARGET = iphone:latest:9.0
PACKAGE_VERSION = 0.0.2.2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PencilPro

PencilPro_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

# internal-stage::
#	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
#	$(ECHO_NOTHING)cp -R Resources $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/$(TWEAK_NAME)$(ECHO_END)
