use crate::mods::mbc_default::{MbcDefault, RAM_END, RAM_START, ROM_END, ROM_START};

pub const WORKING_RAM_START: u16 = 0xC000;
pub const WORKING_RAM_END: u16 = 0xDFFF;
pub const HIGH_RAM_START: u16 = 0xFF80;
pub const HIGH_RAM_END: u16 = 0xFFFE;

pub struct Memory {
    mbc: MbcDefault,
    working_ram: [u8; 0x2000],       // 0xC000 - 0xDFFF
    high_ram: [u8; 0x7F],            // 0xFF80 - 0xFFFE
    interrupt_enable: u8, // Registre IE 0xFFFF
}

impl Memory {
    pub fn new() -> Memory {
        Memory {
            mbc: MbcDefault::new(),
            working_ram: [0; 0x2000],
            interrupt_enable: 0,
            high_ram: [0; 0x7F],
        }
    }

    pub fn init(&mut self) {
        self.interrupt_enable = 0x00;
    }
    pub fn set_mbc(&mut self, cart_mbc: MbcDefault) {
        self.mbc = cart_mbc;
    }

    pub fn read_byte(&self, address: u16) -> u8 {
        match address {
            ROM_START..=ROM_END => self.mbc.read_rom_byte(address),
            RAM_START..=RAM_END => self.mbc.read_ram_byte(address),
            WORKING_RAM_START..=WORKING_RAM_END => self.working_ram[usize::from(address - WORKING_RAM_START)],
            HIGH_RAM_START..=HIGH_RAM_END => self.high_ram[usize::from(address - HIGH_RAM_START)],
            0xFFFF => self.interrupt_enable,
            _ => panic!("TODO : Memory does not handle reads from: {:04X}", address),
        }
    }

    pub fn write_byte(&mut self, address: u16, data: u8) {
        match address {
            ROM_START..=ROM_END => (), // On n'ecrit pas dans la ROM, car on est pas des animaux
            RAM_START..=RAM_END => self.mbc.write_ram_byte(address, data),
            WORKING_RAM_START..=WORKING_RAM_END => self.working_ram[usize::from(address - WORKING_RAM_START)] = data,
            HIGH_RAM_START..=HIGH_RAM_END => self.high_ram[usize::from(address - HIGH_RAM_START)] = data,
            0xFFFF => self.interrupt_enable = data,
            _ => panic!("TODO : Memory does not handle write to: {:04X}", address),
        };
    }

    pub fn read_byte_for_dma(&self, addr: u16) -> u8 {
        match addr {
            ROM_START..=ROM_END => self.mbc.read_rom_byte(addr),
            RAM_START..=RAM_END => self.mbc.read_ram_byte(addr),
            WORKING_RAM_START..=WORKING_RAM_END => self.working_ram[usize::from(addr - WORKING_RAM_START)],
            HIGH_RAM_START..=HIGH_RAM_END => self.high_ram[usize::from(addr - HIGH_RAM_START)],
            _ => panic!("TODO : Memory does not handle reads from: {:04X}", addr),
        }
    }

    pub fn interrupt_enable(&self) -> u8 {
        self.interrupt_enable
    }
}