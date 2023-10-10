use std::fs::File;
use std::io::{Read, Seek};

extern crate winit;

use winit::{
    event::{Event, KeyboardInput, VirtualKeyCode, WindowEvent},
    event_loop::{ControlFlow, EventLoop},
    window::WindowBuilder,
};

use mods::cpu::CPU;
use mods::memory_bus::Bus;

mod mods;

fn main() {

    let mut cpu = CPU::new();
    let mut memory_bus = Bus::new();

    let mut input_file = File::open("./roms/Pokemon.gb").expect("file not found");

    let mut buffer = [0; 0xFFFF];
    input_file.read(&mut buffer).expect("buffer overflow");

    memory_bus.memory = buffer;
    cpu.bus = memory_bus;

    cpu.pc = 0x0150;
    cpu.sp = 0xFFFE;

    let mut i: i64 = 0;

    // Créez une boucle d'événements avec winit
    let event_loop = EventLoop::new();
    let window = WindowBuilder::new().build(&event_loop).unwrap();

    // Définissez une fonction de rappel pour gérer les événements
    event_loop.run(move |event, _, control_flow| {
        *control_flow = ControlFlow::Wait;

        match event {
            Event::WindowEvent { event, window_id } if window_id == window.id() => match event {
                WindowEvent::KeyboardInput { input, .. } => {
                    match input.virtual_keycode {
                        Some(VirtualKeyCode::A) => {
                            if input.state == winit::event::ElementState::Pressed {
                                println!("La touche 'A' a été enfoncée.");
                                cpu.bus.keypad.keydown(mods::key_pad::KeypadKey::A);
                            }
                        }
                        Some(VirtualKeyCode::E) => {
                            if input.state == winit::event::ElementState::Pressed {
                                println!("La touche 'E' a été enfoncée.");
                                cpu.bus.keypad.keydown(mods::key_pad::KeypadKey::B);
                            }
                        }
                        Some(VirtualKeyCode::Z) => {
                            if input.state == winit::event::ElementState::Pressed {
                                println!("La touche 'Z' a été enfoncée.");
                                cpu.bus.keypad.keydown(mods::key_pad::KeypadKey::Up);
                            }
                        }
                        Some(VirtualKeyCode::Q) => {
                            if input.state == winit::event::ElementState::Pressed {
                                println!("La touche 'Q' a été enfoncée.");
                                cpu.bus.keypad.keydown(mods::key_pad::KeypadKey::Left);
                            }
                        }
                        Some(VirtualKeyCode::S) => {
                            if input.state == winit::event::ElementState::Pressed {
                                println!("La touche 'S' a été enfoncée.");
                                cpu.bus.keypad.keydown(mods::key_pad::KeypadKey::Down);
                            }
                        }
                        Some(VirtualKeyCode::D) => {
                            if input.state == winit::event::ElementState::Pressed {
                                println!("La touche 'D' a été enfoncée.");
                                cpu.bus.keypad.keydown(mods::key_pad::KeypadKey::Right);
                            }
                        }
                        Some(VirtualKeyCode::Escape) => {
                            if input.state == winit::event::ElementState::Pressed {
                                println!("La touche 'Escape' a été enfoncée.");
                                *control_flow = ControlFlow::Exit;
                            }
                        }
                        _ => (),
                    }

                }
                // Gérez d'autres événements de fenêtre si nécessaire
                _ => (),
            },
            Event::LoopDestroyed => return,
            _ => (),
        }

        // print!("step {} 0x{:04X} ", i, cpu.pc);
        cpu.step();
        i += 1;
    });
}

#[cfg(test)]
mod tests {
    use crate::mods::enum_instructions::{AddType, Instruction};

    #[test]
    fn test_cpu_add_a_to_a() {
        use crate::mods::cpu::CPU;
        use crate::mods::enum_instructions::{ArithmeticTarget, Instruction};

        let mut cpu = CPU::new();
        cpu.registers.a = 0x05;
        cpu.execute(Instruction::ADD(AddType::ToA(ArithmeticTarget::A)));
        assert_eq!(cpu.registers.a, 0x0A);
        assert_eq!(cpu.registers.f.zero, false);
        assert_eq!(cpu.registers.f.subtract, false);
        assert_eq!(cpu.registers.f.half_carry, false);
        assert_eq!(cpu.registers.f.carry, false);
    }

