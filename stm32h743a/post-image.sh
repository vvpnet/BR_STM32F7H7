#!/bin/sh
# Deploy image and dtb to ResultDir

ver_uboot="2018.11"
ver_kernel="5.10.83"
dir_publish1="${BR2_EXTERNAL_STM32F7H7_PATH}/stm32h743a/images"

echo "Publish1 Files to" ${dir_publish1}

echo "Copy zImage to " ${dir_publish1}
cp ${BINARIES_DIR}/zImage ${dir_publish1}

#echo "Copy uImage to " ${dir_publish1}
#cp ${BINARIES_DIR}/uImage ${dir_publish1}

echo "Copy dtb to" ${dir_publish1}
cp ${BUILD_DIR}/linux-${ver_kernel}/arch/arm/boot/dts/stm32h743i-eval.dtb ${dir_publish1}/stm32h743-apollo.dtb

echo "Copy uboot.bin to" ${dir_publish1}
cp ${BUILD_DIR}/uboot-${ver_uboot}/u-boot.bin ${dir_publish1}/uboot-stm32h743-apollo.bin

#echo "Copy spl-uboot.bin to" ${dir_publish1}
#cp ${BUILD_DIR}/uboot-${ver_uboot}/spl/u-boot-spl.bin ${dir_publish1}/spl-uboot-stm32h743-apollo.bin
