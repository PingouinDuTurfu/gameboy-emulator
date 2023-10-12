use sdl2::EventPump;
use crate::mods::input_output::{IF_REG, InputOutput};
use crate::mods::keypad::{Keypad, KEYPAD_REGISTER};
use crate::mods::mbc_default::MbcDefault;
use crate::mods::memory::Memory;


pub struct Bus {
    pub memory: Memory,
    pub input_output: InputOutput,
    pub keypad: Keypad
}

impl Bus {

    pub fn new() -> Bus {
        Bus {
            memory: Memory::new(),
            input_output: InputOutput::new(),
            keypad: Keypad::new()
        }
    }

    pub fn init(self: &mut Self) {
        // self.memory.init();
        self.input_output.init();
        self.keypad.init();
    }

    pub fn set_mbc(self: &mut Self, cart_mbc: MbcDefault) {
        self.memory.set_mbc(cart_mbc);
    }

    pub fn read_byte(&self, address: u16) -> u8 {
        match address {
            KEYPAD_REGISTER => self.keypad.read_byte(address),
            0xFF03..=0xFF0F => self.input_output.read_byte(address),
            0xFF4C..=0xFF7F => self.input_output.read_byte(address),
            _ => self.memory.read_byte(address),
        }
    }

    pub fn write_byte(&mut self, address: u16, value: u8) {
        match address {
            KEYPAD_REGISTER => self.keypad.write_byte(address, value),
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
            self.input_output.request_keypad_interrupt();
        }
        return should_exit;
    }

    pub fn set_keypad(self: &mut Self, event_pump: EventPump) {
        self.keypad.set_keypad(event_pump);
    }

    pub fn interrupt_pending(self: &Self) -> bool {
        (self.memory.interrupt_enable & self.memory.read_byte(IF_REG) & 0x1F) != 0
    }
}