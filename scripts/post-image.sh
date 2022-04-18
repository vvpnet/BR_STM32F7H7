#!/bin/bash

devstm=$(cat ${BR2_EXTERNAL_STM32F7H7_PATH}/.currentstm)
devstm1=$(echo $devstm | (sed 's/_defconfig//g'))
cfgstm=${BR2_EXTERNAL_STM32F7H7_PATH}/configs/$devstm
dirstm=${BR2_EXTERNAL_STM32F7H7_PATH}/$(echo $devstm | (sed 's/_defconfig//g'))

ver_uboot=$(echo $(grep -m 1 BR2_TARGET_UBOOT_CUSTOM_VERSION_VALUE $cfgstm) | sed 's/^.*=//g' | sed 's/"//g')
ver_kernel=$(echo $(grep -m 1 BR2_LINUX_KERNEL_CUSTOM_VERSION_VALUE $cfgstm) | sed 's/^.*=//g' | sed 's/"//g')
fdt_file=$(echo $(grep -m 1 BR2_LINUX_KERNEL_INTREE_DTS_NAME $cfgstm) | sed 's/^.*=//g' | sed 's/"//g')

dir_publish1="$dirstm/images"

echo "********************************Publish Files to "${dir_publish1}"**************************************" 

if [ ! -d ${dir_publish1} ]; then
    mkdir ${dir_publish1}
fi

zimage=${BINARIES_DIR}/zImage
if [ -f $zimage ]; then
    echo "Copy zImage to "${dir_publish1}
    cp $zimage ${dir_publish1}
fi

uimage=${BINARIES_DIR}/uImage
if [ -f $uimage ]; then
    echo "Copy uImage to "${dir_publish1}
    cp $uimage ${dir_publish1}
fi

fdt=${BUILD_DIR}/linux-${ver_kernel}/arch/arm/boot/dts/${fdt_file}.dtb
if [ -f $fdt ]; then
    echo "Copy DTB to "${dir_publish1}
    cp $fdt ${dir_publish1}/${devstm1}.dtb
fi

xipimage=${BUILD_DIR}/linux-${ver_kernel}/arch/arm/boot/xipImage
if [ -f $xipimage ]; then
    echo "Copy xipImage to "${dir_publish1}
    cp $xipimage ${dir_publish1}/${devstm1}
fi

uboot=${BUILD_DIR}/uboot-${ver_uboot}/u-boot.bin
if [ -f $uboot ]; then
    echo "Copy uboot.bin to "${dir_publish1}
    cp $uboot ${dir_publish1}/uboot-${devstm1}.bin
fi

sboot=${BUILD_DIR}/uboot-${ver_uboot}/spl/u-boot-spl.bin
if [ -f $sboot ]; then
    echo "Copy spl-boot.bin to "${dir_publish1}
    cp $sboot ${dir_publish1}/spl-uboot-${devstm1}.bin
fi

rootfsjffs2=${BINARIES_DIR}/rootfs.jffs2
if [ -f $rootfsjffs2 ]; then
    echo "Copy RootFS JFFS2 to "${dir_publish1}
    cp $rootfsjffs2 ${dir_publish1}
fi