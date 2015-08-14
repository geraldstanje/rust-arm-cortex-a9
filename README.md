## Rust on ARM Cortex A9:

1. Implement a blinking LED app on ARM Cortex A9 using C ... completed 
2. Implement a blinking LED app on ARM Cortex A9 using Rust ... in progress
3. Create a template project for using the Rust language on bare metal ARM Cortex A9 ... not started
4. Integrate with Zinc [3], the bare metal stack for rust ... not started

# Compiling:
./build.sh

The output will be a binary called app_cpu1.elf.

ARM Core 0 runs Ubuntu Linux and ARM Core 1 will load app_cpu1.elf using the remoteproc kernel module. For more information see Henrys blog [4].

# Structure:
  * main.rs - sample program (blinks a LED on the ARM Cortex A9)
  * runtime.rs - rust runtime functions, e.g. panic
  * sys/ - bootstrap code (boot loader and system initialization)
  * orig/ - includes the original C code implementing a blinking LED app
  * libcore/ - libcore built for the target description

# References:
  * [1]: https://github.com/neykov/armboot
  * [2]: https://github.com/antoinealb/rust-demo-cortex-m4
  * [3]: https://github.com/hackndev/zinc
  * [4]: http://henryomd.blogspot.co.at/2015/02/zynq-amp-linux-on-cpu0-and-bare-metal.html
