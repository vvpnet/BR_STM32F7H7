Linux on the STM32F767IGT6-LQFP176 board with Buildroot
======================================================

The project is a set of patches and configuration files to build a bootloader and a Linux based system image with a minimal root file system for the great [STM32F767IGT6 board](https://www.st.com/en/microcontrollers-microprocessors/stm32f767ig.html).

Board peripherals support
-------------------------

See this [overview of board peripherals support](doc/Board_peripherals_support.md).


Build
-----

Let's download, extract and patch Buildroot:

`$ make bootstrap`


Then build:

`$ make build`


After the build, the directory `stm32f767/ImageLinux` contains 
 - U-Boot images `u-boot-spl.bin` and `u-boot.bin`
 - compressed Linux kernel with linked RAM filesystem `zImage`
 - device tree blob `stm32f767-lqfp176.dtb`

![alt text](https://github.com/vvpnet/STM32F767IGT6-LQFP176_board_Buildroot/blob/master/doc/STM32F767-Cortex-M7-STM32F767IGT6-STM32.jpg)

Changelog
---------

* 0.3
  * SUPPORT QSPI (25q128fvsg)
  * FIX ALLOCATOR RAM
  * The kernel version 5.6.x is used, it is smaller size than 5.10. But we will return to version 5.10.

* 0.2
  * U-Boot 2021.10
  * Linux 5.10.х (support until 2026)
  * Busybox 1.34.x

* 0.1
  * Buildroot 2021.11
  * GCC 11.x.x
  * U-Boot 2021.10
  * Linux 4.14.256 (support until January 2024)
  * Busybox 1.34.x
