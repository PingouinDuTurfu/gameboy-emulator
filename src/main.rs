use std::fs::File;
use std::io::{Read, Seek};

use mods::cpu::CPU;
use mods::bus::Bus;

mod mods;
mod test;

fn main() {

    let mut cpu = CPU::new();
    let mut memory_bus = Bus::new();

    let mut input_file = File::open("./roms/Tetris.gb").expect("file not found");

    let mut buffer = [0; 0xFFFF];
    input_file.read(&mut buffer).expect("buffer overflow");

    memory_bus.memory = buffer;
    cpu.bus = memory_bus;

    cpu.pc = 0x0150;
    cpu.sp = 0xFFFE;

    let mut i: i64 = 0;
    loop {
        print!("step {} 0x{:04X} ", i, cpu.pc);
        cpu.step(true);
        i += 1;

        if i > 100 {
            break;
        }
    }
}
