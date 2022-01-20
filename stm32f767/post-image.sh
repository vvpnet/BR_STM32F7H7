#!/bin/sh
# Deploy image and dtb to ResultDir

dir_publish="/home/vpopov/minicom/send/linux"

echo "Copy zImage to " ${dir_publish}
cp ${BINARIES_DIR}/zImage ${dir_publish}
echo "Copy dtb to" ${dir_publish}
cp ${BUILD_DIR}/linux-4.14.256/arch/arm/boot/dts/stm32f746-disco.dtb ${dir_publish}/stm32f767-lqfp176.dtb
