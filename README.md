## Rust on ARM Cortex A9:

This project implements a blinking LED on ARM Cortex A9.

# Compiling:
make all

Upload the resulting binary (one of binky.elf) on the target.

# Structure:
  * main.rs - sample program (blinks a led on the ARM Cortex A9)
  * sys/ - bootstrap code (boot loader and system initialization)
  * zero/ - zero and addition al C stubs
