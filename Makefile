TARGET := iphone:clang:latest:13.0
ARCHS = arm64
INSTALL_TARGET_PROCESSES = SpringBoard


include $(THEOS)/makefiles/common.mk

TWEAK_NAME = WSNotify

WSNotify_FILES = Tweak.x
WSNotify_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
