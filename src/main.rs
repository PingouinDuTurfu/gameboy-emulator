extern crate sdl2;

use mods::emulator::Emulator;

mod mods;
mod print_debug;

fn main() {

    /* MEMO

    DMA = Direct Memory Access ->
        technique de gestion de la mémoire dans les ordinateurs et les systèmes embarqués.
        Elle permet de transférer des données entre différentes zones de la mémoire sans
        l'intervention du processeur central (CPU). Le DMA est utilisé pour améliorer l'efficacité
        des transferts de données en libérant le CPU de la charge de traitement de ces transferts.

    DMG = Dot Matrix Game ->
        fait référence à la technologie d'affichage utilisée dans la Game Boy, qui était un écran à
         cristaux liquides (LCD) à matrice de points, d'où le nom.
     */

    let mut emulator = Emulator::new();
    emulator.setup_emulator("./roms/Tetris.gb");
    emulator.run();

    //
    // let mut i: i64 = 0;
    // loop {
    //     print!("step {} 0x{:04X} ", i, cpu.pc);
    //     cpu.step(true);
    //     i += 1;
    //
    //     if i > 100 {
    //         break;
    //     }
    // }
}
