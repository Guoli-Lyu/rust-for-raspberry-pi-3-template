#![feature(
    compiler_builtins_lib,
    lang_items,
    panic_implementation,
    asm,
    global_asm
)]
#![no_builtins]
#![no_std]
#![no_main]

use core::panic::PanicInfo;

// #[lang = "eh_personality"] pub extern fn eh_personality() {}

#[panic_implementation]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

const GPIO_BASE: usize = 0x3F000000 + 0x200000;

const GPIO_FSEL1: *mut u32 = (GPIO_BASE + 0x04) as *mut u32;
const GPIO_SET0: *mut u32 = (GPIO_BASE + 0x1C) as *mut u32;
const GPIO_CLR0: *mut u32 = (GPIO_BASE + 0x28) as *mut u32;

#[inline(never)]
fn spin_sleep_ms(ms: usize) {
    for _ in 0..(ms * 600) {
        unsafe {
            asm!("nop" :::: "volatile");
        }
    }
}

#[no_mangle]
pub unsafe extern "C" fn main() {}

global_asm!(include_str!("crt0.S"));
