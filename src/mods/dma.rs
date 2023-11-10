use core::panic;

use crate::mods::bus::BusType;
use crate::mods::gpu_memory::{VIDEO_RAM_END, VIDEO_RAM_START};
use crate::mods::graphics::Graphics;

pub const DMA_REG: u16 = 0xFF46;
pub const DMA_SRC_MUL: u16 = 0x0100;
pub const DMA_MAX_CYCLES: u16 = 159;

pub struct OamDma {
    dma: u8,
    value: u8,
    cycles: u16,
    delay_cycles: usize,
    in_transfer: bool,
    bus_conflict: BusType,
}

impl OamDma {
    pub fn new() -> OamDma {
        OamDma {
            dma: 0, // 0xFF46
            value: 0,   // The current byte being transferred
            cycles: 0,
            delay_cycles: 0,
            in_transfer: false,
            bus_conflict: BusType::None,
        }
    }

    pub fn init(&mut self) {
        self.dma = 0xFF;
    }

    pub fn read_dma(&self, addr: u16) -> u8 {
        if addr != DMA_REG {
            panic!("dma should not write to addr: {:04X}", addr);
        }
        self.dma
    }

    pub fn write_dma(&mut self, addr: u16, data: u8) {
        if addr != DMA_REG {
            panic!("dma should not write to addr: {:04X}", addr);
        }

        if data >= 0xFE {
            self.dma = data & 0xDF;
        } else {
            self.dma = data;
        }

        self.start_dma_countdown();
    }
    pub fn set_value(&mut self, value: u8) {
        self.value = value;
    }

    pub fn start_dma_countdown(&mut self) {
        self.delay_cycles = 2;
    }

    pub fn dma_active(&self) -> bool {
        self.in_transfer
    }

    pub fn calc_addr(&mut self) -> u16 {
        (self.dma as u16 * DMA_SRC_MUL) + self.cycles
    }
    pub fn cycles(&self) -> u16 {
        self.cycles
    }

    pub fn delay_rem(&self) -> usize {
        self.delay_cycles
    }

    pub fn incr_cycles(&mut self, graphics: &mut Graphics) {
        self.cycles += 1;
        if self.cycles > DMA_MAX_CYCLES {
            self.stop_dma_transfer();
            graphics.set_dma_transfer(false);
        }
    }

    pub fn stop_dma_transfer(&mut self) {
        self.in_transfer = false;
        self.cycles = 0;
        self.bus_conflict = BusType::None;
    }

    pub fn decr_delay(&mut self, graphics: &mut Graphics) {
        self.delay_cycles -= 1;
        if self.delay_cycles == 0 {
            self.start_dma_transfer();
            graphics.set_dma_transfer(true);
        }
    }

    pub fn start_dma_transfer(&mut self) {
        self.in_transfer = true;
        self.cycles = 0;

        self.bus_conflict = match self.calc_addr() {
            VIDEO_RAM_START..=VIDEO_RAM_END => BusType::Video,
            0x0000..=0x7FFF | 0xA000..=0xFDFF => BusType::External,
            _ => panic!("addr should be between 0x0000 and 0xFDFF: dma: {}", self.dma),
        };
    }
}
