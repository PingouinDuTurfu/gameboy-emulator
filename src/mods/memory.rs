use crate::mods::mbc_default::{MbcDefault, RAM_END, RAM_START, ROM_END, ROM_START};

pub struct Memory {
    mbc: MbcDefault,
    pub(crate) interrupt_enable: u8, // Registre IE 0xFFFF
}

impl Memory {
    pub fn new() -> Memory {
        Memory {
            mbc: MbcDefault::new(),
            interrupt_enable: 0,
        }
    }

    pub fn set_mbc(self: &mut Self, cart_mbc: MbcDefault) {
        self.mbc = cart_mbc;
    }

    pub fn read_byte(self: &Self, addr: u16) -> u8 {
        let byte = match addr {
            ROM_START..=ROM_END => self.mbc.read_rom_byte(addr),
            RAM_START..=RAM_END => self.mbc.read_ram_byte(addr),
            0xFFFF => self.interrupt_enable,
            _ => panic!("TODO : Memory does not handle reads from: {:04X}", addr),
        };
        byte
    }

    pub fn write_byte(self: &mut Self, addr: u16, data: u8) {
        match addr {
            ROM_START..=ROM_END => return, // On n'ecrit pas dans la ROM, car on est pas des animaux
            RAM_START..=RAM_END => self.mbc.write_ram_byte(addr, data),
            0xFFFF => self.interrupt_enable = data,
            _ => panic!("TODO : Memory does not handle write to: {:04X}", addr),
        };
    }
}