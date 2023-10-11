use sdl2::event::Event;
use sdl2::EventPump;
use sdl2::keyboard::Keycode;

pub const KEYPAD_REGISTER: u16 = 0xFF00;

pub struct Keypad {
    event_pump: Option<EventPump>,
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
            data: 0xFF,
            button_change: false,
            something_selected: false,
        }
    }

    pub fn is_joypad_interrupt(self: &Self) -> bool {
        return self.something_selected && self.button_change;
    }

    fn update(&mut self) -> bool {
        let mut should_exit = false;

        if let Some(joypad) = &mut self.event_pump {
            let event = joypad.poll_event();

            if let Some(e) = event {
                match e {
                    Event::Quit { .. } | Event::KeyDown { keycode: Some(Keycode::Escape), .. } => {
                        should_exit = true;
                    }
                    Event::KeyDown { keycode: Some(x), .. } => {
                        self.handle_keydown_event(x);
                    }
                    Event::KeyUp { keycode: Some(x), .. } => {
                        self.handle_keyup_event(x);
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

        return should_exit;
    }

    pub fn keydown(&mut self, key: Keycode) {
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