    #[test]
    fn test_cpu_add_c_to_a() {
        use crate::mods::cpu::CPU;
        use crate::mods::enum_instructions::{ArithmeticTarget, Instruction};
        let mut cpu = CPU::new();
        cpu.registers.a = 0x01;
        cpu.registers.c = 0x03;
        cpu.execute(Instruction::ADD(AddType::ToA(ArithmeticTarget::C)));
        assert_eq!(cpu.registers.a, 0x04);
        assert_eq!(cpu.registers.f.zero, false);
        assert_eq!(cpu.registers.f.subtract, false);
        assert_eq!(cpu.registers.f.half_carry, false);
        assert_eq!(cpu.registers.f.carry, false);
    }

    #[test]
    fn test_cpu_add_d_to_a() {
        use crate::mods::cpu::CPU;
        use crate::mods::enum_instructions::{ArithmeticTarget, Instruction};

        let mut cpu = CPU::new();
        cpu.registers.a = 0x02;
        cpu.registers.d = 0x03;
        cpu.execute(Instruction::ADD(AddType::ToA(ArithmeticTarget::D)));
        assert_eq!(cpu.registers.a, 0x05);
        assert_eq!(cpu.registers.f.zero, false);
        assert_eq!(cpu.registers.f.subtract, false);
        assert_eq!(cpu.registers.f.half_carry, false);
        assert_eq!(cpu.registers.f.carry, false);
    }

    #[test]
    fn test_cpu_add_b_to_a() {
        use crate::mods::cpu::CPU;
        use crate::mods::enum_instructions::{ArithmeticTarget, Instruction};

        let mut cpu = CPU::new();
        cpu.registers.a = 0x0A;
        cpu.registers.b = 0x05;
        cpu.execute(Instruction::ADD(AddType::ToA(ArithmeticTarget::B)));
        assert_eq!(cpu.registers.a, 0x0F);
        assert_eq!(cpu.registers.f.zero, false);
        assert_eq!(cpu.registers.f.subtract, false);
        assert_eq!(cpu.registers.f.half_carry, false);
        assert_eq!(cpu.registers.f.carry, false);
    }

    #[test]
    fn test_cpu_add_overflow() {
        use crate::mods::cpu::CPU;
        use crate::mods::enum_instructions::{ArithmeticTarget, Instruction};

        let mut cpu = CPU::new();
        cpu.registers.a = 0xFF;
        cpu.registers.b = 0x02;
        cpu.execute(Instruction::ADD(AddType::ToA(ArithmeticTarget::B)));
        assert_eq!(cpu.registers.a, 0x01);
        assert_eq!(cpu.registers.f.zero, false);
        assert_eq!(cpu.registers.f.subtract, false);
        assert_eq!(cpu.registers.f.half_carry, true);
        assert_eq!(cpu.registers.f.carry, true);
    }

    #[test]
    fn test_cpu_add_half_carry() {
        use crate::mods::cpu::CPU;
        use crate::mods::enum_instructions::{ArithmeticTarget, Instruction};

        let mut cpu = CPU::new();
        cpu.registers.a = 0x0F;
        cpu.registers.b = 0x01;
        cpu.execute(Instruction::ADD(AddType::ToA(ArithmeticTarget::B)));
        assert_eq!(cpu.registers.a, 0x10);
        assert_eq!(cpu.registers.f.zero, false);
        assert_eq!(cpu.registers.f.subtract, false);
        assert_eq!(cpu.registers.f.half_carry, true);
        assert_eq!(cpu.registers.f.carry, false);
    }

    #[test]
    fn test_cpu_add_zero_flag_reset() {
        use crate::mods::cpu::CPU;
        use crate::mods::enum_instructions::{ArithmeticTarget, Instruction};

        let mut cpu = CPU::new();
        cpu.registers.a = 0x01;
        cpu.registers.b = 0x02;
        cpu.execute(Instruction::ADD(AddType::ToA(ArithmeticTarget::B)));
        assert_eq!(cpu.registers.a, 0x03);
        assert_eq!(cpu.registers.f.zero, false);
        assert_eq!(cpu.registers.f.subtract, false);
        assert_eq!(cpu.registers.f.half_carry, false);
        assert_eq!(cpu.registers.f.carry, false);
    }

