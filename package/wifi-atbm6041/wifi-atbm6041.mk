WIFI_ATBM6041_SITE_METHOD = git
WIFI_ATBM6041_SITE = https://github.com/gtxaspec/atbm60xx
WIFI_ATBM6041_SITE_BRANCH = master
WIFI_ATBM6041_VERSION = 933a3bc2b3e1100ae00831b82132f8ae200a324d
# $(shell git ls-remote $(WIFI_ATBM6041_SITE) $(WIFI_ATBM6041_SITE_BRANCH) | head -1 | cut -f1)

WIFI_ATBM6041_LICENSE = GPL-2.0

ATBM6041_MODULE_NAME = "atbm6041"

WIFI_ATBM6041_MODULE_MAKE_OPTS = \
	KSRC=$(LINUX_DIR) \
	KVERSION=$(LINUX_VERSION_PROBED) \
	CONFIG_ATBM_SDIO_BUS=y \
	CONFIG_ATBM_USB_BUS=n \
	CONFIG_ATBM_MENUCONFIG=y \
	CONFIG_ATBM_WIRELESS=y \
	CONFIG_ATBM_USE_FIRMWARE_H=y \
	CONFIG_ATBM_WEXT=y \
	CONFIG_ATBM6041=y \
	CONFIG_ATBM_MODULE_NAME=$(ATBM6041_MODULE_NAME)

define WIFI_ATBM6041_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_WLAN)
	$(call KCONFIG_ENABLE_OPT,CONFIG_WIRELESS)
	$(call KCONFIG_ENABLE_OPT,CONFIG_WIRELESS_EXT)
	$(call KCONFIG_ENABLE_OPT,CONFIG_WEXT_CORE)
	$(call KCONFIG_ENABLE_OPT,CONFIG_WEXT_PROC)
	$(call KCONFIG_ENABLE_OPT,CONFIG_WEXT_PRIV)
	$(call KCONFIG_SET_OPT,CONFIG_CFG80211,y)
	$(call KCONFIG_SET_OPT,CONFIG_MAC80211,y)
	$(call KCONFIG_ENABLE_OPT,CONFIG_MAC80211_RC_MINSTREL)
	$(call KCONFIG_ENABLE_OPT,CONFIG_MAC80211_RC_MINSTREL_HT)
	$(call KCONFIG_ENABLE_OPT,CONFIG_MAC80211_RC_DEFAULT_MINSTREL)
	$(call KCONFIG_SET_OPT,CONFIG_MAC80211_RC_DEFAULT,"minstrel_ht")
endef

LINUX_CONFIG_LOCALVERSION = $(shell awk -F "=" '/^CONFIG_LOCALVERSION=/ {print $$2}' $(BR2_LINUX_KERNEL_CUSTOM_CONFIG_FILE))

define WIFI_ATBM6041_INSTALL_CONFIGS
	$(INSTALL) -m 0755 -d $(TARGET_DIR)/lib/modules/3.10.14$(LINUX_CONFIG_LOCALVERSION)
	touch $(TARGET_DIR)/lib/modules/3.10.14$(LINUX_CONFIG_LOCALVERSION)/modules.builtin.modinfo

	$(INSTALL) -m 0755 -d $(TARGET_DIR)/usr/share/wifi
	$(INSTALL) -m 0644 -t $(TARGET_DIR)/usr/share/wifi \
		$(WIFI_ATBM60XX_PKGDIR)/files/*.txt
endef

WIFI_ATBM6041_POST_INSTALL_TARGET_HOOKS += WIFI_ATBM6041_INSTALL_CONFIGS

$(eval $(kernel-module))
$(eval $(generic-package))
