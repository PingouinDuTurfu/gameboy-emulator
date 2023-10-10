use crate::mods::key_pad::Keypad;

pub struct MemoryBus {
    pub memory: [u8; 0xFFFF],
    pub key_pad: Keypad
}

impl MemoryBus {

    pub fn new() -> MemoryBus {
        MemoryBus {
            memory: [0; 0xFFFF],
            key_pad: Keypad::new()
        }
    }

    pub fn read_byte(&self, address: u16) -> u8 {
        self.memory[address as usize]
    }

    pub fn write_byte(&mut self, address: u16, value: u8) {
        self.memory[address as usize] = value;
    }

    pub fn write_word(&mut self, address: u16, value: u16) {
        self.memory[address as usize] = (value & 0xFF) as u8;
        self.memory[(address + 1) as usize] = ((value >> 8) & 0xFF) as u8;
    }
}