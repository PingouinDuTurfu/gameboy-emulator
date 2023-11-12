extern crate sdl2;

use std::env;
use mods::emulator::Emulator;

mod mods;

fn main() {
    let args: Vec<String> = env::args().collect();

    if (args.len() < 2) | (args.len() > 2) {
        panic!("Et non, il faut juste mettre la ROM en argument, pas plus, pas moins !");
    }
    let game_path = &args[1];


    let mut emulator = Emulator::new();
    emulator.setup_emulator(game_path);
    emulator.run();
}
