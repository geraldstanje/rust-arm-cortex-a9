## Rust on ARM Cortex A9:

In the first step the project will implement a blinking LED on ARM Cortex A9. <br />
The next step is to create a template project for using the Rust language on bare metal ARM Cortex A9. <br />
The final version should be integrated with the bare metal stack for rust http://zinc.rs

# Compiling:
make all

The output will be a binary called blinky.elf. <br />
ARM Core0 runs Ubuntu Linux and ARM Core1 will load blinky.elf using the remoteproc kernel module. For more information see henrys blog.

# Structure:
  * main.rs - sample program (blinks a LED on the ARM Cortex A9)
  * sys/ - bootstrap code (boot loader and system initialization)
  * zero/ - zero and addition al C stubs
  * orig/ - includes the original C code implementing a blinking LED
  * libcore/ - libcore built for the target description

# References:
  * https://github.com/neykov/armboot
  * https://github.com/antoinealb/rust-demo-cortex-m4
  * https://github.com/hackndev/zinc
  * http://henryomd.blogspot.co.at/2015/02/zynq-amp-linux-on-cpu0-and-bare-metal.html
