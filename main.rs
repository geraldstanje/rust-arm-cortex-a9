#![allow(improper_ctypes)]
#![no_std]
#![feature(lang_items)]
#![feature(no_std)]
#![feature(intrinsics)]
#![feature(core)]
#![feature(start)]

extern crate core;

mod runtime;

extern "rust-intrinsic" { pub fn volatile_load<T>(src: *const T) -> T; }
extern "rust-intrinsic" { pub fn volatile_store<T>(src: *mut T, value: T); }

const RAM_ADDR: u32 = 0x1e000000;

#[repr(packed)]
struct resource_table
{
  ver: u32,
  num: u32,
  reserved: [u32; 2],
  offset: [u32; 1],
}

#[repr(u8)]
enum fw_resource_type
{
  RSC_CARVEOUT = 0,
  RSC_DEVMEM = 1,
  RSC_TRACE = 2,
  RSC_VDEV = 3,
  RSC_MMU = 4,
  RSC_LAST = 5,
}

#[repr(packed)]
struct fw_rsc_carveout
{
  type_: u32,
  da: u32,
  pa: u32,
  len: u32,
  flags: u32,
  reserved: u32,
  name: [u8; 32], // TODO: not sure if the type is right
}

pub struct rproc_resource
{
  base: resource_table,
  code_cout: fw_rsc_carveout,
}

#[link_section=".rtable"]
pub static mut ti_ipc_remoteproc_ResourceTable: rproc_resource = rproc_resource {
  base: resource_table { ver: 1, num: 1, reserved: [0, 0], offset: [20], // TODO: not sure if that represents the C code: { offsetof(struct rproc_resource, code_cout) }
  },
  code_cout: fw_rsc_carveout { type_: fw_resource_type::RSC_CARVEOUT as u32, da: RAM_ADDR, pa: RAM_ADDR, len: 1<<19, 
               flags: 0, reserved: 0, name: *b"APP_CPU1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 
  },
};

#[no_mangle]
pub fn set_led() {
  let led_port: *mut u32 = 0x40000030 as *mut u32;

  unsafe {
    *led_port = 20; // set LED2 and LED4
  }
}

#[no_mangle]
pub fn clear_led() {
  let led_port: *mut u32 = 0x40000030 as *mut u32;

  unsafe {
    *led_port = 0; // clear LED2 and LED4
  }
}

#[no_mangle]
pub fn toogle_led(led_port: *mut u32, led_pin: u32) {
  unsafe {
      *led_port ^= 1 << led_pin;
  }
}

#[start]
fn start(_: isize, _: *const *const u8) -> isize {
  main();
  return 0;
}

pub fn main() {
  unsafe {
    volatile_load(&ti_ipc_remoteproc_ResourceTable);
  }

  let led_port: *mut u32 = 0x40000030 as *mut u32;

  loop {
    let mut i: u32 = 0;

    while i < 10000000u32 { i += 1; }
    i = 0;
    while i < 10000000u32 { i += 1; }

    toogle_led(led_port, 2);
    toogle_led(led_port, 4);    
  }
}