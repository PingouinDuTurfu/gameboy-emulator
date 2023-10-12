use std::fs::File;
use std::io::BufWriter;
use sdl2::{Sdl, VideoSubsystem};
use sdl2::pixels::PixelFormatEnum;
use sdl2::rect::Rect;
use crate::mods::cartridge::Cartridge;
use crate::mods::cpu::CPU;

pub const SCALE: u32 = 3;
pub const NUM_PIXELS_X: u32 = 160;
pub const NUM_PIXELS_Y: u32 = 144;
pub const TOTAL_PIXELS: usize = (NUM_PIXELS_X * NUM_PIXELS_Y) as usize;

pub const SCREEN_WIDTH: u32 = NUM_PIXELS_X * SCALE; // Only used by the window and rect (not in the texture)
pub const SCREEN_HEIGHT: u32 = NUM_PIXELS_Y * SCALE; // Only used by the window and rect (not in the texture)

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

        self.sdl_context = Some(sdl_context);
        self.video_subsystem = Some(video_subsystem);
        self.cpu.set_mbc(cart_mbc);
        self.cpu.set_keypad(event_pump);
        self.cpu.init(self.cart.checksum_val);
    }

    pub fn run(self: &mut Self) {
        // Put these in graphics somehow
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
            .create_texture_streaming(PixelFormatEnum::ARGB8888, NUM_PIXELS_X, NUM_PIXELS_Y)
            .map_err(|e| e.to_string())
            .unwrap();

        let rect = Some(Rect::new(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT));

        let x1 = std::time::Instant::now();
        let mut counter: u128 = 0;

        loop {
            if self.cpu.update_input() {
                // Is true when we get the exit signal
                break;
            }
            self.cpu.check_interrupts();

            if !self.cpu.halted {
                // self.cpu.curr_cycles = 0;
                self.cpu.step(false);
            } else {
                // Halted
                // self.cpu.curr_cycles = 4;
                // self.cpu.adv_cycles(4); // Should this be 1 or 4?
            }

            // if self.cpu.update_display(&mut texture) {
            //     canvas.copy(&texture, None, rect).unwrap();
            //     canvas.present();
            // }

            counter = counter.wrapping_add(1);
        }
    }
}