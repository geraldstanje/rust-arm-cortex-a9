#![allow(improper_ctypes)]
#![no_std]
#![no_main]
#![feature(lang_items)]
#![feature(int_uint)] // update fail_bounds_check
#![feature(no_std)]
#![crate_name="blinky"]

use zero::std_types::*;

mod zero {
	pub mod std_types;
	pub mod zero;
}

//extern crate core;

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
  name: &'static[u8; 32], // TODO: not sure if the type is right
}

#[link_section=".rtable"]
struct rproc_resource
{
  base: resource_table,
  code_cout: fw_rsc_carveout,
} 

const ti_ipc_remoteproc_ResourceTable: rproc_resource = rproc_resource {
  base: resource_table { ver: 1, num: 1, reserved: [0, 0], offset: [0], // TODO: not sure if that represents the C code: { offsetof(struct rproc_resource, code_cout) }
  },
  code_cout: fw_rsc_carveout { type_: fw_resource_type::RSC_CARVEOUT as u32, da: RAM_ADDR, pa: RAM_ADDR, len: 524288, //1<<19 
               flags: 0, reserved: 0, name: b"blinky\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0", 
  },
};

#[no_mangle]
pub fn set_led() {
	let led_port: *mut u32;

	unsafe {
		led_port = 0x40000030 as *mut u32;
	}

	unsafe {
		*led_port = 2;
	}
}

#[no_mangle]
pub extern "C" fn main() {
	while (true) {
		set_led();
	}
}
