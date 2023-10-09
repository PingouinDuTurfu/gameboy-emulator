use std::fmt::{Display, Formatter, Result};
use std::ops::Add;

use crate::mods::enum_instructions::{AddType, Arithmetic16Target, ArithmeticTarget, IncDecTarget, Instruction, JumpTest, JumpTestWithHLI, LoadByteSource, LoadByteTarget, LoadType, LoadWordSource, LoadWordTarget, RstTarget, StackTarget};
use crate::mods::flag_register::FlagsRegister;
use crate::mods::memory_bus::MemoryBus;
use crate::mods::register::Registers;

pub struct CPU {
    pub registers: Registers,
    pub pc: u16,
    pub sp: u16,
    pub bus: MemoryBus,
    pub halted: bool,
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
            halted: false,
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
        if self.halted {
            return self.pc.wrapping_add(1);
        }

        match instruction {
            Instruction::PUSH(target) => {
                let value = match target {
                    StackTarget::BC => self.registers.get_bc(),
                    StackTarget::DE => self.registers.get_de(),
                    StackTarget::HL => self.registers.get_hl(),
                    StackTarget::AF => { /* TODO: implement AF */ 0u16 }
                };
                self.push(value);
                self.pc.wrapping_add(1)
            }
            Instruction::POP(target) => {
                let result = self.pop();
                match target {
                    StackTarget::BC => self.registers.set_bc(result),
                    StackTarget::DE => self.registers.set_de(result),
                    StackTarget::HL => self.registers.set_hl(result),
                    StackTarget::AF => { /* TODO: implement AF */ }
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
                            ArithmeticTarget::HLI => {
                                let value = self.bus.read_byte(self.registers.get_hl());
                                let new_value = self.add(value);
                                self.registers.a = new_value;
                                self.pc.wrapping_add(1)
                            }
                            ArithmeticTarget::D8 => {
                                let value = self.read_next_byte();
                                let new_value = self.add(value);
                                self.registers.a = new_value;
                                self.pc.wrapping_add(2)
                            }
                        }
                    }
                    AddType::ToHL(target) => {
                        match target {
                            Arithmetic16Target::BC => {
                                let value = self.registers.get_bc();
                                let new_value = self.add_16(value);
                                self.registers.set_hl(new_value);
                                self.pc.wrapping_add(1)
                            }
                            Arithmetic16Target::DE => {
                                let value = self.registers.get_de();
                                let new_value = self.add_16(value);
                                self.registers.set_hl(new_value);
                                self.pc.wrapping_add(1)
                            }
                            Arithmetic16Target::HL => {
                                let value = self.registers.get_hl();
                                let new_value = self.add_16(value);
                                self.registers.set_hl(new_value);
                                self.pc.wrapping_add(1)
                            }
                            Arithmetic16Target::SP => {
                                let value = self.sp;
                                let new_value = self.add_16(value);
                                self.registers.set_hl(new_value);
                                self.pc.wrapping_add(1)
                            }
                        }
                    }
                    AddType::ToSP => {
                        let value = self.read_next_byte();
                        let new_value = self.add_16(value as u16);
                        self.sp = new_value;
                        self.pc.wrapping_add(2)
                    }
                }
            }
            Instruction::ADC(target) => {
                match target {
                    ArithmeticTarget::A => {
                        let value = self.registers.a;
                        let new_value = self.add_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::B => {
                        let value = self.registers.b;
                        let new_value = self.add_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::C => {
                        let value = self.registers.c;
                        let new_value = self.add_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D => {
                        let value = self.registers.d;
                        let new_value = self.add_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::E => {
                        let value = self.registers.e;
                        let new_value = self.add_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::H => {
                        let value = self.registers.h;
                        let new_value = self.add_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::L => {
                        let value = self.registers.l;
                        let new_value = self.add_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::HLI => {
                        let value = self.bus.read_byte(self.registers.get_hl());
                        let new_value = self.add_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D8 => {
                        let value = self.read_next_byte();
                        let new_value = self.add_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(2)
                    }
                }
            }
            Instruction::SUB(target) => {
                match target {
                    ArithmeticTarget::A => {
                        let value = self.registers.a;
                        let new_value = self.sub(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::B => {
                        let value = self.registers.b;
                        let new_value = self.sub(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::C => {
                        let value = self.registers.c;
                        let new_value = self.sub(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D => {
                        let value = self.registers.d;
                        let new_value = self.sub(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::E => {
                        let value = self.registers.e;
                        let new_value = self.sub(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::H => {
                        let value = self.registers.h;
                        let new_value = self.sub(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::L => {
                        let value = self.registers.l;
                        let new_value = self.sub(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::HLI => {
                        let value = self.bus.read_byte(self.registers.get_hl());
                        let new_value = self.sub(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D8 => {
                        let value = self.read_next_byte();
                        let new_value = self.sub(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(2)
                    }
                }
            }
            Instruction::SBC(target) => {
                match target {
                    ArithmeticTarget::A => {
                        let value = self.registers.a;
                        let new_value = self.sub_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::B => {
                        let value = self.registers.b;
                        let new_value = self.sub_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::C => {
                        let value = self.registers.c;
                        let new_value = self.sub_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D => {
                        let value = self.registers.d;
                        let new_value = self.sub_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::E => {
                        let value = self.registers.e;
                        let new_value = self.sub_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::H => {
                        let value = self.registers.h;
                        let new_value = self.sub_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::L => {
                        let value = self.registers.l;
                        let new_value = self.sub_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::HLI => {
                        let value = self.bus.read_byte(self.registers.get_hl());
                        let new_value = self.sub_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D8 => {
                        let value = self.read_next_byte();
                        let new_value = self.sub_with_carry(value);
                        self.registers.a = new_value;
                        self.pc.wrapping_add(2)
                    }
                }
            }
            Instruction::CP(target) => {
                match target {
                    ArithmeticTarget::A => {
                        let value = self.registers.a;
                        self.cp(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::B => {
                        let value = self.registers.b;
                        self.cp(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::C => {
                        let value = self.registers.c;
                        self.cp(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D => {
                        let value = self.registers.d;
                        self.cp(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::E => {
                        let value = self.registers.e;
                        self.cp(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::H => {
                        let value = self.registers.h;
                        self.cp(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::L => {
                        let value = self.registers.l;
                        self.cp(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::HLI => {
                        let value = self.bus.read_byte(self.registers.get_hl());
                        self.cp(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D8 => {
                        let value = self.read_next_byte();
                        self.cp(value);
                        self.pc.wrapping_add(2)
                    }
                }
            }
            Instruction::AND(target) => {
                match target {
                    ArithmeticTarget::A => {
                        let value = self.registers.a;
                        self.and(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::B => {
                        let value = self.registers.b;
                        self.and(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::C => {
                        let value = self.registers.c;
                        self.and(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D => {
                        let value = self.registers.d;
                        self.and(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::E => {
                        let value = self.registers.e;
                        self.and(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::H => {
                        let value = self.registers.h;
                        self.and(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::L => {
                        let value = self.registers.l;
                        self.and(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::HLI => {
                        let value = self.bus.read_byte(self.registers.get_hl());
                        self.and(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D8 => {
                        let value = self.read_next_byte();
                        self.and(value);
                        self.pc.wrapping_add(2)
                    }
                }
            }
            Instruction::OR(target) => {
                match target {
                    ArithmeticTarget::A => {
                        let value = self.registers.a;
                        self.or(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::B => {
                        let value = self.registers.b;
                        self.or(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::C => {
                        let value = self.registers.c;
                        self.or(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D => {
                        let value = self.registers.d;
                        self.or(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::E => {
                        let value = self.registers.e;
                        self.or(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::H => {
                        let value = self.registers.h;
                        self.or(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::L => {
                        let value = self.registers.l;
                        self.or(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::HLI => {
                        let value = self.bus.read_byte(self.registers.get_hl());
                        self.or(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D8 => {
                        let value = self.read_next_byte();
                        self.or(value);
                        self.pc.wrapping_add(2)
                    }
                }
            }
            Instruction::XOR(target) => {
                match target {
                    ArithmeticTarget::A => {
                        let value = self.registers.a;
                        self.xor(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::B => {
                        let value = self.registers.b;
                        self.xor(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::C => {
                        let value = self.registers.c;
                        self.xor(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D => {
                        let value = self.registers.d;
                        self.xor(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::E => {
                        let value = self.registers.e;
                        self.xor(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::H => {
                        let value = self.registers.h;
                        self.xor(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::L => {
                        let value = self.registers.l;
                        self.xor(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::HLI => {
                        let value = self.bus.read_byte(self.registers.get_hl());
                        self.xor(value);
                        self.pc.wrapping_add(1)
                    }
                    ArithmeticTarget::D8 => {
                        let value = self.read_next_byte();
                        self.xor(value);
                        self.pc.wrapping_add(2)
                    }
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
                    IncDecTarget::SP => {
                        let new_value =  self.sp.wrapping_add(1);
                        self.sp = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::HLI => {
                        let new_value =  self.bus.read_byte(self.registers.get_hl()).wrapping_add(1);
                        self.bus.write_byte(self.registers.get_hl(), new_value);
                        self.pc.wrapping_add(1)
                    }
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
                    IncDecTarget::SP => {
                        let new_value =  self.sp.wrapping_sub(1);
                        self.sp = new_value;
                        self.pc.wrapping_add(1)
                    }
                    IncDecTarget::HLI => {
                        let new_value =  self.bus.read_byte(self.registers.get_hl()).wrapping_sub(1);
                        self.bus.write_byte(self.registers.get_hl(), new_value);
                        self.pc.wrapping_add(1)
                    }
                }
            }
            Instruction::JP(test) => {
                if test == JumpTestWithHLI::HLI {
                    self.pc = self.registers.get_hl();
                    self.pc.wrapping_add(1)
                } else {
                    let jump_condition = match test {
                        JumpTestWithHLI::NotZero => !self.registers.f.zero,
                        JumpTestWithHLI::NotCarry => !self.registers.f.carry,
                        JumpTestWithHLI::Zero => self.registers.f.zero,
                        JumpTestWithHLI::Carry => self.registers.f.carry,
                        JumpTestWithHLI::Always => true,
                        _ => { panic!("Invalid jump test") }
                    };
                    self.jump(jump_condition)
                }
            }
            Instruction::CALL(test) => {
                let jump_condition = match test {
                    JumpTest::NotZero => !self.registers.f.zero,
                    JumpTest::NotCarry => !self.registers.f.carry,
                    JumpTest::Zero => self.registers.f.zero,
                    JumpTest::Carry => self.registers.f.carry,
                    JumpTest::Always => true
                };
                self.call(jump_condition)
            }
            Instruction::RET(test) => {
                let jump_condition = match test {
                    JumpTest::NotZero => !self.registers.f.zero,
                    JumpTest::NotCarry => !self.registers.f.carry,
                    JumpTest::Zero => self.registers.f.zero,
                    JumpTest::Carry => self.registers.f.carry,
                    JumpTest::Always => true
                };
                self.return_(jump_condition)
            }
            Instruction::JR(test) => {
                let jump_condition = match test {
                    JumpTest::NotZero => !self.registers.f.zero,
                    JumpTest::NotCarry => !self.registers.f.carry,
                    JumpTest::Zero => self.registers.f.zero,
                    JumpTest::Carry => self.registers.f.carry,
                    JumpTest::Always => true
                };
                self.jump_relative(jump_condition)
            }
            Instruction::RST(address) => {
                match address {
                    RstTarget::H00 => {
                        self.push(self.pc);
                        self.pc = 0x0000;
                        self.pc.wrapping_add(1)
                    }
                    RstTarget::H08 => {
                        self.push(self.pc);
                        self.pc = 0x0008;
                        self.pc.wrapping_add(1)
                    }
                    RstTarget::H10 => {
                        self.push(self.pc);
                        self.pc = 0x0010;
                        self.pc.wrapping_add(1)
                    }
                    RstTarget::H18 => {
                        self.push(self.pc);
                        self.pc = 0x0018;
                        self.pc.wrapping_add(1)
                    }
                    RstTarget::H20 => {
                        self.push(self.pc);
                        self.pc = 0x0020;
                        self.pc.wrapping_add(1)
                    }
                    RstTarget::H28 => {
                        self.push(self.pc);
                        self.pc = 0x0028;
                        self.pc.wrapping_add(1)
                    }
                    RstTarget::H30 => {
                        self.push(self.pc);
                        self.pc = 0x0030;
                        self.pc.wrapping_add(1)
                    }
                    RstTarget::H38 => {
                        self.push(self.pc);
                        self.pc = 0x0038;
                        self.pc.wrapping_add(1)
                    }
                }
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
                            LoadByteSource::BCI => self.bus.read_byte(self.registers.get_bc()),
                            LoadByteSource::DEI => self.bus.read_byte(self.registers.get_de()),
                            LoadByteSource::HLIInc => {
                                let value = self.bus.read_byte(self.registers.get_hl());
                                self.registers.set_hl(self.registers.get_hl().wrapping_add(1));
                                value
                            }
                            LoadByteSource::HLIDec => {
                                let value = self.bus.read_byte(self.registers.get_hl());
                                self.registers.set_hl(self.registers.get_hl().wrapping_sub(1));
                                value
                            }
                            LoadByteSource::A16I => {
                                let value = self.read_next_word();
                                self.bus.read_byte(value)
                            }
                            LoadByteSource::A8I => {
                                let value = self.read_next_byte();
                                self.bus.read_byte(0xFF00 | value as u16)
                            }
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
                            LoadByteTarget::BCI => self.bus.write_byte(self.registers.get_bc(), source_value),
                            LoadByteTarget::DEI => self.bus.write_byte(self.registers.get_de(), source_value),
                            LoadByteTarget::HLIInc => {
                                self.bus.write_byte(self.registers.get_hl(), source_value);
                                self.registers.set_hl(self.registers.get_hl().wrapping_add(1));
                            }
                            LoadByteTarget::HLIDec => {
                                self.bus.write_byte(self.registers.get_hl(), source_value);
                                self.registers.set_hl(self.registers.get_hl().wrapping_sub(1));
                            }
                            LoadByteTarget::A16I => {
                                let address = self.read_next_word();
                                self.bus.write_byte(address, source_value);
                            }
                            LoadByteTarget::A8I => {
                                let address = self.read_next_byte();
                                self.bus.write_byte(0xFF00 | address as u16, source_value);
                            }
                        };
                        match source {
                            LoadByteSource::D8  => self.pc.wrapping_add(2),
                            _                   => self.pc.wrapping_add(1),
                        }
                    }
                    LoadType::Word(target, source) => {
                        let source_value = match source {
                            LoadWordSource::D16 => self.read_next_word(),
                            LoadWordSource::SP => self.sp,
                            LoadWordSource::HL => self.registers.get_hl(),
                            LoadWordSource::SPPlusD8 => {
                                let offset = self.read_next_byte() as i8 as i16 as u16;
                                self.registers.f.zero = false;
                                self.registers.f.subtract = false;
                                self.registers.f.half_carry = (self.sp & 0xF) + (offset & 0xF) > 0xF;
                                self.registers.f.carry = (self.sp & 0xFF) + (offset & 0xFF) > 0xFF;
                                self.sp.wrapping_add(offset)
                            }
                        };
                        match target {
                            LoadWordTarget::BC => self.registers.set_bc(source_value),
                            LoadWordTarget::DE => self.registers.set_de(source_value),
                            LoadWordTarget::HL => self.registers.set_hl(source_value),
                            LoadWordTarget::SP => self.sp = source_value,
                            LoadWordTarget::A16I => {
                                let address = self.read_next_word();
                                self.bus.write_word(address, source_value);
                            }
                        };
                        match source {
                            LoadWordSource::D16 => self.pc.wrapping_add(3),
                            LoadWordSource::SP => self.pc.wrapping_add(3),
                            LoadWordSource::SPPlusD8 => self.pc.wrapping_add(2),
                            _ => self.pc.wrapping_add(1),
                        }
                    }
                }
            }
            Instruction::CCF => {
                self.registers.f.subtract = false;
                self.registers.f.half_carry = false;
                self.registers.f.carry = !self.registers.f.carry;
                self.pc.wrapping_add(1)
            }
            Instruction::SCF => {
                self.registers.f.subtract = false;
                self.registers.f.half_carry = false;
                self.registers.f.carry = true;
                self.pc.wrapping_add(1)
            }
            Instruction::DAA => {
                let mut a = self.registers.a;
                let mut adjust = if self.registers.f.carry { 0x60 } else { 0x00 };
                if self.registers.f.half_carry { adjust |= 0x06; };
                if !self.registers.f.subtract {
                    if a & 0x0F > 0x09 { adjust |= 0x06; };
                    if a > 0x99 { adjust |= 0x60; };
                    a = a.wrapping_add(adjust);
                } else {
                    a = a.wrapping_sub(adjust);
                }

                self.registers.f.carry = adjust >= 0x60;
                self.registers.f.half_carry = false;
                self.registers.f.zero = a == 0;
                self.registers.a = a;
                self.pc.wrapping_add(1)
            }
            Instruction::CPL => {
                self.registers.a = !self.registers.a;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = true;
                self.pc.wrapping_add(1)
            }
            Instruction::HALT => {
                self.halted = true;
                self.pc.wrapping_add(1)
            }
            Instruction::NOP => {
                self.pc.wrapping_add(1)
            }
            Instruction::STOP => {
                // Stop clock
                panic!("TODO: implement STOP")
            }
            Instruction::DI => {
                // Disable interrupts => IME = 0 and cancel any pending EI
                panic!("TODO: implement DI")
            }
            Instruction::EI => {
                // Schedule interrupt enable
                panic!("TODO: implement EI")
            }

            Instruction::RLC(_) => {
                panic!("TODO: implement RLC")
            }
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

    pub fn add(&mut self, value: u8) -> u8 {
        let (new_value, did_overflow) = self.registers.a.overflowing_add(value);
        self.registers.f.zero = new_value == 0;
        self.registers.f.subtract = false;
        self.registers.f.carry = did_overflow;
        self.registers.f.half_carry = (self.registers.a & 0xF) + (value & 0xF) > 0xF;
        new_value
    }

    pub fn add_16(&mut self, value: u16) -> u16 {
        let (new_value, did_overflow) = self.registers.get_hl().overflowing_add(value);
        self.registers.f.subtract = false;
        self.registers.f.carry = did_overflow;
        self.registers.f.half_carry = (self.registers.get_hl() & 0xFFF) + (value & 0xFFF) > 0xFFF;
        new_value
    }

    pub fn add_with_carry(&mut self, value: u8) -> u8 {
        let carry = if self.registers.f.carry { 1 } else { 0 };
        let (new_value, did_overflow) = self.registers.a.overflowing_add(value + carry);
        self.registers.f.zero = new_value == 0;
        self.registers.f.subtract = false;
        self.registers.f.carry = did_overflow;
        self.registers.f.half_carry = (self.registers.a & 0xF) + (value & 0xF) + carry > 0xF;
        new_value
    }

    pub fn sub(&mut self, value: u8) -> u8 {
        let (new_value, did_overflow) = self.registers.a.overflowing_sub(value);
        self.registers.f.zero = new_value == 0;
        self.registers.f.subtract = true;
        self.registers.f.carry = did_overflow;
        self.registers.f.half_carry = (self.registers.a & 0xF) < (value & 0xF);
        new_value
    }

    pub fn sub_with_carry(&mut self, value: u8) -> u8 {
        let carry = if self.registers.f.carry { 1 } else { 0 };
        let (new_value, did_overflow) = self.registers.a.overflowing_sub(value + carry);
        self.registers.f.zero = new_value == 0;
        self.registers.f.subtract = true;
        self.registers.f.carry = did_overflow;
        self.registers.f.half_carry = (self.registers.a & 0xF) < (value & 0xF) + carry;
        new_value
    }

    pub fn cp(&mut self, value: u8) {
        let (new_value, did_overflow) = self.registers.a.overflowing_sub(value);
        self.registers.f.zero = new_value == 0;
        self.registers.f.subtract = true;
        self.registers.f.carry = did_overflow;
        self.registers.f.half_carry = (self.registers.a & 0xF) < (value & 0xF);
    }

    pub fn and(&mut self, value: u8) {
        let new_value = self.registers.a & value;
        self.registers.f.zero = new_value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = true;
        self.registers.f.carry = false;
        self.registers.a = new_value;
    }

    pub fn or(&mut self, value: u8) {
        let new_value = self.registers.a | value;
        self.registers.f.zero = new_value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = false;
        self.registers.f.carry = false;
        self.registers.a = new_value;
    }

    pub fn xor(&mut self, value: u8) {
        let new_value = self.registers.a ^ value;
        self.registers.f.zero = new_value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = false;
        self.registers.f.carry = false;
        self.registers.a = new_value;
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

    fn call(&mut self, should_jump: bool) -> u16 {
        let next_pc = self.pc.wrapping_add(3);
        if should_jump {
            self.push(next_pc);
            self.read_next_word()
        } else {
            next_pc
        }
    }

    fn return_(&mut self, should_jump: bool) -> u16 {
        if should_jump {
            self.pop()
        } else {
            self.pc.wrapping_add(1)
        }
    }

    fn jump_relative(&mut self, should_jump: bool) -> u16 {
        if should_jump {
            let offset = self.read_next_byte() as i8 as i16;
            self.pc.wrapping_add(offset as u16)
        } else {
            self.pc.wrapping_add(2)
        }
    }

    fn read_next_word(&mut self) -> u16 {
        let least_significant_byte = self.bus.read_byte(self.pc + 1) as u16;
        let most_significant_byte = self.bus.read_byte(self.pc + 2) as u16;
        (most_significant_byte << 8) | least_significant_byte
    }

    pub(crate) fn read_next_byte(&mut self) -> u8 {
        let byte = self.bus.read_byte(self.pc);
        self.pc = self.pc.wrapping_add(1);
        byte
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