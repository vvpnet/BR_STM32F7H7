#!make
PREFIX = $(shell pwd)

tar_buildroot = buildroot-2021.11.tar.gz
url_buildroot = https://buildroot.org/downloads/$(tar_buildroot)

def_stm32 = stm32$(stm)_defconfig
dev_stm32 = .currentstm

dir_external = $(PREFIX)
dir_download = $(PREFIX)/downloads
dir_buildroot = $(PREFIX)/buildroot


defstm = $(shell cat $(dev_stm32))
cfgstm = $(PREFIX)/configs/$(call defstm)
dirstm = $(shell echo "$(PREFIX)/$(call defstm)" | (sed 's/_defconfig//g'))
getval = $(shell (grep -m 1 ${1} $(call cfgstm)) | (sed 's/^.*=//g'))

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
	@if [ ! -f "$(dev_stm32)" ]; then \
	    touch $(dev_stm32); \
	fi
	@echo $(def_stm32) > $(dev_stm32)

	tar zxvf $(dir_download)/$(tar_buildroot) -C $(dir_buildroot) --strip-components=1
	make BR2_EXTERNAL=$(PREFIX) $(call defstm) -C $(dir_buildroot)

checkout:
	@if [ ! -f "$(dev_stm32)" ]; then \
	    touch $(dev_stm32); \
	fi
	@echo $(def_stm32) > $(dev_stm32)
	make BR2_EXTERNAL=$(PREFIX) $(call defstm) -C $(dir_buildroot)
	make linux-reinstall -C $(dir_buildroot)
	make uboot-reinstall -C $(dir_buildroot)
	rm -rf $(dir_buildroot)/output/target
	find $(dir_buildroot)/output/ -name ".stamp_target_installed" | xargs rm -rf

menuconfig:
	make BR2_EXTERNAL=$(dir_external) $(call defstm) -C $(dir_buildroot) menuconfig
	make savedefconfig BR2_DEFCONFIG=$(call cfgstm) -C $(dir_buildroot)
	@echo "Saved config $(call cfgstm)"

linux-menuconfig:
	make -C $(dir_buildroot) linux-menuconfig
	make linux-update-config -C $(dir_buildroot)
	@echo "Saved Linux config."

busybox-menuconfig:
	make busybox-menuconfig -C $(dir_buildroot)
	make busybox-update-config -C $(dir_buildroot)
	@echo "Saved Busybox config."

build:
	make BR2_EXTERNAL=$(PREFIX) $(call defstm) -C $(dir_buildroot)
	make BR2_DEFCONFIG=$(call cfgstm) -C $(dir_buildroot)

uboot-menuconfig:
	make -C $(dir_buildroot) uboot-menuconfig
	@cp $(dir_buildroot)/output/build/uboot-$(call getval,BR2_TARGET_UBOOT_CUSTOM_VERSION_VALUE)/.config $(call dirstm)/uboot.config
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
	@echo '		f767a - STMF767 APOLLO'
	@echo
	@echo 'Support command:'
	@echo '		make bootstrap stm=f767l'
	@echo '		make checkout stm=f767l'
	@echo '		make build'
	@echo '		make menuconfig'
	@echo '		make uboot-menuconfig'
	@echo '		make linux-menuconfig'
	@echo '		make busybox-menuconfig'
	@echo '		make uboot-menuconfig'
	@echo '		make update-target'
	@echo
