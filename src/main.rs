#![no_main]
#![no_std]

use panic_halt as _;
use stm32ral::{write_reg, rcc, gpio};

#[cortex_m_rt::entry]
unsafe fn main1() -> ! {
    write_reg!(rcc, RCC, AHB4ENR, GPIOBEN: Enabled);
    write_reg!(gpio, GPIOB, MODER, MODER0: Output, MODER14: Output);
    write_reg!(gpio, GPIOB, ODR, 0);
    loop {
        write_reg!(gpio, GPIOB, BSRR, BS0: 1);
        cortex_m::asm::delay(16_000_000);
        write_reg!(gpio, GPIOB, BSRR, BR0: 1);
        cortex_m::asm::delay(16_000_000);
    }
}

#[no_mangle]
unsafe extern "C" fn main2() -> ! {
    loop {
        write_reg!(gpio, GPIOB, BSRR, BS14: 1);
        cortex_m::asm::delay(16_000_000);
        write_reg!(gpio, GPIOB, BSRR, BR14: 1);
        cortex_m::asm::delay(16_000_000);
    }
}

#[repr(C)]
pub struct VTable {
    sp: u32,
    pc: unsafe extern "C" fn() -> !,
}

#[no_mangle]
#[link_section=".flash2.vector_table"]
pub static CPU2_VTABLE: VTable = VTable {
    sp: 0x30020000,
    pc: main2
};
