# Binaries will be generated with this name (.elf)
PROJ_NAME=blinky

RUSTC=rustc

AS=arm-xilinx-eabi-as
CC=arm-xilinx-eabi-gcc
AR=arm-xilinx-eabi-ar
RANLIB=arm-xilinx-eabi-ranlib
OBJCOPY=arm-xilinx-eabi-objcopy

# Put your source files here (or *.c, etc)
# add startup file to build
SRCS = sys/boot.S
OBJS = $(SRCS:.S=.o)
AFLAGS = -mcpu=cortex-a9

CFLAGS = -g -O0 -Wall
CFLAGS += -mlittle-endian $(AFLAGS)
CFLAGS += -Isys/inc -Isys/inc/core -Iorig/bare_metal_test.cpu1/app_cpu1_bsp/ps7_cortexa9_1/include -Iorig/bare_metal_test.cpu1/app_cpu1_bsp/ps7_cortexa9_1/libsrc/standalone_v5_0/src/
LDFLAGS = -Tsys/lscript.ld $(AFLAGS)

RUSTFLAGS = -A non_camel_case_types -A dead_code -A non_snake_case
RUSTFLAGS+= --target target.json -C link-args="$(LDFLAGS)"
RUSTFLAGS+= -L. #-L libcore

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

.S.o:
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: proj

all: $(PROJ_NAME).elf

libcompiler-rt.a: $(OBJS)
	$(AR) rcs $@ $(OBJS)

$(PROJ_NAME).elf: main.rs libcompiler-rt.a
	$(RUSTC) $(RUSTFLAGS) main.rs -o $@ -Z print-link-args

clean:
	rm -f *.o libcompiler-rt.a sys/*.o $(PROJ_NAME).elf
