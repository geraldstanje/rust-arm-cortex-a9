#[lang="fail_bounds_check"]
fn fail_bounds_check(_: &(&'static str, u32),
                     _: u32, _: u32) -> ! {
    loop{}
}

//override system abort to avoid pulling in memory allocation dependencies
#[no_mangle]
pub extern "C" fn __aeabi_unwind_cpp_pr0() {
    loop{}
}


#[cold] #[inline(never)]
#[lang="panic_bounds_check"]
fn panic_bounds_check(_: &(&'static str, u32),
                     _: u32, _: u32) -> ! {
    loop{}
}

#[lang="phantom_fn"]
pub trait PhantomFn<A:?Sized,R:?Sized=()> { }
pub trait MarkerTrait : PhantomFn<Self> { }

#[lang = "copy"]
pub trait Copy : MarkerTrait {}

#[lang="sync"]
pub trait Sync : MarkerTrait {}

#[lang="stack_exhausted"]
extern fn stack_exhausted() {}

#[lang="eh_personality"]
extern fn eh_personality() {}

#[lang="panic_fmt"]
fn panic_fmt() -> ! {
    loop {}
}