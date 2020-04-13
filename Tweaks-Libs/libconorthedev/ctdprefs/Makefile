ARCHS = arm64 arm64e
TARGET = iphone:clang:13.0:11.0

include $(THEOS)/makefiles/common.mk

FRAMEWORK_NAME = CTDPrefs

$(FRAMEWORK_NAME)_FILES = CTDListController.m CTDHeaderCell.m CTDPreferenceSettings.m CTDTableCell.m
$(FRAMEWORK_NAME)_PUBLIC_HEADERS = CTDPrefs.h
$(FRAMEWORK_NAME)_INSTALL_PATH = /Library/Frameworks
$(FRAMEWORK_NAME)_CFLAGS = -fobjc-arc
$(FRAMEWORK_NAME)_PRIVATE_FRAMEWORKS = Preferences

all::
	mkdir -p $(THEOS)/include/CTDPrefs
	cp CTDPrefs.h $(THEOS)/include/CTDPrefs

include $(THEOS_MAKE_PATH)/framework.mk
