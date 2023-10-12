pub const ROM_START: u16 = 0x0000;
pub const ROM_END: u16 = 0x7FFF;
pub const RAM_START: u16 = 0xA000;
pub const RAM_END: u16 = 0xBFFF;



pub struct MbcDefault {
    rom: [u8; 0x8000], // De 0x0000 à 0x7FFF
    ram: [u8; 0x4000],  // De 0xA000 à 0xBFFF
}

impl MbcDefault {
    pub(crate) fn new() -> MbcDefault {
        println!("MBCNone");
        MbcDefault {
            rom: [0; 0x8000],
            ram: [0; 0x4000],
        }
    }

    pub(crate) fn read_ram_byte(self: &Self, addr: u16) -> u8 {
        let byte = match addr {
            RAM_START..=RAM_END => self.ram[usize::from(addr - RAM_START)],
            _ => panic!("Ram cannot read from addr {:#04X}", addr),
        };
        return byte;
    }

    pub(crate) fn write_ram_byte(self: &mut Self, addr: u16, val: u8) {
        match addr {
            RAM_START..=RAM_END => self.ram[usize::from(addr - RAM_START)] = val,
            _ => panic!("Ram cannot write to addr {:#04X}", addr),
        };
    }

    pub(crate) fn read_rom_byte(self: &Self, addr: u16) -> u8 {
        let byte = match addr {
            ROM_START..=ROM_END => self.rom[usize::from(addr)],
            _ => panic!("Rom cannot read from addr {:#04X}", addr),
        };
        return byte;
    }

    pub(crate) fn load_game(self: &mut Self, game_bytes: Vec<u8>) {
        for (i, byte) in game_bytes.into_iter().enumerate() {
            self.rom[i] = byte;
        }
    }
}