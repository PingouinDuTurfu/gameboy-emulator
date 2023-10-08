use std::fmt::{Display, Formatter, Result};
use std::ops::Add;

use crate::mods::enum_instructions::{AddType, ArithmeticTarget, IncDecTarget, Instruction, JumpTest, LoadByteSource, LoadByteTarget, LoadType, StackTarget};
use crate::mods::flag_register::FlagsRegister;
use crate::mods::memory_bus::MemoryBus;
use crate::mods::register::Registers;

pub struct CPU {
   pub registers: Registers,
   pub pc: u16,
   pub sp: u16,
   pub bus: MemoryBus,
}

impl CPU {

    pub fn new() -> CPU {
        CPU {
            registers: Registers {
                a: 0,
                b: 0,
                c: 0,
                d: 0,
                e: 0,
                f: FlagsRegister::new(),
                h: 0,
                l: 0,
            },
            pc: 0,
            sp: 0xFFFE,
            bus: MemoryBus {
                memory: [0; 0xFFFF]
            },
        }
    }

    pub(crate) fn step(&mut self) {
        let mut instruction_byte = self.bus.read_byte(self.pc);
        let prefixed = instruction_byte == 0xCB;
        if prefixed {
            instruction_byte = self.bus.read_byte(self.pc + 1);
        }

        let next_pc = if let Some(instruction) = Instruction::from_byte(instruction_byte, prefixed) {
            self.execute(instruction)
        } else {
            let description = format!("0x{}{:x}", if prefixed { "cb" } else { "" }, instruction_byte);
            panic!("Unkown instruction found for: {}", description)
        };

        self.pc = next_pc;
    }

