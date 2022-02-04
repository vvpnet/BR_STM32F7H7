#	2021.11
#	2019.11

PREFIX = $(shell pwd)

tar_buildroot = buildroot-2021.11.tar.gz
url_buildroot = https://buildroot.org/downloads/$(tar_buildroot)
def_stm32f767 = stm32f767_defconfig

dir_external = $(PREFIX)
dir_download = $(PREFIX)/downloads
dir_buildroot = $(PREFIX)/buildroot
dir_configs_stm32f767 = $(PREFIX)/configs/$(def_stm32f767)

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
	tar zxvf $(dir_download)/$(tar_buildroot) -C $(dir_buildroot) --strip-components=1
	make BR2_EXTERNAL=$(PREFIX) $(def_stm32f767) -C $(dir_buildroot)

menuconfig:
	make BR2_EXTERNAL=$(dir_external) $(def_stm32f767) -C $(dir_buildroot) menuconfig
	make savedefconfig BR2_DEFCONFIG=$(dir_configs_stm32f767) -C $(dir_buildroot)
	@echo "Saved config $(dir_configs_stm32f767)"

linux-menuconfig:
	make -C $(dir_buildroot) linux-menuconfig
	make linux-update-config -C $(dir_buildroot)
	@echo "Saved Linux config."

busybox-menuconfig:
	make busybox-menuconfig -C $(dir_buildroot)
	make busybox-update-config -C $(dir_buildroot)
	@echo "Saved Busybox config."

build:
	make BR2_EXTERNAL=$(PREFIX) $(def_stm32f767) -C $(dir_buildroot)
	make BR2_DEFCONFIG=$(dir_configs_stm32f767) -C $(dir_buildroot)

uboot-menuconfig:
	make -C $(dir_buildroot) uboot-menuconfig
	@cp $(dir_buildroot)/output/build/uboot-2021.10/.config $(PREFIX)/stm32f767/uboot.config
	@echo "Saved Uboot config."

uboot_rebuild:
	make uboot-reconfigure -C $(dir_buildroot)