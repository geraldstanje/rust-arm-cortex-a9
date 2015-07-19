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
#SRCS := $(shell echo sys/*.{c,S})

#SRCS := $(shell echo sys/scugic_v3_0/src/*.c)
#SRCS += $(shell echo sys/scutimer_v2_1/src/*.c)
#SRCS += $(shell echo sys/profile/*.c)
#SRCS += $(shell echo sys/profile/*.S)
#SRCS += $(shell echo sys/*.c)
#SRCS += $(shell echo sys/*.S)

#SRCS = sys/xil_exception.c
#SRCS += sys/vectors.c
#SRCS += sys/asm_vectors.S
#SRCS += sys/boot.S
#SRCS += sys/cpu_init.S
#SRCS += sys/translation_table.S
#SRCS += sys/xil-crt0.S
#OBJS = $(SRCS:.c=.o)

#OBJS := $(SRCS:.c=.o)
#OBJS += $(SRCS:.S=.o)

#OBJS := $(patsubst %.c,%.o,${SRCS})
#OBJS := $(patsubst %.S,%.o,${SRCS})

AFLAGS = -mcpu=cortex-a9

CFLAGS = -g -O0 -Wall
CFLAGS += -mlittle-endian $(AFLAGS)
CFLAGS += -Isys/inc -Isys -Isys/profile -Isys/scutimer_v2_1/src -Isys/scugic_v3_0/src -Isys/cpu_cortexa9_v2_1/src -Isys/inc/core -Iorig/bare_metal_test.cpu1/app_cpu1_bsp/ps7_cortexa9_1/include -Iorig/bare_metal_test.cpu1/app_cpu1_bsp/ps7_cortexa9_1/libsrc/standalone_v5_0/src/
LDFLAGS = -Tsys/lscript.ld $(AFLAGS)
LIBRARIES = -lcompiler-rt -lgcc -lc

RUSTFLAGS = -A non_camel_case_types -A dead_code -A non_snake_case
RUSTFLAGS+= --target target.json -C link-args="$(LDFLAGS)"
RUSTFLAGS+= -L. -L libcore

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

.S.o:
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: proj

all: $(PROJ_NAME).elf

#libcompiler-rt.a: $(OBJS)
#	$(AR) rcs $@ $(OBJS)

libcompiler-rt.a:
	cp libxil.a libcompiler-rt.a

$(PROJ_NAME).elf: libcompiler-rt.a main.rs
	$(RUSTC) $(RUSTFLAGS) $(LIBRARIES) main.rs -o $@ -Z print-link-args

clean:
	rm -f libcompiler-rt.a $(PROJ_NAME).elf
