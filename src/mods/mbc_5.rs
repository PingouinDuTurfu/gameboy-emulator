pub const ROM_BLOCK_START: u16 = 0x0000;
pub const ROM_BLOCK_END: u16 = 0x3FFF;
pub const ROM_ADDITIONAL_START: u16 = 0x4000;
pub const ROM_ADDITIONAL_END: u16 = 0x7FFF;
pub const RAM_START: u16 = 0xA000;
pub const RAM_END: u16 = 0xBFFF;
pub const ROM_BANK_LOW_START: u16 = 0x2000;
pub const ROM_BANK_LOW_END: u16 = 0x2FFF;
pub const ROM_BANK_HIGH_START: u16 = 0x3000;
pub const ROM_BANK_HIGH_END: u16 = 0x3FFF;
pub const RAM_BANK_START: u16 = 0x4000;
pub const RAM_BANK_END: u16 = 0x5FFF;
const ROM_BANK_SIZE: usize = 0x4000;
const RAM_BANK_SIZE: usize = 0x2000;

pub struct Mbc5 {
    rom: Vec<u8>, // bank 0 0x0000 - 0x3FFF(16384) and bank 1 0x4000 - 0x7FFF (bank1 is swappable)
    ram: Vec<u8>, // 0xA000 - 0xBFFF
    rom_offset: usize,
    ram_offset: usize,
    rom_bank_lo: usize, // Lower 8 bits of rom bank num
    rom_bank_hi: usize, // Upper 1 bit of rom bank num
    ram_bank: usize,    // 0x00 - 0x0F
    max_rom_banks: usize,
    max_ram_banks: usize,
    ram_enabled: bool
}

impl Mbc5 {
    pub(crate) fn new() -> Mbc5 {
        println!("MBC5");
        Mbc5 {
            rom: Vec::new(),
            ram: Vec::new(),
            rom_offset: ROM_BANK_SIZE,
            ram_offset: 0,
            rom_bank_lo: 1,
            rom_bank_hi: 0,
            ram_bank: 0,
            max_rom_banks: 0x00,
            max_ram_banks: 0x00,
            ram_enabled: false,
        }
    }

    pub(crate) fn read_ram_byte(&self, address: u16) -> u8 {
        if self.max_ram_banks == 0 {
            return 0xFF;
        }

        if self.ram_enabled {
            return match address {
                RAM_START..=RAM_END => self.ram[self.ram_offset + usize::from(address - RAM_START)],
                _ => panic!("MbcNone: ram cannot read from addr {:#04X}", address),
            };
        }
        0xFF
    }

    pub(crate) fn write_ram_byte(&mut self, address: u16, val: u8) {
        if self.max_ram_banks == 0 {
            return;
        }

        if self.ram_enabled {
            match address {
                RAM_START..=RAM_END => self.ram[self.ram_offset + usize::from(address - RAM_START)] = val,
                _ => panic!("MbcNone: ram cannot write to addr {:#04X}", address),
            };
        }
    }

    pub(crate) fn read_rom_byte(&self, address: u16) -> u8 {
        match address {
            ROM_BLOCK_START..=ROM_BLOCK_END => self.rom[usize::from(address)],
            ROM_ADDITIONAL_START..=ROM_ADDITIONAL_END => self.rom[self.rom_offset + usize::from(address - ROM_ADDITIONAL_START)],
            _ => panic!("Rom cannot read from addr {:#04X}", address),
        }
    }

    pub(crate) fn write_rom_byte(&mut self, addr: u16, val: u8) {
        match addr {
            0x0000..=0x1FFF => self.ram_enabled = val == 0x0A,
            ROM_BANK_LOW_START..=ROM_BANK_LOW_END => self.rom_bank_lo = usize::from(val),
            ROM_BANK_HIGH_START..=ROM_BANK_HIGH_END => self.rom_bank_hi = usize::from(val & 0x01),
            RAM_BANK_START..=RAM_BANK_END => self.ram_bank = usize::from(val & 0x0F),
            0x6000..=0x7FFF => (),
            _ => panic!("MbcNone: rom cannot read from addr {:#04X}", addr),
        };

        self.rom_offset =
            (((self.rom_bank_hi << 8) | self.rom_bank_lo) % self.max_rom_banks) * ROM_BANK_SIZE;

        if self.max_ram_banks != 0 {
            self.ram_offset = (self.ram_bank % self.max_ram_banks) * RAM_BANK_SIZE;
        }
    }

    pub(crate) fn load_game(
        &mut self,
        game_bytes: Vec<u8>,
        rom_size: usize,
        rom_banks: usize,
        ram_size: usize,
        ram_banks: usize,
        types: u8
    ) {
        self.rom = vec![0; rom_size];
        self.max_rom_banks = rom_banks;
        self.rom = game_bytes;

        match types {
            0 => {
                self.ram = vec![0; ram_size];
                self.max_ram_banks = ram_banks;
            },
            1 => {
                self.ram = vec![0; ram_size];
                self.max_ram_banks = ram_banks;
            }
            2 => {
                self.ram = vec![0; ram_size];
                self.max_ram_banks = ram_banks;
            }
            _ => panic!("Ooooooof coup dur"),
        }
    }
}