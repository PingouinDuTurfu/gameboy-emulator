use sdl2::event::Event;
use sdl2::EventPump;
use sdl2::keyboard::Keycode;
use crate::mods::emulator::PRINT_DEBUG;

pub const KEYPAD_REGISTER: u16 = 0xFF00;

pub struct Keypad {
    event_pump: Option<EventPump>, // Gestionnaire d'évènements
    row_direction: u8,
    row_command: u8,
    data: u8,
    button_change: bool,
    something_selected: bool,
}

pub enum KeypadKey {
    Right,
    Left,
    Up,
    Down,
    A,
    B,
    Select,
    Start,
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

    pub fn init(self: &mut Self) {
        self.data = 0xFF;
    }

    pub fn read_byte(self: &Self, address: u16) -> u8 {
        if !self.something_selected {
            return self.data | 0x0F;
        }
        let byte = match address {
            KEYPAD_REGISTER => self.data,
            _ => panic!("Joypad cannot read from addr: {:04X}", address),
        };
        return byte;
    }

    pub fn write_byte(self: &mut Self, address: u16, data: u8) {
        match address {
            KEYPAD_REGISTER => {
                unsafe {
                    PRINT_DEBUG.add_data(format!("Keypad write: {:02X}\n", data));
                }
                self.data = (data & 0x30) | (self.data & 0xCF);
                self.something_selected = (self.data & 0x20 == 0x20) ^ (self.data & 0x10 == 0x10);
            }
            _ => panic!("Joypad cannot write addr: {:04X}", address),
        };
    }

    pub fn is_keypad_interrupt(self: &Self) -> bool {
        if self.something_selected && self.button_change {
            println!("Joypad interrupt");
        }
        return self.something_selected && self.button_change;
    }

    pub fn set_keypad(self: &mut Self, event_pump: EventPump) {
        self.event_pump = Some(event_pump);
    }

    pub(crate) fn update_input(&mut self) -> bool {
        let mut should_exit = false;

        if let Some(keypad) = &mut self.event_pump {
            let event = keypad.poll_event();

            if let Some(e) = event {
                match e {
                    Event::Quit { .. } | Event::KeyDown { keycode: Some(Keycode::Escape), .. } => unsafe {
                        // PRINT_DEBUG.save_data();
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

        if should_exit  {
            println!("Exiting");
        }

        return should_exit;
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
        println!("Keyup: {:?}", key);
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

/*
    Bit 7 - Not used
    Bit 6 - Not used
    Bit 5 - P15 Select Action buttons    (0=Select)
    Bit 4 - P14 Select Direction buttons (0=Select)
    Bit 3 - P13 Input: Down  or Start    (0=Pressed) (Read Only)
    Bit 2 - P12 Input: Up    or Select   (0=Pressed) (Read Only)
    Bit 1 - P11 Input: Left  or B        (0=Pressed) (Read Only)
    Bit 0 - P10 Input: Right or A        (0=Pressed) (Read Only)
*/