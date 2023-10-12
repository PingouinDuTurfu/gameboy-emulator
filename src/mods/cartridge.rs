use std::fs;
use crate::mods::mbc_default::MbcDefault;

pub struct Cartridge {
    entry_point: [u8; 4],
    logo: [u8; 48],
    title: [u8; 16],
    new_lisc_code: [u8; 2],
    dest_code: u8,
    old_lisc_code: u8,
    rom_version: u8,
    pub checksum_val: u8,
}

impl Cartridge {
    pub fn new() -> Cartridge {
        return Cartridge {
            entry_point: [0; 4],
            logo: [0; 48],
            title: [0; 16],
            new_lisc_code: [0; 2],
            dest_code: 0,
            old_lisc_code: 0,
            rom_version: 0,
            checksum_val: 0,
        };
    }

    pub fn read_cartridge_header(self: &mut Self, game_path: &str) -> Result<MbcDefault, String> {
        let game_bytes = fs::read(game_path).unwrap();

        self.entry_point[..4].clone_from_slice(&game_bytes[0x0100..=0x0103]);
        self.logo[..48].clone_from_slice(&game_bytes[0x0104..=0x0133]);
        self.title[..16].clone_from_slice(&game_bytes[0x0134..=0x0143]);

        self.new_lisc_code[..2].clone_from_slice(&game_bytes[0x0144..=0x0145]);
        self.dest_code = game_bytes[0x14A];
        self.old_lisc_code = game_bytes[0x014B];
        self.rom_version = game_bytes[0x014C];
        self.checksum_val = game_bytes[0x014D];

        if let Err(s) = self.checksum(&game_bytes[0x0134..=0x014C]) {
            return Err(s);
        }

        let mut mbc = MbcDefault::new();
        mbc.load_game(game_bytes);

        return Ok(mbc);
    }

    pub fn checksum(self: &Self, bytes: &[u8]) -> Result<u8, String> {
        let mut x: u16 = 0;
        for i in 0..=24 {
            x = x.wrapping_sub(bytes[i] as u16).wrapping_sub(1);
        }
        if (x as u8) != self.checksum_val {
            println!("checksum failed");
            return Err("checksum failed".to_string());
        } else {
            println!("checksum passed");
        }
        return Ok(self.checksum_val);
    }
}