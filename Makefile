# Binaries will be generated with this name (.elf)
PROJ_NAME=app_cpu1

RUSTC=rustc

AS=arm-xilinx-eabi-as
CC=arm-xilinx-eabi-gcc
AR=arm-xilinx-eabi-ar
RANLIB=arm-xilinx-eabi-ranlib
OBJCOPY=arm-xilinx-eabi-objcopy

SHELL = /bin/bash

# Put your source files here (or *.c, etc)
# add startup file to build
SRCS := $(shell echo sys/*.{c,S})

OBJS := $(SRCS:.c=.o)
OBJS += $(SRCS:.S=.o)

AFLAGS = -mcpu=cortex-a9

CFLAGS = -g -O0 -Wall -DUSE_AMP=1 -DSTDOUT_REDIR=1
CFLAGS += -mlittle-endian $(AFLAGS)
CFLAGS += -Isys -Isys/ps7_cortexa9_1/include
LDFLAGS = -Tsys/lscript.ld $(AFLAGS)
LIBRARIES = -lcompiler-rt -lgcc -lc

RUSTFLAGS = -A non_camel_case_types -A dead_code -A non_snake_case
RUSTFLAGS += --target target.json -C link-args="$(LDFLAGS)"
RUSTFLAGS += -L.
RUSTFLAGS += -L libcore

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

.S.o:
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: proj

all: $(PROJ_NAME).elf

libcompiler-rt.a: $(OBJS)
	$(AR) rcs $@ $(OBJS)

#libcompiler-rt.a:
#	cp orig/bare_metal_test.cpu1/app_cpu1_bsp/ps7_cortexa9_1/lib/libxil.a libcompiler-rt.a

$(PROJ_NAME).elf: libcompiler-rt.a main.rs
	$(RUSTC) $(RUSTFLAGS) $(LIBRARIES) main.rs -o $@ -Z print-link-args

clean:
	rm -f libcompiler-rt.a *.o sys/*.o $(PROJ_NAME).elf
