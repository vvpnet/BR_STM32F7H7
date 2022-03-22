#!make
PREFIX = $(shell pwd)

tar_buildroot = buildroot-2021.11.tar.gz
url_buildroot = https://buildroot.org/downloads/$(tar_buildroot)


def_stm32 = stm32$(stm)_defconfig

dir_external = $(PREFIX)
dir_download = $(PREFIX)/downloads
dir_buildroot = $(PREFIX)/buildroot

dir_configs_stm32 = $(PREFIX)/configs/$(def_stm32)

getval = $(shell (grep -m 1 ${1} $(dir_configs_stm32)) | (sed 's/^.*=//g'))

bootstrap:
	@mkdir -p $(dir_download)
	@if [ -d "$(dir_buildroot)" ]; then \
	    rm -f -R $(dir_buildroot); \
	    echo "Removed $(dir_buildroot)"; \
	fi
	@mkdir -p $(dir_buildroot)
	@if [ ! -f "$(dir_download)/$(tar_buildroot)" ]; then \
	    echo "Downloading $(tar_buildroot) to $(dir_download)"; \
	    wget --no-check-certificate -O $(dir_download)/$(tar_buildroot) $(url_buildroot); \
	fi
#	@if [ ! -f "$(dev_stm)" ]; then \
#	    touch $(dev_stm); \
#	fi
	tar zxvf $(dir_download)/$(tar_buildroot) -C $(dir_buildroot) --strip-components=1
	make BR2_EXTERNAL=$(PREFIX) $(def_stm32) -C $(dir_buildroot)

menuconfig:
	make BR2_EXTERNAL=$(dir_external) $(def_stm32) -C $(dir_buildroot) menuconfig
	make savedefconfig BR2_DEFCONFIG=$(dir_configs_stm32) -C $(dir_buildroot)
	@echo "Saved config $(dir_configs_stm32)"

linux-menuconfig:
	make -C $(dir_buildroot) linux-menuconfig
	make linux-update-config -C $(dir_buildroot)
	@echo "Saved Linux config."

busybox-menuconfig:
	make busybox-menuconfig -C $(dir_buildroot)
	make busybox-update-config -C $(dir_buildroot)
	@echo "Saved Busybox config."

build:
	make BR2_EXTERNAL=$(PREFIX) $(def_stm32) -C $(dir_buildroot)
	make BR2_DEFCONFIG=$(dir_configs_stm32) -C $(dir_buildroot)

uboot-menuconfig:
	make -C $(dir_buildroot) uboot-menuconfig
	@cp $(dir_buildroot)/output/build/uboot-$(call getval,BR2_TARGET_UBOOT_CUSTOM_VERSION_VALUE)/.config $(PREFIX)/stm32$(stm)/uboot.config
	@echo "Saved Uboot config."

uboot_rebuild:
	make uboot-reconfigure -C $(dir_buildroot)

update-target:
	rm -rf $(dir_buildroot)/output/target
	find $(dir_buildroot)/output/ -name ".stamp_target_installed" | xargs rm -rf

help:
	@echo 'SUPPORT STM32 BOARD (stm=*):'
	@echo '		f767l - STM32F767IGT6 LQFP176'
	@echo '		h743a - STM32H743 APOLLO'
	@echo
	@echo 'Support command:'
	@echo '		make bootstrap stm=f767l'
	@echo '		make build stm=f767l'
	@echo '		make menuconfig stm=f767l'
	@echo '		make uboot-menuconfig stm=f767l'
	@echo '		make linux-menuconfig'
	@echo '		make busybox-menuconfig'
	@echo '		make uboot-menuconfig'
	@echo '		make update-target'
	@echo
