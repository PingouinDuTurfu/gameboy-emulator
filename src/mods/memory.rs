use crate::mods::mbc_default::{MbcDefault, RAM_END, RAM_START, ROM_END, ROM_START};

pub const WRAM_START: u16 = 0xC000;
pub const WRAM_END: u16 = 0xDFFF;
pub const HRAM_START: u16 = 0xFF80;
pub const HRAM_END: u16 = 0xFFFE;

pub struct Memory {
    mbc: MbcDefault,
    wram: [u8; 0x2000],              // 0xC000 - 0xDFFF
    hram: [u8; 0x7F],                // 0xFF80 - 0xFFFE
    pub(crate) interrupt_enable: u8, // Registre IE 0xFFFF
}

impl Memory {
    pub fn new() -> Memory {
        Memory {
            mbc: MbcDefault::new(),
            wram: [0; 0x2000],
            interrupt_enable: 0,
            hram: [0; 0x7F],
        }
    }

    pub fn init(self: &mut Self) {
        self.interrupt_enable = 0x00;
    }

    pub fn set_mbc(self: &mut Self, cart_mbc: MbcDefault) {
        self.mbc = cart_mbc;
    }

    pub fn read_byte(self: &Self, address: u16) -> u8 {
        let byte = match address {
            ROM_START..=ROM_END => self.mbc.read_rom_byte(address),
            RAM_START..=RAM_END => self.mbc.read_ram_byte(address),
            WRAM_START..=WRAM_END => self.wram[usize::from(address - WRAM_START)],
            HRAM_START..=HRAM_END => self.hram[usize::from(address - HRAM_START)],
            0xFFFF => self.interrupt_enable,
            _ => panic!("TODO : Memory does not handle reads from: {:04X}", address),
        };
        byte
    }

    pub fn write_byte(self: &mut Self, address: u16, data: u8) {
        // println!("Memory : Write to {:04X} : {:02X}", address, data);
        match address {
            ROM_START..=ROM_END => return, // On n'ecrit pas dans la ROM, car on est pas des animaux
            RAM_START..=RAM_END => self.mbc.write_ram_byte(address, data),
            WRAM_START..=WRAM_END => self.wram[usize::from(address - WRAM_START)] = data,
            HRAM_START..=HRAM_END => self.hram[usize::from(address - HRAM_START)] = data,
            0xFFFF => self.interrupt_enable = data,
            _ => panic!("TODO : Memory does not handle write to: {:04X}", address),
        };
    }
}