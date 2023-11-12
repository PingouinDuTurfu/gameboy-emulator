use std::fs;
use crate::mods::mbc_5::Mbc5;

use crate::mods::mbc_default::MbcDefault;

pub struct Cartridge {
    game_bytes: Vec<u8>,
    entry_point: [u8; 4],
    logo: [u8; 48],
    title: [u8; 16],
    new_license_code: [u8; 2],
    cartridge_type: u8,
    rom_size: u8,
    ram_size: u8,
    dest_code: u8,
    old_licence_code: u8,
    rom_version: u8,
    pub checksum_val: u8,
}

impl Cartridge {
    pub fn new() -> Cartridge {
        Cartridge {
            game_bytes: Vec::new(),
            entry_point: [0; 4],
            logo: [0; 48],
            title: [0; 16],
            new_license_code: [0; 2],
            cartridge_type: 0,
            rom_size: 0,
            ram_size: 0,
            dest_code: 0,
            old_licence_code: 0,
            rom_version: 0,
            checksum_val: 0,
        }
    }

    pub fn read_cartridge_header(&mut self, game_path: &str) {
        let game_bytes = fs::read(game_path).unwrap();
        self.game_bytes = game_bytes.clone();

        self.entry_point[..4].clone_from_slice(&game_bytes[0x0100..=0x0103]);
        self.logo[..48].clone_from_slice(&game_bytes[0x0104..=0x0133]);
        self.title[..16].clone_from_slice(&game_bytes[0x0134..=0x0143]);

        self.new_license_code[..2].clone_from_slice(&game_bytes[0x0144..=0x0145]);
        self.cartridge_type = game_bytes[0x0147];

        self.rom_size = game_bytes[0x0148];
        self.ram_size = game_bytes[0x0149];

        self.dest_code = game_bytes[0x14A];
        self.old_licence_code = game_bytes[0x014B];
        self.rom_version = game_bytes[0x014C];
        self.checksum_val = game_bytes[0x014D];
    }

    pub fn load_game_mbc_default(self) -> Result<MbcDefault, String> {
        self.checksum(&self.game_bytes[0x0134..=0x014C])?;
        let mut mbc = MbcDefault::new();
        mbc.load_game(self.game_bytes);
        Ok(mbc)
    }

    pub fn load_game_mbc_5(self) -> Result<Box<Mbc5>, String> {
        self.checksum(&self.game_bytes[0x0134..=0x014C])?;

        let (rom_size, rom_banks) = match self.get_rom_size() {
            Some((size, banks)) => (size, banks),
            None => return Err(format!("ROM Size: {} is not supported", self.rom_size)),
        };

        let (ram_size, ram_banks) = match self.get_ram_size() {
            Some((size, banks)) => (size, banks),
            None => return Err(format!("ROM Size: {} is not supported", self.ram_size)),
        };

        Ok(
            match self.cartridge_type {
                0x19 => {
                    let mut mbc = Mbc5::new();
                    mbc.load_game(
                        self.game_bytes,
                        rom_size,
                        rom_banks,
                        ram_size,
                        ram_banks,
                        0
                    );
                    Box::new(mbc)
                }
                0x1A => {
                    let mut mbc = Mbc5::new();
                    mbc.load_game(
                        self.game_bytes,
                        rom_size,
                        rom_banks,
                        ram_size,
                        ram_banks,
                        1
                    );
                    Box::new(mbc)
                }
                0x1B => {
                    let mut mbc = Mbc5::new();
                    mbc.load_game(
                        self.game_bytes,
                        rom_size,
                        rom_banks,
                        ram_size,
                        ram_banks,
                        2
                    );
                    Box::new(mbc)
                }
                _ => { return Err("Cartridge type not supported".to_string()); }
            }
        )
    }

    fn get_rom_size(self: &Self) -> Option<(usize, usize)> {
        match self.rom_size {
            0x00 => Some((32_768, 2)), // No banking
            0x01 => Some((65_536, 4)),
            0x02 => Some((131_072, 8)),
            0x03 => Some((262_144, 16)),
            0x04 => Some((524_288, 32)),
            0x05 => Some((1_024_000, 64)),
            0x06 => Some((2_048_000, 128)),
            0x07 => Some((4_096_000, 256)),
            0x08 => Some((8_192_000, 512)),
            _ => None,
        }
    }

    fn get_ram_size(self: &Self) -> Option<(usize, usize)> {
        match self.ram_size {
            0x00 => Some((0, 0)),
            0x02 => Some((8_192, 1)),    // 1 Bank
            0x03 => Some((32_768, 4)),   // 4 Banks of 8KB
            0x04 => Some((131_072, 16)), // 16 Banks of 8KB
            0x05 => Some((65_536, 8)),   // 8 Banks of 8KB
            _ => None,
        }
    }

    pub fn checksum(&self, bytes: &[u8]) -> Result<u8, String> {
        let mut x: u16 = 0;
        for item in bytes.iter().take(24 + 1) {
            x = x.wrapping_sub(*item as u16).wrapping_sub(1);
        }
        if (x as u8) != self.checksum_val {
            println!("checksum failed");
            return Err("checksum failed".to_string());
        } else {
            println!("checksum passed");
        }
        Ok(self.checksum_val)
    }

    pub fn get_cartridge_type(self: &Self) -> u8 {
        return self.cartridge_type
    }
}

impl Clone for Cartridge {
    fn clone(&self) -> Self {
        Self {
            game_bytes: self.game_bytes.clone(),
            entry_point: self.entry_point.clone(),
            logo: self.logo.clone(),
            title: self.title.clone(),
            new_license_code: self.new_license_code.clone(),
            cartridge_type: self.cartridge_type,
            rom_size: self.rom_size,
            ram_size: self.ram_size,
            dest_code: self.dest_code,
            old_licence_code: self.old_licence_code,
            rom_version: self.rom_version,
            checksum_val: self.checksum_val,
        }
    }
}