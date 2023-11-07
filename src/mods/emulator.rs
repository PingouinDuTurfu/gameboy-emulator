use std::fs::File;
use std::io::BufWriter;

use sdl2::{Sdl, VideoSubsystem};
use sdl2::pixels::PixelFormatEnum;
use sdl2::rect::Rect;
use once_cell::unsync::Lazy;
use sdl2::render::TextureAccess;

use crate::mods::cartridge::Cartridge;
use crate::mods::cpu::CPU;
use crate::print_debug::PrintDebug;

pub const SCALE: u32 = 3;
pub const NUM_PIXELS_X: u32 = 160;
pub const NUM_PIXELS_Y: u32 = 144;
pub const TOTAL_PIXELS: u32 = NUM_PIXELS_X * NUM_PIXELS_Y;
pub const SCREEN_WIDTH: u32 = NUM_PIXELS_X * SCALE;
pub const SCREEN_HEIGHT: u32 = NUM_PIXELS_Y * SCALE;
pub static mut PRINT_DEBUG: PrintDebug = PrintDebug {debug: false,
        data: String::new(),
        global_index: 0,
        index: 0,
        already_printed_vram: false
};

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

    pub fn run(self: &mut Self) {
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

        let mut counter: u128 = 0;

        loop {
            unsafe {
                PRINT_DEBUG.increment_index();
                // if PRINT_DEBUG.index >= 1000 {
                //     PRINT_DEBUG.save_data();
                // }
            }

            if self.cpu.update_input() {
                // Is true when we get the exit signal
                break;
            }
            self.cpu.check_interrupts();

            if !self.cpu.halted {
                // self.cpu.curr_cycles = 0;
                self.cpu.step(true);
            } else {
                // Halted
                // self.cpu.curr_cycles = 4;
                self.cpu.adv_cycles(4); // Should this be 1 or 4?
            }

            if self.cpu.update_display(&mut texture) {
                canvas.copy(&texture, None, rect).unwrap();
                canvas.present();
            }

            counter = counter.wrapping_add(1);
        }
    }
}

pub fn convert_index4msb_to_rgba32(index: u8) -> [u8; 4] {
    let mut rgb: [u8; 4] = [0; 4];
    match index {
        0x00 => rgb = [0, 0, 0, 255],
        0x05 => rgb = [96, 96, 96, 255],
        0x0A => rgb = [192, 192, 192, 255],
        0x0F => rgb = [255, 255, 255, 255],
        0xFF => rgb = [0, 0, 0, 0],
        _ => panic!("Invalid index: {}", index)
    }
    return rgb;
}