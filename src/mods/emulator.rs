use std::fs::File;
use std::io::BufWriter;
use sdl2::{Sdl, VideoSubsystem};
use crate::mods::cartridge::Cartridge;
use crate::mods::cpu::CPU;

pub struct Emulator {
    cpu: CPU,
    cart: Cartridge,
    sdl_context: Option<Sdl>,
    video_subsystem: Option<VideoSubsystem>,
    file_writer: Option<BufWriter<File>>,
}

impl Emulator {
    pub fn new() -> Emulator {
        return Emulator {
            cpu: CPU::new(),
            cart: Cartridge::new(),
            sdl_context: None,
            video_subsystem: None,
            file_writer: None,
        };
    }

    pub fn setup_emulator(self: &mut Self, game_path: &str) {
        let sdl_context = sdl2::init().expect("Couldnt create sdl context"); // SDL for graphics, sound and input

        println!("SDL Context created");

        println!("{:?}", sdl_context.video());

        let video_subsystem = sdl_context // Init Display
            .video()
            .expect("Couldnt initialize video subsystem");

        let event_pump = sdl_context
            .event_pump()
            .expect("Coulnt initialize event pump"); // Init Event System

        let cart_mbc = self.cart.read_cartridge_header(game_path).unwrap();

        self.sdl_context = Some(sdl_context); // Just need to make sure the context doesnt die
        self.video_subsystem = Some(video_subsystem); // Just need to make sure the context doesnt die
        self.cpu.set_mbc(cart_mbc); // Cartridge header had what mbc to use
        self.cpu.set_keypad(event_pump); // Joypad will own the event pump
        self.cpu.init(self.cart.checksum_val); // Setup registers

        // #[cfg(feature = "debug-file")]
        // {
        //     self.file_writer = Some(BufWriter::new(self.setup_debug_file(game_path)));
        // }
    }
}