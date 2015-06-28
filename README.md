## Rust on ARM Cortex A9:

In the first step the project will implement a blinking LED on ARM Cortex A9. <br />
The next step is to create a template project for using the Rust language on bare metal ARM Cortex A9. <br />
The final version should be integrated with the bare metal stack for rust http://zinc.rs

# Compiling:
make all

Upload the resulting binary (one of binky.elf) on the target.

# Structure:
  * main.rs - sample program (blinks a led on the ARM Cortex A9)
  * sys/ - bootstrap code (boot loader and system initialization)
  * zero/ - zero and addition al C stubs
  * orig/ - includes the original C code implementing a blinking LED
  * libcore - libcore built for the target description