    #[test]
    fn test_cpu_add_carry() {
        use crate::mods::cpu::CPU;
        use crate::mods::enum_instructions::{ArithmeticTarget, Instruction};

        let mut cpu = CPU::new();
        cpu.registers.a = 0xFF;
        cpu.registers.b = 0x01;
        cpu.execute(Instruction::ADD(AddType::ToA(ArithmeticTarget::B)));
        assert_eq!(cpu.registers.a, 0x00);
        assert_eq!(cpu.registers.f.zero, true);
        assert_eq!(cpu.registers.f.subtract, false);
        assert_eq!(cpu.registers.f.half_carry, true);
        assert_eq!(cpu.registers.f.carry, true);
    }

    #[test]
    fn test_cpu_reading_bus_memory() {
        use crate::mods::cpu::CPU;
        use crate::mods::memory_bus::Bus;

        let mut memory_bus = Bus::new();

        // Placez l'instruction "add A to A" (0x87) à l'adresse mémoire suivante.
        memory_bus.memory[0x00] = 0x87;

        // Placez l'instruction "add B to A" (0x80) à l'adresse mémoire suivante.
        memory_bus.memory[0x01] = 0x80;

        let mut cpu = CPU::new();
        cpu.registers.a = 1;
        cpu.registers.b = 5;
        cpu.bus = memory_bus;

        cpu.step(); // Exécute "add A to A"
        assert_eq!(cpu.registers.a, 2);
        cpu.step(); // Exécute "add B to A"
        assert_eq!(cpu.registers.a, 7);
    }

    #[test]
    fn test_cpu_inc_a() {
        use crate::mods::cpu::CPU;
        use crate::mods::enum_instructions::{IncDecTarget, Instruction};

        let mut cpu = CPU::new();
        cpu.registers.a = 0x01;
        cpu.execute(Instruction::INC(IncDecTarget::A));
        assert_eq!(cpu.registers.a, 0x02);
        assert_eq!(cpu.registers.f.zero, false);
        assert_eq!(cpu.registers.f.subtract, false);
        assert_eq!(cpu.registers.f.half_carry, false);
        assert_eq!(cpu.registers.f.carry, false);
    }

    #[test]
    fn test_cpu_inc_b_half_carry() {
        use crate::mods::cpu::CPU;
        use crate::mods::enum_instructions::{IncDecTarget, Instruction};

        let mut cpu = CPU::new();
        cpu.registers.b = 0x0F;
        cpu.execute(Instruction::INC(IncDecTarget::B));
        assert_eq!(cpu.registers.b, 0x10);
        assert_eq!(cpu.registers.f.zero, false);
        assert_eq!(cpu.registers.f.subtract, false);
        assert_eq!(cpu.registers.f.half_carry, true);
        assert_eq!(cpu.registers.f.carry, false);
    }

    #[test]
    fn test_cpu_inc_de () {
        use crate::mods::cpu::CPU;
        use crate::mods::enum_instructions::{IncDecTarget, Instruction};

        let mut cpu = CPU::new();
        cpu.registers.d = 0x0F;
        cpu.registers.e = 0xFF;
        cpu.execute(Instruction::INC(IncDecTarget::DE));
        assert_eq!(cpu.registers.d, 0x10);
        assert_eq!(cpu.registers.e, 0x00);
    }

    #[test]
    fn test_cpu_stack_initial_sp() {
        use crate::mods::cpu::CPU;
        let mut cpu = CPU::new();
        cpu.pc = 0x1000;
        cpu.sp = 0xFFFE;

        assert_eq!(cpu.sp, 0xFFFE);
    }

    #[test]
    fn test_cpu_stack_push() {
        use crate::mods::cpu::CPU;
        let mut cpu = CPU::new();
        cpu.pc = 0x1000;
        cpu.sp = 0xFFFE;

        cpu.push(0x1234);

        assert_eq!(cpu.sp, 0xFFFC);
        assert_eq!(cpu.bus.memory[0xFFFD], 0x12);
        assert_eq!(cpu.bus.memory[0xFFFC], 0x34);
    }

    #[test]
    fn test_cpu_stack_pop() {
        use crate::mods::cpu::CPU;
        let mut cpu = CPU::new();
        cpu.pc = 0x1000;
        cpu.sp = 0xFFFC;

        cpu.bus.memory[0xFFFD] = 0x12;
        cpu.bus.memory[0xFFFC] = 0x34;

        let result = cpu.pop();

        assert_eq!(cpu.sp, 0xFFFE);
        assert_eq!(result, 0x1234);
    }

