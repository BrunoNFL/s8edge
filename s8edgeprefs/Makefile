include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = S8EdgePrefs
S8EdgePrefs_FILES = S8ERootListController.m
S8EdgePrefs_INSTALL_PATH = /Library/PreferenceBundles
S8EdgePrefs_FRAMEWORKS = UIKit
S8EdgePrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/S8EdgePrefs.plist$(ECHO_END)
