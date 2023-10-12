use crate::mods::flag_register::FlagsRegister;

pub struct Registers {
    pub a: u8,
    pub b: u8,
    pub c: u8,
    pub d: u8,
    pub e: u8,
    pub f: FlagsRegister, // Flags register
    pub h: u8,
    pub l: u8,
}

impl Registers {

    pub fn new() -> Registers {
        Registers {
            a: 0x00,
            b: 0x00,
            c: 0x00,
            d: 0x00,
            e: 0x00,
            f: FlagsRegister::new(),
            h: 0x00,
            l: 0x00,
        }
    }

    pub fn init(self: &mut Self, checksum: u8) {
        if checksum == 0x00 {
            self.set_af(0x0180);
        } else {
            self.set_af(0x01B0);
        }
        self.set_bc(0x0013);
        self.set_de(0x00D8);
        self.set_hl(0x014D);
    }

    fn get_af(&self) -> u16 {
        (self.a as u16) << 8 | u8::from(self.f.clone()) as u16
    }

    pub(crate) fn get_bc(&self) -> u16 {
        (self.b as u16) << 8
            | self.c as u16
    }

    pub(crate) fn get_de(&self) -> u16 {
        (self.d as u16) << 8
            | self.e as u16
    }

    pub(crate) fn get_hl(&self) -> u16 {
        (self.h as u16) << 8
            | self.l as u16
    }

    fn set_af(&mut self, value: u16) {
        self.a = ((value & 0xFF00) >> 8) as u8;
        self.f = ((value & 0xFF) as u8).into();
    }

    pub(crate) fn set_bc(&mut self, value: u16) {
        self.b = ((value & 0xFF00) >> 8) as u8;
        self.c = (value & 0xFF) as u8;
    }

    pub(crate) fn set_de(&mut self, value: u16) {
        self.d = ((value & 0xFF00) >> 8) as u8;
        self.e = (value & 0xFF) as u8;
    }

    pub(crate) fn set_hl(&mut self, value: u16) {
        self.h = ((value & 0xFF00) >> 8) as u8;
        self.l = (value & 0xFF) as u8;
    }
}