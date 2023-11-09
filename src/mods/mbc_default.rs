pub const ROM_START: u16 = 0x0000;
pub const ROM_END: u16 = 0x7FFF;
pub const RAM_START: u16 = 0xA000;
pub const RAM_END: u16 = 0xBFFF;



pub struct MbcDefault {
    rom: [u8; 0x8000],  // De 0x0000 à 0x7FFF
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

    pub(crate) fn read_ram_byte(self: &Self, address: u16) -> u8 {
        let byte = match address {
            RAM_START..=RAM_END => self.ram[usize::from(address - RAM_START)],
            _ => panic!("Ram cannot read from addr {:#04X}", address),
        };
        return byte;
    }

    pub(crate) fn write_ram_byte(self: &mut Self, address: u16, val: u8) {
        match address {
            RAM_START..=RAM_END => self.ram[usize::from(address - RAM_START)] = val,
            _ => panic!("Ram cannot write to addr {:#04X}", address),
        };
    }

    pub(crate) fn read_rom_byte(self: &Self, address: u16) -> u8 {
        let byte = match address {
            ROM_START..=ROM_END => self.rom[usize::from(address)],
            _ => panic!("Rom cannot read from addr {:#04X}", address),
        };
        return byte;
    }

    pub(crate) fn load_game(self: &mut Self, game_bytes: Vec<u8>) {
        for (i, byte) in game_bytes.into_iter().enumerate() {
            self.rom[i] = byte;
        }
    }
}