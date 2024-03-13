include $(THEOS)/makefiles/common.mk

export TARGET = iphone::9.3:8.0

export ARCHS = armv7 arm64 arm64e

export THEOS_DEVICE_IP=192.168.15.18 THEOS_DEVICE_PORT=22

GO_EASY_ON_ME = 1

TWEAK_NAME = S8Edge
S8Edge_FILES = Tweak.xm CustoWindow.m
S8Edge_FRAMEWORKS = UIKit AudioToolbox SystemConfiguration QuartzCore CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += s8edgeprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
