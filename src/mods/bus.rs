use sdl2::EventPump;
use sdl2::render::Texture;

use crate::mods::to_remvoe::graphics::Graphics;
use crate::mods::to_remvoe::dma::{DMA_REG, OamDma};
use crate::mods::input_output::{IF_REG, InputOutput};
use crate::mods::keypad::{Keypad, KEYPAD_REGISTER};
use crate::mods::mbc_default::MbcDefault;
use crate::mods::memory::Memory;
use crate::mods::serial::{SB_REG, SC_REG, Serial};
use crate::mods::gpu_memory::{OBJECT_ATTRIBUTE_MEMORY_END, OBJECT_ATTRIBUTE_MEMORY_START, PHYSICS_PROCESSING_UNIT_IO_END, PHYSICS_PROCESSING_UNIT_IO_START, UNUSED_END, UNUSED_START, VIDEO_RAM_END, VIDEO_RAM_START};

pub enum BusType {
    Video,    //0x8000-0x9FFF
    External, //0x0000-0x7FFF, 0xA000-0xFDFF
    None,
}

impl BusType {
    pub fn is_some(self: &Self) -> bool {
        return if let BusType::None = self {
            false
        } else {
            true
        };
    }
}

pub struct Bus {
    pub memory: Memory,
    pub input_output: InputOutput,
    pub graphics: Graphics,
    pub keypad: Keypad,
    pub serial: Serial,
    pub oam_dma: OamDma
}

impl Bus {

    pub fn new() -> Bus {
        Bus {
            memory: Memory::new(),
            input_output: InputOutput::new(),
            graphics: Graphics::new(),
            keypad: Keypad::new(),
            serial: Serial::new(),
            oam_dma: OamDma::new(),
        }
    }

    pub fn init(self: &mut Self) {
        self.memory.init();
        self.input_output.init();
        self.graphics.init();
        self.keypad.init();
        self.serial.init();
        self.oam_dma.init();
    }

    pub fn set_mbc(self: &mut Self, cart_mbc: MbcDefault) {
        self.memory.set_mbc(cart_mbc);
    }

    pub fn read_byte(&self, address: u16) -> u8 {
        match address {
            VIDEO_RAM_START..=VIDEO_RAM_END => self.graphics.read_byte(address),
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => self.graphics.read_byte(address),
            KEYPAD_REGISTER => self.keypad.read_byte(address),
            DMA_REG => self.oam_dma.read_dma(address),
            UNUSED_START..=UNUSED_END => self.graphics.read_byte(address),
            PHYSICS_PROCESSING_UNIT_IO_START..=PHYSICS_PROCESSING_UNIT_IO_END => self.graphics.read_io_byte(address),
            0xFF10..=0xFF2F => 0x0000,
            SB_REG | SC_REG => self.serial.read_byte(address),
            0xFF03..=0xFF0F => self.input_output.read_byte(address),
            0xFF4C..=0xFF7F => self.input_output.read_byte(address),
            _ => self.memory.read_byte(address),
        }
    }

    pub fn write_byte(&mut self, address: u16, value: u8) {
        // println!("Bus : Write to {:04X} : {:02X}", address, value);
        // if address == KEYPAD_REGISTER {
        //     println!("Keypad write: {:02X} => ", value)
        // }
        match address {
            VIDEO_RAM_START..=VIDEO_RAM_END => self.graphics.write_byte(address, value),
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => self.graphics.write_byte(address, value),
            KEYPAD_REGISTER => self.keypad.write_byte(address, value),
            DMA_REG => self.oam_dma.write_dma(address, value),
            UNUSED_START..=UNUSED_END => self.graphics.write_byte(address, value),
            PHYSICS_PROCESSING_UNIT_IO_START..=PHYSICS_PROCESSING_UNIT_IO_END => self.graphics.write_io_byte(address, value),
            0xFF10..=0xFF2F => (),
            SB_REG | SC_REG => self.serial.write_byte(address, value),
            0xFF03..=0xFF0F => self.input_output.write_byte(address, value),
            0xFF4C..=0xFF7F => self.input_output.write_byte(address, value),
            _ => self.memory.write_byte(address, value),
        }
    }

    pub fn write_word(&mut self, address: u16, value: u16) {
        self.write_byte(address, (value & 0xFF) as u8);
        self.write_byte(address + 1, ((value & 0xFF00) >> 8) as u8);
    }

    pub fn update_input(self: &mut Self) -> bool {
        let should_exit = self.keypad.update_input();
        if self.keypad.is_keypad_interrupt() {
            println!("Keypad interrupt");
            self.input_output.request_keypad_interrupt();
        }
        return should_exit;
    }

    pub fn set_keypad(self: &mut Self, event_pump: EventPump) {
        self.keypad.set_keypad(event_pump);
    }

    pub fn interrupt_pending(self: &Self) -> bool {
        // println!("Interrupt pending");
        (self.memory.interrupt_enable & self.input_output.read_byte(IF_REG) & 0x1F) != 0
    }

    pub fn adv_cycles(self: &mut Self, cycles: usize) {
        // self.timer.adv_cycles(&mut self.io, cycles);
        // self.serial.adv_cycles(&mut self.input_output, cycles);
        self.graphics.adv_cycles(&mut self.input_output, cycles);
        // self.memory.adv_cycles(cycles);
        // self.sound.adv_cycles(cycles);
        //
        if self.oam_dma.dma_active() {
            self.handle_dma_transfer();
        }
        if self.oam_dma.delay_rem() > 0 {
            self.oam_dma.decr_delay(&mut self.graphics);
        }
    }

    fn handle_dma_transfer(self: &mut Self) {
        let addr = self.oam_dma.calc_addr();
        let value = self.read_byte_for_dma(addr);

        self.oam_dma.set_value(value);
        self.write_byte_for_dma(self.oam_dma.cycles(), value);
        self.oam_dma.incr_cycles(&mut self.graphics);
    }

    fn read_byte_for_dma(self: &Self, addr: u16) -> u8 {
        let byte = match addr {
            VIDEO_RAM_START..=VIDEO_RAM_END => self.graphics.read_byte_for_dma(addr),
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => self.graphics.read_byte_for_dma(addr),
            DMA_REG => self.oam_dma.read_dma(addr),
            UNUSED_START..=UNUSED_END => self.graphics.read_byte_for_dma(addr),
            KEYPAD_REGISTER => self.keypad.read_byte(addr),
            SB_REG | SC_REG => self.serial.read_byte(addr),
            // TIMER_START..=TIMER_END => self.timer.read_byte(addr),
            // SOUND_START..=SOUND_END => self.sound.read_byte(addr),
            // PCM12 | PCM34 => self.sound.read_byte(addr),
            // WAVE_RAM_START..=WAVE_RAM_END => self.sound.read_byte(addr),
            0xFF03..=0xFF0F => self.input_output.read_byte(addr),
            0xFF4C..=0xFF7F => self.input_output.read_byte(addr),
            _ => self.memory.read_byte_for_dma(addr),
        };
        return byte;
    }

    // dma should be allowed to write to oam regardless of ppu state
    // use this function to bypass any protections
    fn write_byte_for_dma(self: &mut Self, addr: u16, data: u8) {
        self.graphics.write_byte_for_dma(addr, data);
    }
    pub fn update_display(self: &mut Self, texture: &mut Texture) -> bool {
        return self.graphics.update_display(texture);
    }
}