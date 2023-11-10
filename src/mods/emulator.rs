use sdl2::{Sdl, VideoSubsystem};
use sdl2::pixels::PixelFormatEnum;
use sdl2::rect::Rect;
use sdl2::render::TextureAccess;

use crate::mods::cartridge::Cartridge;
use crate::mods::cpu::Cpu;
use crate::print_debug::PrintDebug;

pub const SCALE: u32 = 3;
pub const NUM_PIXELS_X: u32 = 160;
pub const NUM_PIXELS_Y: u32 = 144;
pub const TOTAL_PIXELS: u32 = NUM_PIXELS_X * NUM_PIXELS_Y;
pub const SCREEN_WIDTH: u32 = NUM_PIXELS_X * SCALE;
pub const SCREEN_HEIGHT: u32 = NUM_PIXELS_Y * SCALE;
pub const BYTES_PER_TILE_SIGNED: isize = 16;

pub static mut PRINT_DEBUG: PrintDebug = PrintDebug {debug: false,
        data: String::new(),
        global_index: 0,
        index: 0,
        already_printed_video_ram: false
};

pub struct Emulator {
    cpu: Cpu,
    cart: Cartridge,
    sdl_context: Option<Sdl>,
    video_subsystem: Option<VideoSubsystem>
}

impl Emulator {
    pub fn new() -> Emulator {
        return Emulator {
            cpu: Cpu::new(),
            cart: Cartridge::new(),
            sdl_context: None,
            video_subsystem: None
        };
    }

    pub fn setup_emulator(&mut self, game_path: &str) {
        let sdl_context = sdl2::init().expect("Couldnt create sdl context"); // SDL for graphics, sound and input

        let video_subsystem = sdl_context // Init Display
            .video()
            .expect("Couldnt initialize video subsystem");

        let event_pump = sdl_context
            .event_pump()
            .expect("Coulnt initialize event pump"); // Init Event System

        let cart_mbc = self.cart.read_cartridge_header(game_path).unwrap();

        self.sdl_context = Some(sdl_context);
        self.video_subsystem = Some(video_subsystem);
        self.cpu.set_mbc(cart_mbc);
        self.cpu.set_keypad(event_pump);
        self.cpu.init(self.cart.checksum_val);
    }

    pub fn run(&mut self) {
        let video_subsystem = match &self.video_subsystem {
            Some(videosys) => videosys,
            None => panic!("No video subsystem was initialized"),
        };

        let window = video_subsystem
            .window("Rust-Gameboy-Emulator", SCREEN_WIDTH, SCREEN_HEIGHT)
            .position_centered()
            .build()
            .unwrap();

        let mut canvas = window // Canvas is the renderer
            .into_canvas()
            .accelerated()
            .build()
            .unwrap();

        let creator = canvas.texture_creator();
        let mut texture = creator
            .create_texture(PixelFormatEnum::RGBA32, TextureAccess::Streaming, NUM_PIXELS_X, NUM_PIXELS_Y)
            .map_err(|e| e.to_string())
            .unwrap();

        let rect = Some(Rect::new(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT));

        loop {
            unsafe {
                PRINT_DEBUG.increment_index();
            }

            if self.cpu.update_input() {
                break;
            }
            self.cpu.check_interrupts();

            if !self.cpu.halted() {
                self.cpu.step(true);
            } else {
                self.cpu.adv_cycles(4);
            }

            if self.cpu.update_display(&mut texture) {
                canvas.copy(&texture, None, rect).unwrap();
                canvas.present();
            }
        }
    }
}

pub fn convert_index4msb_to_rgba32(index: u8) -> [u8; 4] {
    return match index {
        0x00 => [0, 0, 0, 255],
        0x05 => [96, 96, 96, 255],
        0x0A => [192, 192, 192, 255],
        0x0F => [255, 255, 255, 255],
        0xFF => [0, 0, 0, 0],
        _ => panic!("Invalid index: {}", index)
    }
}