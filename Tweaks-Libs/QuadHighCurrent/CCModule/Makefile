TARGET = iphone:clang:11.2:10.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = QuadHighCurrentCCModule
QuadHighCurrentCCModule_BUNDLE_EXTENSION = bundle
QuadHighCurrentCCModule_FILES = QuadHighCurrentCCModule.m
QuadHighCurrentCCModule_PRIVATE_FRAMEWORKS = ControlCenterUIKit
QuadHighCurrentCCModule_INSTALL_PATH = /Library/ControlCenter/Bundles/

include $(THEOS_MAKE_PATH)/bundle.mk