#!/bin/sh
# Deploy image and dtb to ResultDir

ver_uboot="2021.10"
ver_kernel="5.6.16"
dir_publish1="${BR2_EXTERNAL_STM32F767_PATH}/stm32f767/ImageLinux"
dir_publish2="/home/vpopov/minicom/send/linux"

echo "Publish1 Files to" ${dir_publish1}

export

echo "Copy zImage to " ${dir_publish1}
cp ${BINARIES_DIR}/zImage ${dir_publish1}

echo "Copy dtb to" ${dir_publish1}
cp ${BUILD_DIR}/linux-${ver_kernel}/arch/arm/boot/dts/stm32f746-disco.dtb ${dir_publish1}/stm32f767-lqfp176.dtb

echo "Copy uboot.bin to" ${dir_publish1}
cp ${BUILD_DIR}/uboot-${ver_uboot}/u-boot.bin ${dir_publish1}/uboot-stm32f767-lqfp176.bin

echo "Copy spl-uboot.bin to" ${dir_publish1}
cp ${BUILD_DIR}/uboot-${ver_uboot}/spl/u-boot-spl.bin ${dir_publish1}/spl-uboot-stm32f767-lqfp176.bin

if [ -d ${dir_publish2} ]; then
    echo "Publish2 Files to" ${dir_publish2}
    
    echo "Copy zImage to " ${dir_publish2}
    cp ${BINARIES_DIR}/zImage ${dir_publish2}
    
    echo "Copy dtb to" ${dir_publish2}
    cp ${BUILD_DIR}/linux-${ver_kernel}/arch/arm/boot/dts/stm32f746-disco.dtb ${dir_publish2}/stm32f767-lqfp176.dtb
    
    echo "Copy uboot.bin to" ${dir_publish2}
    cp ${BUILD_DIR}/uboot-${ver_uboot}/u-boot.bin ${dir_publish2}/uboot-stm32f767-lqfp176.bin

    echo "Copy spl-uboot.bin to" ${dir_publish2}
    cp ${BUILD_DIR}/uboot-${ver_uboot}/spl/u-boot-spl.bin ${dir_publish2}/spl-uboot-stm32f767-lqfp176.bin
fi