    #[test]
    fn test_cpu_load_byte_register_to_register() {
        use crate::mods::cpu::CPU;
        use crate::mods::enum_instructions::{Instruction, LoadByteSource, LoadByteTarget, LoadType};

        let mut cpu = CPU::new();
        cpu.registers.a = 0x42;
        cpu.registers.b = 0x11;
        cpu.registers.c = 0x22;
        cpu.registers.d = 0x33;
        cpu.registers.e = 0x44;
        cpu.registers.h = 0x55;
        cpu.registers.l = 0x66;
        cpu.pc = 0x1000;

        let instruction = Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::B));
        cpu.execute(instruction);

        assert_eq!(cpu.registers.a, 0x11);
    }

    #[test]
    fn test_cpu_memory_read_next_byte() {
        use crate::mods::cpu::CPU;

        let mut cpu = CPU::new();
        cpu.registers.a = 0x42;
        cpu.registers.b = 0x11;
        cpu.registers.c = 0x22;
        cpu.registers.d = 0x33;
        cpu.registers.e = 0x44;
        cpu.registers.h = 0x55;
        cpu.registers.l = 0x66;
        cpu.pc = 0x2000;
        cpu.bus.memory[0x2000] = 0x55;
        cpu.bus.memory[0x2001] = 0x66;
        cpu.bus.memory[0x2002] = 0x77;
        cpu.bus.memory[0x2003] = 0x88;

        let byte = cpu.read_next_byte();

        assert_eq!(byte, 0x55);
        assert_eq!(cpu.pc, 0x2000);
    }

    // #[test]
    // fn test_cpu_load_word_register_to_memory() {
    //     use crate::mods::cpu::CPU;
    //     use crate::mods::enum_instructions::{LoadByteSource, LoadByteTarget, LoadType, Instruction};
    //
    //     let mut cpu = CPU::new();
    //     cpu.registers.a = 0x42;
    //     cpu.registers.b = 0x11;
    //     cpu.registers.c = 0x22;
    //     cpu.registers.d = 0x33;
    //     cpu.registers.e = 0x44;
    //     cpu.registers.h = 0x55;
    //     cpu.registers.l = 0x66;
    //     cpu.pc = 0x1000;
    //
    //     // Écrivez une valeur de mot (16 bits) depuis le registre DE dans la mémoire à l'adresse 0x2000
    //     let instruction = Instruction::LD(LoadType::Word(
    //         LoadWordTarget::Memory(0x2000),
    //         LoadWordSource::Register(Register16::DE),
    //     ));
    //     cpu.execute(instruction);
    //
    //     // Vérifiez que la valeur de mot a été copiée depuis DE dans la mémoire
    //     assert_eq!(cpu.bus.read_byte(0x2000), 0x33); // Contenu de D
    //     assert_eq!(cpu.bus.read_byte(0x2001), 0x44); // Contenu de E
    // }
    //
    // #[test]
    // fn test_cpu_load_word_memory_to_register() {
    //     use crate::mods::cpu::CPU;
    //     use crate::mods::memory_bus::MemoryBus;
    //
    //     let mut cpu = CPU::new();
    //     cpu.pc = 0x1000;
    //     cpu.bus = MemoryBus {
    //         memory: [0; 0xFFFF],
    //     };
    //
    //     cpu.bus.memory[0x2000] = 0x55;
    //     cpu.bus.memory[0x2001] = 0x66;
    //     cpu.bus.memory[0x2002] = 0x77;
    //     cpu.bus.memory[0x2003] = 0x88;
    //
    //     // Écrivez une valeur de mot (16 bits) depuis la mémoire à l'adresse 0x2000 dans le registre HL
    //     let instruction = Instruction::LD(LoadType::Word(
    //         LoadWordTarget::Register16(Register16::HL),
    //         LoadWordSource::Memory(0x2000),
    //     ));
    //     cpu.execute(instruction);
    //
    //     // Vérifiez que la valeur de mot a été copiée depuis la mémoire dans HL
    //     assert_eq!(cpu.registers.h, 0x66); // Contenu de la mémoire à 0x2001 (MSB)
    //     assert_eq!(cpu.registers.l, 0x55); // Contenu de la mémoire à 0x2000 (LSB)
    // }

}