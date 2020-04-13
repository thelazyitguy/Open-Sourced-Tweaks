include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = libconorthedev

libconorthedev_FILES = libconorthedev.m
libconorthedev_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/library.mk

stage::
	mkdir -p $(THEOS)/include/ConorTheDev
	cp -r ./public/* $(THEOS)/include/ConorTheDev
	cp $(THEOS_STAGING_DIR)/usr/lib/libconorthedev.dylib $(THEOS)/lib/libconorthedev.dylib
	
SUBPROJECTS += ctdprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
