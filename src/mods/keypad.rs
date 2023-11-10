use sdl2::event::Event;
use sdl2::EventPump;
use sdl2::keyboard::Keycode;

pub const KEYPAD_REGISTER: u16 = 0xFF00;

pub struct Keypad {
    event_pump: Option<EventPump>, // Event manager
    row_direction: u8,
    row_command: u8,
    data: u8,
    button_change: bool,
    something_selected: bool,
}

impl Keypad {
    pub fn new() -> Keypad {
        Keypad {
            event_pump: None,
            row_direction: 0x0F,
            row_command: 0x0F,
            data: 0xCF,
            button_change: false,
            something_selected: false,
        }
    }

    pub fn init(&mut self) {
        self.data = 0xFF;
    }

    pub fn read_byte(&self, address: u16) -> u8 {
        if !self.something_selected {
            return self.data | 0x0F;
        }
        match address {
            KEYPAD_REGISTER => self.data,
            _ => panic!("Keypad cannot read from addr: {:04X}", address),
        }
    }

    pub fn write_byte(&mut self, address: u16, data: u8) {
        match address {
            KEYPAD_REGISTER => {
                self.data = (data & 0x30) | (self.data & 0xCF);
                self.something_selected = (self.data & 0x20 == 0x20) ^ (self.data & 0x10 == 0x10);
            }
            _ => panic!("Keypad cannot write addr: {:04X}", address),
        };
    }

    pub fn is_keypad_interrupt(&self) -> bool {
        self.something_selected && self.button_change
    }

    pub fn set_keypad(&mut self, event_pump: EventPump) {
        self.event_pump = Some(event_pump);
    }

    pub(crate) fn update_input(&mut self) -> bool {
        let mut should_exit = false;

        if let Some(keypad) = &mut self.event_pump {
            let event = keypad.poll_event();

            if let Some(e) = event {
                match e {
                    Event::Quit { .. } | Event::KeyDown { keycode: Some(Keycode::Escape), .. } => {
                        should_exit = true;
                    }
                    Event::KeyDown { keycode: Some(x), .. } => {
                        self.keydown(x);
                    }
                    Event::KeyUp { keycode: Some(x), .. } => {
                        self.keyup(x);
                    }
                    _ => self.button_change = false,
                }
            }
        }

        if self.data & 0x10 == 0x00 {
            self.data = (self.data & 0xF0) | self.row_direction;
        }
        if self.data & 0x20 == 0x00 {
            self.data = (self.data & 0xF0) | self.row_command;
        }

        should_exit
    }

    pub fn keydown(&mut self, key: Keycode) {
        self.button_change = true;
        match key {
            Keycode::D => self.row_direction &= !(1 << 0),
            Keycode::Q => self.row_direction &= !(1 << 1),
            Keycode::Z => self.row_direction &= !(1 << 2),
            Keycode::S => self.row_direction &= !(1 << 3),
            Keycode::A => self.row_command &= !(1 << 0),
            Keycode::E => self.row_command &= !(1 << 1),
            Keycode::X => self.row_command &= !(1 << 2),
            Keycode::W => self.row_command &= !(1 << 3),
            _ => self.button_change = false,
        }
    }

    pub fn keyup(&mut self, key: Keycode) {
        self.button_change = true;
        match key {
            Keycode::D => self.row_direction |= 1 << 0,
            Keycode::Q => self.row_direction |= 1 << 1,
            Keycode::Z => self.row_direction |= 1 << 2,
            Keycode::S => self.row_direction |= 1 << 3,
            Keycode::A => self.row_command |= 1 << 0,
            Keycode::B => self.row_command |= 1 << 1,
            Keycode::W => self.row_command |= 1 << 2,
            Keycode::X => self.row_command |= 1 << 3,
            _ => self.button_change = false,
        }
    }
}