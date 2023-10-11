use crate::mods::keypad::Keypad;

pub struct Bus {
    pub memory: [u8; 0xFFFF],
    pub keypad: Keypad
}

impl Bus {

    pub fn new() -> Bus {
        Bus {
            memory: [0; 0xFFFF],
            keypad: Keypad::new()
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

    pub fn update_input(self: &mut Self) -> bool {
        let should_exit = self.keypad.update_input();
        if self.keypad.is_joypad_interrupt() {
            self.io.request_joypad_interrupt();
        }
        return should_exit;
    }
}