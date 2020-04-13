ARCHS = arm64 arm64e

THEOS_BUILD_DIR = Packages

include /var/theos/makefiles/common.mk

TWEAK_NAME = DrunkMode
DrunkMode_FILES = Tweak.xm
DrunkMode_FRAMEWORKS = UIKit
DrunkMode_PRIVATE_FRAMEWORKS = Preferences

include /var/theos/makefiles/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
