include $(THEOS)/makefiles/common.mk

ARCHS = arm64 arm64e
TARGET = iphone:clang:13.0:12.4

MAKEFLAGS = --no-print-directory

LIBRARY_NAME = liblockwidgets

liblockwidgets_FILES = LockWidgetsView.mm LockWidgetsConfig.m MRYIPCCenter.m
liblockwidgets_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/library.mk

stage::
	mkdir -p $(THEOS)/include/liblockwidgets
	cp *.h $(THEOS)/include/liblockwidgets
	cp $(THEOS_STAGING_DIR)/usr/lib/libconorthedev.dylib $(THEOS)/lib/liblockwidgets.dylib