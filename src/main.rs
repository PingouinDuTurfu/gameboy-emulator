extern crate sdl2;

use mods::emulator::Emulator;

mod mods;
mod print_debug;

fn main() {
    let mut emulator = Emulator::new();
    emulator.setup_emulator("./roms/Tetris.gb");
    emulator.run();
}
