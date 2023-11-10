pub const IO_START: u16 = 0xFF00; // Base address for input/output registers.
pub const IF_REG: u16 = 0xFF0F; // Interrupt Flag Register for tracking hardware interrupts.

pub struct InputOutput {
    input_output: [u8; 128],
    if_register_trigger: bool,
}

impl InputOutput {
    pub fn new() -> InputOutput {
        InputOutput {
            input_output: [0xFF; 128],
            if_register_trigger: false,
        }
    }

    pub fn init(&mut self) {
        self.input_output[usize::from(IF_REG - IO_START)] = 0xE1;
        self.input_output[usize::from(0xFF03 - IO_START)] = 0xFF;
    }

    pub fn read_byte(&self, addr: u16) -> u8 {
        return self.input_output[usize::from(addr - IO_START)];
    }

    pub fn write_byte(&mut self, address: u16, data: u8) {
        match address {
            IF_REG => {
                self.input_output[usize::from(IF_REG  - IO_START)] = data | 0xE0;
                self.if_register_trigger = true;
            }
            _ => return,
        }
    }

    pub fn clean_if_register_trigger(&mut self) {
        self.if_register_trigger = false;
    }

    pub fn request_keypad_interrupt(&mut self) {
        let if_register_trigger = usize::from(IF_REG - IO_START);
        self.input_output[if_register_trigger] = self.input_output[if_register_trigger] | 0xF0;
    }

    pub fn request_timer_interrupt(&mut self) {
        if !self.if_register_trigger {
            let if_register_trigger = usize::from(IF_REG - IO_START);
            self.input_output[if_register_trigger] = self.input_output[if_register_trigger] | 0xE4;
        }
    }

    pub fn request_stat_interrupt(&mut self) {
        let if_register_trigger = usize::from(IF_REG - IO_START);
        self.input_output[if_register_trigger] = self.input_output[if_register_trigger] | 0xE2;
    }

    pub fn request_vertical_blank_interrupt(&mut self) {
        let if_register_trigger = usize::from(IF_REG - IO_START);
        self.input_output[if_register_trigger] = self.input_output[if_register_trigger] | 0xE1;
    }
}