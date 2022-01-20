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
	mkdir -p $(dir_download)
	mkdir -p $(dir_buildroot)
	echo "Downloading $(tar_buildroot) to $(dir_download)"
	wget --no-check-certificate -O $(dir_download)/$(tar_buildroot) $(url_buildroot)
	tar zxvf $(dir_download)/$(tar_buildroot) -C $(dir_buildroot) --strip-components=1
	make BR2_EXTERNAL=$(PREFIX) $(def_stm32f767) -C $(dir_buildroot)

menuconfig:
	make BR2_EXTERNAL=$(dir_external) $(def_stm32f767) -C $(dir_buildroot) menuconfig
	make savedefconfig BR2_DEFCONFIG=$(dir_configs_stm32f767) -C $(dir_buildroot)
	echo "Saved config $(dir_configs_stm32f767)"

build:
	make BR2_EXTERNAL=$(PREFIX) $(def_stm32f767) -C $(dir_buildroot)
	make BR2_DEFCONFIG=$(dir_configs_stm32f767) -C $(dir_buildroot)

