#!/bin/sh
# Deploy image and dtb to ResultDir

dir_publish1="${BR2_EXTERNAL_STM32F767_PATH}/stm32f767/ImageLinux"
dir_publish2="/home/vpopov/minicom/send/linux"

echo "Publish1 Files to" ${dir_publish1}
echo "Copy zImage to " ${dir_publish1}
cp ${BINARIES_DIR}/zImage ${dir_publish1}
echo "Copy dtb to" ${dir_publish1}
cp ${BUILD_DIR}/linux-4.14.256/arch/arm/boot/dts/stm32f746-disco.dtb ${dir_publish1}/stm32f767-lqfp176.dtb

if [ -d ${dir_publish2} ]; then
    echo "Publish2 Files to" ${dir_publish2}
    echo "Copy zImage to " ${dir_publish2}
    cp ${BINARIES_DIR}/zImage ${dir_publish2}
    echo "Copy dtb to" ${dir_publish1}
    cp ${BUILD_DIR}/linux-4.14.256/arch/arm/boot/dts/stm32f746-disco.dtb ${dir_publish2}/stm32f767-lqfp176.dtb
fi