    pub fn execute(&mut self, instruction: Instruction) -> u16 {
        match instruction {
            Instruction::PUSH(target) => {
                let value = match target {
                    StackTarget::BC => self.registers.get_bc(),
                    _ => { panic!("TODO: support more targets") }
                };
                self.push(value);
                self.pc.wrapping_add(1)
            }
            Instruction::POP(target) => {
                let result = self.pop();
                match target {
                    StackTarget::BC => self.registers.set_bc(result),
                    _ => { panic!("TODO: support more targets") }
                };
                self.pc.wrapping_add(1)
            }
            Instruction::ADD(add_type) => {
                match add_type {
                    AddType::ToA(target) => {
                        match target {
                            ArithmeticTarget::A => {
                                let value = self.registers.a;
                                let new_value = self.add(value);
                                self.registers.a = new_value;
                                self.pc.wrapping_add(1)
                            }
                            ArithmeticTarget::B => {
                                let value = self.registers.b;
                                let new_value = self.add(value);
                                self.registers.a = new_value;
                                self.pc.wrapping_add(1)
                            }

                            ArithmeticTarget::C => {
                                let value = self.registers.c;
                                let new_value = self.add(value);
                                self.registers.a = new_value;
                                self.pc.wrapping_add(1)
                            }
                            ArithmeticTarget::D => {
                                let value = self.registers.d;
                                let new_value = self.add(value);
                                self.registers.a = new_value;
                                self.pc.wrapping_add(1)
                            }
                            ArithmeticTarget::E => {
                                let value = self.registers.e;
                                let new_value = self.add(value);
                                self.registers.a = new_value;
                                self.pc.wrapping_add(1)
                            }
                            ArithmeticTarget::H => {
                                let value = self.registers.h;
                                let new_value = self.add(value);
                                self.registers.a = new_value;
                                self.pc.wrapping_add(1)
                            }
                            ArithmeticTarget::L => {
                                let value = self.registers.l;
                                let new_value = self.add(value);
                                self.registers.a = new_value;
                                self.pc.wrapping_add(1)
                            }
                            _ => { /* TODO: add HL, d8, HL HL, HL SP */  panic!("Unkown instruction found for ADD A") }
                        }
                    }
                    _ => { 0u16 /* TODO: add more add types */ }
                }
            }
            Instruction::INC(target) => {
                match target {
                    IncDecTarget::A => {
                        let new_value =  self.registers.a.wrapping_add(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = false;
                        self.registers.f.half_carry = (self.registers.a & 0xF) + 0x1 > 0xF;
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::B => {
                        let new_value = self.registers.b.wrapping_add(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = false;
                        self.registers.f.half_carry = (self.registers.b & 0xF) + 0x1 > 0xF;
                        self.registers.b = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::C => {
                        let new_value = self.registers.c.wrapping_add(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = false;
                        self.registers.f.half_carry = (self.registers.c & 0xF) + 0x1 > 0xF;
                        self.registers.c = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::D => {
                        let new_value = self.registers.d.wrapping_add(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = false;
                        self.registers.f.half_carry = (self.registers.d & 0xF) + 0x1 > 0xF;
                        self.registers.d = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::E => {
                        let new_value = self.registers.e.wrapping_add(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = false;
                        self.registers.f.half_carry = (self.registers.e & 0xF) + 0x1 > 0xF;
                        self.registers.e = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::H => {
                        let new_value =  self.registers.h.wrapping_add(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = false;
                        self.registers.f.half_carry = (self.registers.h & 0xF) + 0x1 > 0xF;
                        self.registers.h = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::L => {
                        let new_value =  self.registers.l.wrapping_add(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = false;
                        self.registers.f.half_carry = (self.registers.l & 0xF) + 0x1 > 0xF;
                        self.registers.l = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::BC => {
                        let new_value =  self.registers.get_bc().wrapping_add(1);
                        self.registers.set_bc(new_value);
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::DE => {
                        let new_value =  self.registers.get_de().wrapping_add(1);
                        self.registers.set_de(new_value);
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::HL => {
                        let new_value =  self.registers.get_hl().wrapping_add(1);
                        self.registers.set_hl(new_value);
                        self.pc.wrapping_add(1)
                    }
                    _ => { 0u16 /* TODO: inc d8 (HL) SP */ }
                }
            }
            Instruction::DEC(target) => {
                match target {
                    IncDecTarget::A => {
                        let new_value =  self.registers.a.wrapping_sub(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = true;
                        self.registers.f.half_carry = (self.registers.a & 0xF) < 0x1;
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::B => {
                        let new_value = self.registers.b.wrapping_sub(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = true;
                        self.registers.f.half_carry = (self.registers.b & 0xF) < 0x1;
                        self.registers.b = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::C => {
                        let new_value = self.registers.c.wrapping_sub(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = true;
                        self.registers.f.half_carry = (self.registers.c & 0xF) < 0x1;
                        self.registers.c = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::D => {
                        let new_value = self.registers.d.wrapping_sub(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = true;
                        self.registers.f.half_carry = (self.registers.d & 0xF) < 0x1;
                        self.registers.d = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::E => {
                        let new_value = self.registers.e.wrapping_sub(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = true;
                        self.registers.f.half_carry = (self.registers.e & 0xF) < 0x1;
                        self.registers.e = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::H => {
                        let new_value =  self.registers.h.wrapping_sub(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = true;
                        self.registers.f.half_carry = (self.registers.h & 0xF) < 0x1;
                        self.registers.h = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::L => {
                        let new_value =  self.registers.l.wrapping_sub(1);
                        self.registers.f.zero = new_value == 0;
                        self.registers.f.subtract = true;
                        self.registers.f.half_carry = (self.registers.l & 0xF) < 0x1;
                        self.registers.l = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::BC => {
                        let new_value =  self.registers.get_bc().wrapping_sub(1);
                        self.registers.set_bc(new_value);
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::DE => {
                        let new_value =  self.registers.get_de().wrapping_sub(1);
                        self.registers.set_de(new_value);
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::HL => {
                        let new_value =  self.registers.get_hl().wrapping_sub(1);
                        self.registers.set_hl(new_value);
                        self.pc.wrapping_add(1)
                    }
                    _ => { 0u16 /* TODO: dec d8 (HL) SP */ }
                }
            }
            Instruction::JP(test) => {
                let jump_condition = match test {
                    JumpTest::NotZero => !self.registers.f.zero,
                    JumpTest::NotCarry => !self.registers.f.carry,
                    JumpTest::Zero => self.registers.f.zero,
                    JumpTest::Carry => self.registers.f.carry,
                    JumpTest::Always => true
                };
                self.jump(jump_condition)
            }
            Instruction::LD(load_type) => {
                match load_type {
                    LoadType::Byte(target, source) => {
                        let source_value = match source {
                            LoadByteSource::A => self.registers.a,
                            LoadByteSource::B => self.registers.b,
                            LoadByteSource::C => self.registers.c,
                            LoadByteSource::D => self.registers.d,
                            LoadByteSource::E => self.registers.e,
                            LoadByteSource::H => self.registers.h,
                            LoadByteSource::L => self.registers.l,
                            LoadByteSource::D8 => self.read_next_byte(),
                            LoadByteSource::HLI => self.bus.read_byte(self.registers.get_hl()),
                            _ => { panic!("TODO: implement other sources") }
                        };
                        match target {
                            LoadByteTarget::A => self.registers.a = source_value,
                            LoadByteTarget::B => self.registers.b = source_value,
                            LoadByteTarget::C => self.registers.c = source_value,
                            LoadByteTarget::D => self.registers.d = source_value,
                            LoadByteTarget::E => self.registers.e = source_value,
                            LoadByteTarget::H => self.registers.h = source_value,
                            LoadByteTarget::L => self.registers.l = source_value,
                            LoadByteTarget::HLI => self.bus.write_byte(self.registers.get_hl(), source_value),
                            _ => { panic!("TODO: implement other targets") }
                        };
                        match source {
                            LoadByteSource::D8  => self.pc.wrapping_add(2),
                            _                   => self.pc.wrapping_add(1),
                        }
                    }
                    _ => { panic!("TODO: implement other load types") }
                }
            }
            _ => { 0u16 /* TODO: support more instructions */ }
        }
    }

    pub(crate) fn push(&mut self, value: u16) {
        self.sp = self.sp.wrapping_sub(1);
        self.bus.write_byte(self.sp, ((value & 0xFF00) >> 8) as u8);

        self.sp = self.sp.wrapping_sub(1);
        self.bus.write_byte(self.sp, (value & 0xFF) as u8);
    }

    pub(crate) fn pop(&mut self) -> u16 {
        let lsb = self.bus.read_byte(self.sp) as u16;
        self.sp = self.sp.wrapping_add(1);

        let msb = self.bus.read_byte(self.sp) as u16;
        self.sp = self.sp.wrapping_add(1);

        (msb << 8) | lsb
    }

    pub(crate) fn read_next_byte(&mut self) -> u8 {
        let byte = self.bus.read_byte(self.pc);
        self.pc = self.pc.wrapping_add(1);
        byte
    }

    pub fn add(&mut self, value: u8) -> u8 {
        let (new_value, did_overflow) = self.registers.a.overflowing_add(value);
        self.registers.f.zero = new_value == 0;
        self.registers.f.subtract = false;
        self.registers.f.carry = did_overflow;
        self.registers.f.half_carry = (self.registers.a & 0xF) + (value & 0xF) > 0xF;
        new_value
    }

    pub fn inc(&mut self, register: u8, flags: &mut FlagsRegister) -> u8 {
        let (new_value, did_overflow) = register.overflowing_add(1);
        flags.zero = new_value == 0;
        flags.subtract = false;
        flags.carry = did_overflow;
        new_value
    }

    pub fn jump(&self, should_jump: bool) -> u16 {
        if should_jump {
            // Gameboy is little endian so read pc + 2 as most significant bit
            // and pc + 1 as least significant bit
            let least_significant_byte = self.bus.read_byte(self.pc + 1) as u16;
            let most_significant_byte = self.bus.read_byte(self.pc + 2) as u16;
            (most_significant_byte << 8) | least_significant_byte
        } else {
            // If we don't jump we need to still move the program
            // counter forward by 3 since the jump instruction is
            // 3 bytes wide (1 byte for tag and 2 bytes for jump address)
            self.pc.wrapping_add(3)
        }
    }
}

impl Display for CPU {
    fn fmt(&self, f: &mut Formatter<'_>) -> Result {
        write!(f, "CPU: A: {:02X} B: {:02X} C: {:02X} D: {:02X} E: {:02X} F: {:02X} H: {:02X} L: {:02X} SP: {:04X} PC: {:04X}",
                self.registers.a,
                self.registers.b,
                self.registers.c,
                self.registers.d,
                self.registers.e,
                u8::from(self.registers.f.clone()),
                self.registers.h,
                self.registers.l,
                self.sp,
                self.pc
        )
    }
}