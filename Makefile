system_image = stm32f767-china_system.uImage
dir_download = downloads
dir_configs = configs
dir_buildroot = buildroot
dir_publish = /home/vpopov/minicom/send/5.6
#	2019.11

bootstrap:
	mkdir -p $(dir_download)
	cp $(dir_configs)/buildroot $(dir_buildroot)/.config

build:
	make -j10 -C $(dir_buildroot)
	cp $(dir_buildroot)/output/images/stm32f746-disco.dtb ${dir_publish}/
	cp $(dir_buildroot)/output/images/zImage ${dir_publish}/

linux-rebuild:
	make linux-rebuild -C $(dir_buildroot)
	cp $(dir_buildroot)/output/images/zImage ${dir_publish}
	cp $(dir_buildroot)/output/build/linux-custom/arch/arm/boot/dts/stm32f746-disco.dtb ${dir_publish}

flash_bootloader:
	cd $(dir_buildroot)/output/build/host-openocd-0.11.0/tcl && ../../../host/usr/bin/openocd \
		-f board/stm32f7discovery.cfg \
		-c "program ../../../images/u-boot-spl.bin 0x08000000" \
		-c "program ../../../images/u-boot.bin 0x08008000" \
		-c "reset run" -c shutdown

clean:
#	rm -rf $(dir_buildroot) $(dir_download)
