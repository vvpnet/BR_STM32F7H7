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

![alt text](https://github.com/vvpnet/STM32F746G_Buildroot/blob/master/doc/stm32f746g-disco_linux.png)

Changelog
---------

* 0.1
  * Buildroot 2021.11
  * GCC 11.x.x (external)
  * U-Boot 2021.11
  * Linux 4.14.256 (support until January 2024)
  * Busybox 1.34.x
