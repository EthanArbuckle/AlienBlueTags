export THEOS_DEVICE_IP = 192.168.1.138
include theos/makefiles/common.mk

TWEAK_NAME = AlienBlueTags
AlienBlueTags_FILES = Tweak.xm
AlienBlueTags_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
