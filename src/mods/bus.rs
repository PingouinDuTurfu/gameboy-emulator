use sdl2::EventPump;
use sdl2::render::Texture;

use crate::mods::dma::{DMA_REG, OamDma};
use crate::mods::gpu_memory::{OBJECT_ATTRIBUTE_MEMORY_END, OBJECT_ATTRIBUTE_MEMORY_START, PHYSICS_PROCESSING_UNIT_IO_END, PHYSICS_PROCESSING_UNIT_IO_START, UNUSED_END, UNUSED_START, VIDEO_RAM_END, VIDEO_RAM_START};
use crate::mods::graphics::Graphics;
use crate::mods::input_output::{IF_REG, InputOutput};
use crate::mods::keypad::{Keypad, KEYPAD_REGISTER};
use crate::mods::mbc_5::Mbc5;
use crate::mods::mbc_default::MbcDefault;
use crate::mods::memory::Memory;
use crate::mods::timer::{Timer, TIMER_END, TIMER_START};

pub const SB_REG: u16 = 0xFF01;
pub const SC_REG: u16 = 0xFF02;

pub enum BusType {
    Video,    //0x8000-0x9FFF
    External, //0x0000-0x7FFF, 0xA000-0xFDFF
    None,
}
pub struct Bus {
    pub memory: Memory,
    pub input_output: InputOutput,
    pub graphics: Graphics,
    pub keypad: Keypad,
    pub oam_dma: OamDma,
    pub timer: Timer
}

impl Bus {

    pub fn new() -> Bus {
        Bus {
            memory: Memory::new(),
            input_output: InputOutput::new(),
            graphics: Graphics::new(),
            keypad: Keypad::new(),
            oam_dma: OamDma::new(),
            timer: Timer::new()
        }
    }

    pub fn init(&mut self) {
        self.memory.init();
        self.input_output.init();
        self.graphics.init();
        self.keypad.init();
        self.oam_dma.init();
        self.timer.init();
    }

    pub fn set_mbc_default(&mut self, cart_mbc: MbcDefault) {
        self.memory.set_mbc(cart_mbc);
    }

    pub fn set_mbc_5(&mut self, cart_mbc: Box<Mbc5>) {
        self.memory.set_mbc_5(cart_mbc);
    }

    pub fn read_byte(&self, address: u16) -> u8 {
        match address {
            VIDEO_RAM_START..=VIDEO_RAM_END => self.graphics.read_byte(address),
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => self.graphics.read_byte(address),
            KEYPAD_REGISTER => self.keypad.read_byte(address),
            DMA_REG => self.oam_dma.read_dma(address),
            UNUSED_START..=UNUSED_END => self.graphics.read_byte(address),
            PHYSICS_PROCESSING_UNIT_IO_START..=PHYSICS_PROCESSING_UNIT_IO_END => self.graphics.read_io_byte(address),
            SB_REG | SC_REG => 0x0000,
            TIMER_START..=TIMER_END => self.timer.read_byte(address),
            0xFF10..=0xFF2F => 0x0000,
            0xFF03..=0xFF0F => self.input_output.read_byte(address),
            0xFF4C..=0xFF7F => self.input_output.read_byte(address),
            0xFF30..=0xFF3F => 0x0000,
            _ => self.memory.read_byte(address),
        }
    }

    pub fn write_byte(&mut self, address: u16, value: u8) {
        match address {
            VIDEO_RAM_START..=VIDEO_RAM_END => self.graphics.write_byte(address, value),
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => self.graphics.write_byte(address, value),
            KEYPAD_REGISTER => self.keypad.write_byte(address, value),
            DMA_REG => self.oam_dma.write_dma(address, value),
            UNUSED_START..=UNUSED_END => self.graphics.write_byte(address, value),
            PHYSICS_PROCESSING_UNIT_IO_START..=PHYSICS_PROCESSING_UNIT_IO_END => self.graphics.write_io_byte(address, value),
            TIMER_START..=TIMER_END => self.timer.write_byte(address, value),
            SB_REG | SC_REG => (),
            0xFF10..=0xFF2F => (),
            0xFF03..=0xFF0F => self.input_output.write_byte(address, value),
            0xFF4C..=0xFF7F => self.input_output.write_byte(address, value),
            0xFF30..=0xFF3F => (),
            _ => self.memory.write_byte(address, value),
        }
    }

    pub fn write_word(&mut self, address: u16, value: u16) {
        self.write_byte(address, (value & 0xFF) as u8);
        self.write_byte(address + 1, ((value & 0xFF00) >> 8) as u8);
    }

    pub fn update_input(&mut self) -> bool {
        let should_exit = self.keypad.update_input();
        if self.keypad.is_keypad_interrupt() {
            self.input_output.request_keypad_interrupt();
        }
        should_exit
    }

    pub fn set_keypad(&mut self, event_pump: EventPump) {
        self.keypad.set_keypad(event_pump);
    }

    pub fn interrupt_pending(&self) -> bool {
        (self.memory.interrupt_enable() & self.input_output.read_byte(IF_REG) & 0x1F) != 0
    }

    pub fn adv_cycles(&mut self, cycles: usize) {
        self.timer.adv_cycles(&mut self.input_output, cycles);
        self.graphics.adv_cycles(&mut self.input_output, cycles);
        if self.oam_dma.dma_active() {
            self.handle_dma_transfer();
        }
        if self.oam_dma.delay_rem() > 0 {
            self.oam_dma.decr_delay(&mut self.graphics);
        }
    }

    fn handle_dma_transfer(&mut self) {
        let addr = self.oam_dma.calc_addr();
        let value = self.read_byte_for_dma(addr);

        self.oam_dma.set_value(value);
        self.write_byte_for_dma(self.oam_dma.cycles(), value);
        self.oam_dma.incr_cycles(&mut self.graphics);
    }

    fn read_byte_for_dma(&self, addr: u16) -> u8 {
        match addr {
            VIDEO_RAM_START..=VIDEO_RAM_END => self.graphics.read_byte_for_dma(addr),
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => self.graphics.read_byte_for_dma(addr),
            DMA_REG => self.oam_dma.read_dma(addr),
            UNUSED_START..=UNUSED_END => self.graphics.read_byte_for_dma(addr),
            KEYPAD_REGISTER => self.keypad.read_byte(addr),
            SB_REG | SC_REG => 0x0000,
            TIMER_START..=TIMER_END => self.timer.read_byte(addr),
            0xFF03..=0xFF0F => self.input_output.read_byte(addr),
            0xFF4C..=0xFF7F => self.input_output.read_byte(addr),
            _ => self.memory.read_byte_for_dma(addr),
        }
    }

    fn write_byte_for_dma(&mut self, addr: u16, data: u8) {
        self.graphics.write_byte_for_dma(addr, data);
    }
    pub fn update_display(&mut self, texture: &mut Texture) -> bool {
        self.graphics.update_display(texture)
    }
}