use crate::mods::mbc_5::Mbc5;
use crate::mods::mbc_default::{MbcDefault, RAM_END, RAM_START, ROM_END, ROM_START};

pub const WORKING_RAM_START: u16 = 0xC000;
pub const WORKING_RAM_END: u16 = 0xDFFF;
pub const HIGH_RAM_START: u16 = 0xFF80;
pub const HIGH_RAM_END: u16 = 0xFFFE;

pub struct Memory {
    mbc_default: MbcDefault,
    mbc_5: Box<Mbc5>,
    working_ram: [u8; 0x2000],       // 0xC000 - 0xDFFF
    high_ram: [u8; 0x7F],            // 0xFF80 - 0xFFFE
    interrupt_enable: u8, // Registre IE 0xFFFF
    is_mbc_5: bool,
}

impl Memory {
    pub fn new() -> Memory {
        Memory {
            mbc_default: MbcDefault::new(),
            mbc_5: Box::new(Mbc5::new()),
            working_ram: [0; 0x2000],
            interrupt_enable: 0,
            high_ram: [0; 0x7F],
            is_mbc_5: false,
        }
    }

    pub fn init(&mut self) {
        self.interrupt_enable = 0x00;
    }
    pub fn set_mbc(&mut self, cart_mbc: MbcDefault) {
        self.mbc_default = cart_mbc;
        self.is_mbc_5 = false;
    }

    pub fn set_mbc_5(&mut self, cart_mbc: Box<Mbc5>) {
        self.mbc_5 = cart_mbc;
        self.is_mbc_5 = true;
    }

    pub fn read_byte(&self, address: u16) -> u8 {
        match address {
            ROM_START..=ROM_END => {
                if self.is_mbc_5 {
                    self.mbc_5.read_rom_byte(address)
                } else {
                    self.mbc_default.read_rom_byte(address)
                }
            },
            RAM_START..=RAM_END => {
                if self.is_mbc_5 {
                    self.mbc_5.read_ram_byte(address)
                } else {
                    self.mbc_default.read_ram_byte(address)
                }
            },
            WORKING_RAM_START..=WORKING_RAM_END => self.working_ram[usize::from(address - WORKING_RAM_START)],
            HIGH_RAM_START..=HIGH_RAM_END => self.high_ram[usize::from(address - HIGH_RAM_START)],
            0xFFFF => self.interrupt_enable,
            _ => panic!("TODO : Memory does not handle reads from: {:04X}", address),
        }
    }

    pub fn write_byte(&mut self, address: u16, data: u8) {
        match address {
            ROM_START..=ROM_END => {
                if self.is_mbc_5 {
                    self.mbc_5.write_rom_byte(address, data)
                } else {} // On n'ecrit pas dans la ROM, car on est pas des animaux
            },
            RAM_START..=RAM_END => {
                if self.is_mbc_5 {
                    self.mbc_5.write_ram_byte(address, data)
                } else {
                    self.mbc_default.write_ram_byte(address, data)
                }
            },
            WORKING_RAM_START..=WORKING_RAM_END => self.working_ram[usize::from(address - WORKING_RAM_START)] = data,
            HIGH_RAM_START..=HIGH_RAM_END => self.high_ram[usize::from(address - HIGH_RAM_START)] = data,
            0xFFFF => self.interrupt_enable = data,
            _ => panic!("TODO : Memory does not handle write to: {:04X}", address),
        };
    }

    pub fn read_byte_for_dma(&self, addr: u16) -> u8 {
        match addr {
            ROM_START..=ROM_END => {
                if self.is_mbc_5 {
                    self.mbc_5.read_rom_byte(addr)
                } else {
                    self.mbc_default.read_rom_byte(addr)
                }
            },
            RAM_START..=RAM_END => {
                if self.is_mbc_5 {
                    self.mbc_5.read_ram_byte(addr)
                } else {
                    self.mbc_default.read_ram_byte(addr)
                }
            },
            WORKING_RAM_START..=WORKING_RAM_END => self.working_ram[usize::from(addr - WORKING_RAM_START)],
            HIGH_RAM_START..=HIGH_RAM_END => self.high_ram[usize::from(addr - HIGH_RAM_START)],
            _ => panic!("TODO : Memory does not handle reads from: {:04X}", addr),
        }
    }

    pub fn interrupt_enable(&self) -> u8 {
        self.interrupt_enable
    }
}