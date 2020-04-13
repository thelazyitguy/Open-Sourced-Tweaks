ARCHS = arm64 arm64e
SDK = iPhoneOS12.4
FINALPACKAGE = 1
THEOS_DEVICE_IP = 192.168.1.215

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AutoFolderClose
AutoFolderClose_FILES = Tweak.xm
AutoFolderClose_FRAMEWORKS = UIKit
AutoFolderClose_EXTRA_FRAMEWORKS += Cephei

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"
SUBPROJECTS += autofolderclose
include $(THEOS_MAKE_PATH)/aggregate.mk
