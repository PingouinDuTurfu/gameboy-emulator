use std::fmt::{Display, format, Formatter, Result};
use sdl2::libc::printf;
use sdl2::render::Texture;

use crate::mods::bus::Bus;
use crate::mods::emulator::PRINT_DEBUG;
use crate::mods::flag_register::FlagsRegister;
use crate::mods::mbc_default::MbcDefault;
use crate::mods::register::Registers;

pub struct CPU {
    pub registers: Registers,
    pub bus: Bus,
    pub pc: u16,
    pub sp: u16,
    pub halted: bool,
    pub ime: bool,
    pub ime_scheduled: bool,
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
            pc: 0x0100,
            sp: 0xFFFE,
            bus: Bus::new(),
            halted: false,
            ime: false,
            ime_scheduled: false,
        }
    }

    pub fn init(&mut self, checksum: u8) {
        self.registers.init(checksum);
        self.bus.init();
    }

    pub(crate) fn step(&mut self, debug: bool) {
        if self.ime_scheduled == true {
            self.ime_scheduled = false;
            self.ime = true;
        }

        let instruction_byte = self.read_pc();

        let prefixed = instruction_byte == 0xCB;
        if prefixed {
            let prefix_instruction_byte = self.read_pc();
            if debug {
                unsafe {
                    PRINT_DEBUG.add_data(format!("{}\n", CPU::print_debug_prefixed(prefix_instruction_byte)));
                }
            }
            self.execute_prefixed(prefix_instruction_byte);
        } else {
            if debug {
                unsafe {
                    let a = format!("step {} 0x{:04X} 0x{:02X} {} \n", PRINT_DEBUG.global_index, self.pc - 1, instruction_byte.clone(), CPU::print_debug(instruction_byte.clone()));
                    PRINT_DEBUG.add_data(format!("{}", a));
                }
            }
            self.execute(instruction_byte);
        }

    }

    pub fn execute(&mut self, byte: u8) {
        if self.halted {
            self.pc = self.pc.wrapping_add(1);
        }

        match byte {
            0x00 => {}
            0x01 => {
                let value = self.read_next_word();
                self.registers.set_bc(value); 
            }
            0x02 => {
                let value = self.registers.a;
                let address = self.registers.get_bc();
                self.write_byte(address, value);
            }
            0x03 => {
                let value = self.registers.get_bc().wrapping_add(1);
                self.registers.set_bc(value);
                self.internal_cycle();
            }
            0x04 => {
                let value = self.registers.b.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.b & 0xF) + 0x1 > 0xF;
                self.registers.b = value;
            }
            0x05 => {
                let value = self.registers.b.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.b & 0xF) < 0x1;
                self.registers.b = value;
            }
            0x06 => {
                self.registers.b = self.read_pc();
            }
            0x07 => {
                self.registers.a = self.rlc(self.registers.a);
                self.registers.f.zero = false;
            }
            0x08 => {
                let address = self.read_next_word();
                self.write_word(address, self.sp);
            }
            0x09 => {
                let value = self.registers.get_bc();
                let value = self.add_16(value);
                self.registers.set_hl(value);
                self.internal_cycle();
            }
            0x0a => {
                self.registers.a = self.read_address(self.registers.get_bc());
            }
            0x0b => {
                let value = self.registers.get_bc().wrapping_sub(1);
                self.registers.set_bc(value);
                self.internal_cycle();
            }
            0x0c => {
                let value = self.registers.c.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.c & 0xF) + 0x1 > 0xF;
                self.registers.c = value;
            }
            0x0d => {
                let value = self.registers.c.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.c & 0xF) < 0x1;
                self.registers.c = value;
            }
            0x0e => {
                self.registers.c = self.read_pc();
            }
            0x0f => {
                let value = self.registers.a;
                let value = self.rrc(value);
                self.registers.a = value;
                self.registers.f.zero = false;
            }
            0x10 => {
                // Stop clock
                panic!("TODO: implement STOP");
            }
            0x11 => {
                let value = self.read_next_word();
                self.registers.set_de(value);
            }
            0x12 => {
                self.write_byte(self.registers.get_de(), self.registers.a);
            }
            0x13 =>  {
                let value =  self.registers.get_de().wrapping_add(1);
                self.registers.set_de(value);
                self.internal_cycle();
            }
            0x14 => {
                let value = self.registers.d.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.d & 0xF) + 0x1 > 0xF;
                self.registers.d = value;
            }
            0x15 => {
                let value = self.registers.d.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.d & 0xF) < 0x1;
                self.registers.d = value;
            }
            0x16 => {
                self.registers.d = self.read_pc();
            }
            0x17 => {
                let value = self.registers.a;
                let value = self.rl(value);
                self.registers.a = value;
                self.registers.f.zero = false;
            }
            0x18 => {
                self.jump_relative(true);
            }
            0x19 => {
                let value = self.registers.get_de();
                let value = self.add_16(value);
                self.registers.set_hl(value);
                self.internal_cycle();
            }
            0x1a => {
                self.registers.a = self.read_address(self.registers.get_de());
            }
            0x1b =>  {
                let value =  self.registers.get_de().wrapping_sub(1);
                self.registers.set_de(value);
                self.internal_cycle();
            }
            0x1c => {
                let value = self.registers.e.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.e & 0xF) + 0x1 > 0xF;
                self.registers.e = value;
            }
            0x1d => {
                let value = self.registers.e.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.e & 0xF) < 0x1;
                self.registers.e = value;
            }
            0x1e => {
                self.registers.e = self.read_pc();
            }
            0x1f => {
                let value = self.registers.a;
                let value = self.rr(value);
                self.registers.a = value;
                self.registers.f.zero = false;
            }
            0x20 => {
                let should_jump = !self.registers.f.zero;
                let r8 = self.read_pc();

                if should_jump {
                    self.internal_cycle();
                    let offset = r8 as i8;
                    self.pc = self.pc.wrapping_add(offset as u16);
                }
            }
            0x21 => {
                let value = self.read_next_word();
                self.registers.set_hl(value);
            }
            0x22 => {
                self.write_byte(self.registers.get_hl(), self.registers.a);
                self.registers.set_hl(self.registers.get_hl().wrapping_add(1));
            }
            0x23 => {
                let value =  self.registers.get_hl().wrapping_add(1);
                self.registers.set_hl(value);
                self.internal_cycle();
            }
            0x24 => {
                let value =  self.registers.h.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.h & 0xF) + 0x1 > 0xF;
                self.registers.h = value;
            }
            0x25 => {
                let value =  self.registers.h.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.h & 0xF) < 0x1;
                self.registers.h = value;
            }
            0x26 => {
                self.registers.h = self.read_pc();
            }
            0x27 => {
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
            }
            0x28 => {
                let should_jump = self.registers.f.zero;
                let r8 = self.read_pc();

                unsafe {
                    // if PRINT_DEBUG.global_index == 98771 {
                    //     PRINT_DEBUG.add_data(format!("Eval cond: {}, r8: {:#04X}\n", should_jump, r8));
                    // }
                }
                if should_jump {
                    self.internal_cycle();
                    let offset = r8 as i8;
                    self.pc = self.pc.wrapping_add(offset as u16);
                }
            }
            0x29 => {
                let value = self.registers.get_hl();
                let value = self.add_16(value);
                self.registers.set_hl(value);
                self.internal_cycle();
            }
            0x2a => {
                self.registers.a = self.read_address(self.registers.get_hl());
                self.registers.set_hl(self.registers.get_hl().wrapping_add(1));
            }
            0x2b => {
                let value =  self.registers.get_hl().wrapping_sub(1);
                self.registers.set_hl(value);
                self.internal_cycle();
            }
            0x2c => {
                let value =  self.registers.l.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.l & 0xF) + 0x1 > 0xF;
                self.registers.l = value;
            }
            0x2d => {
                let value =  self.registers.l.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.l & 0xF) < 0x1;
                self.registers.l = value;
            }
            0x2e => {
                self.registers.l = self.read_pc();
            }
            0x2f => {
                self.registers.a = !self.registers.a;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = true;
            }
            0x30 => {
                self.jump_relative(!self.registers.f.carry);
            }
            0x31 => {
                self.sp = self.read_next_word();
            }
            0x32 => {
                self.write_byte(self.registers.get_hl(), self.registers.a);
                self.registers.set_hl(self.registers.get_hl().wrapping_sub(1));
            }
            0x33 => {
                let value =  self.sp.wrapping_add(1);
                self.sp = value;
                self.internal_cycle();
            }
            0x34 => {
                let value =  self.read_address(self.registers.get_hl()).wrapping_add(1);
                self.write_byte(self.registers.get_hl(), value);
            }
            0x35 => {
                let value =  self.read_address(self.registers.get_hl()).wrapping_sub(1);
                self.write_byte(self.registers.get_hl(), value);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.l & 0xF) < 0x1;
            }
            0x36 => {
                let value = self.read_pc();
                let address = self.registers.get_hl();
                self.write_byte(address, value);
            }
            0x37 => {
                self.registers.f.subtract = false;
                self.registers.f.half_carry = false;
                self.registers.f.carry = true;
            }
            0x38 => {
                self.jump_relative(self.registers.f.carry);
            }
            0x39 => {
                let value = self.sp;
                let value = self.add_16(value);
                self.registers.set_hl(value);
                self.internal_cycle();
            }
            0x3a => {
                self.registers.a = self.read_address(self.registers.get_hl());
                self.registers.set_hl(self.registers.get_hl().wrapping_sub(1));
            }
            0x3b => {
                let value =  self.sp.wrapping_sub(1);
                self.sp = value;
                self.internal_cycle();
            }
            0x3c => {
                let value =  self.registers.a.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.a & 0xF) + 0x1 > 0xF;
                self.registers.a = value;
            }
            0x3d => {
                let value =  self.registers.a.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.a & 0xF) < 0x1;
                self.registers.a = value;
            }
            0x3e => {
                self.registers.a = self.read_pc();
            }
            0x3f => {
                self.registers.f.subtract = false;
                self.registers.f.half_carry = false;
                self.registers.f.carry = !self.registers.f.carry;
            }
            0x40 => {
                self.registers.b = self.registers.b;
            }
            0x41 => {
                self.registers.b = self.registers.c;
            }
            0x42 => {
                self.registers.b = self.registers.d;
            }
            0x43 => {
                self.registers.b = self.registers.e;
            }
            0x44 => {
                self.registers.b = self.registers.h;
            }
            0x45 => {
                self.registers.b = self.registers.l;
            }
            0x46 => {
                self.registers.b = self.read_address(self.registers.get_hl());
            }
            0x47 => {
                self.registers.b = self.registers.a;
            }
            0x48 => {
                self.registers.c = self.registers.b;
            }
            0x49 => {
                self.registers.c = self.registers.c;
            }
            0x4a => {
                self.registers.c = self.registers.d;
            }
            0x4b => {
                self.registers.c = self.registers.e;
            }
            0x4c => {
                self.registers.c = self.registers.h;
            }
            0x4d => {
                self.registers.c = self.registers.l;
            }
            0x4e => {
                self.registers.c = self.read_address(self.registers.get_hl());
            }
            0x4f => {
                self.registers.c = self.registers.a;
            }
            0x50 => {
                self.registers.d = self.registers.b;
            }
            0x51 => {
                self.registers.d = self.registers.c;
            }
            0x52 => {
                self.registers.d = self.registers.d;
            }
            0x53 => {
                self.registers.d = self.registers.e;
            }
            0x54 => {
                self.registers.d = self.registers.h;
            }
            0x55 => {
                self.registers.d = self.registers.l;
            }
            0x56 => {
                self.registers.d = self.read_address(self.registers.get_hl());
            }
            0x57 => {
                self.registers.d = self.registers.a;
            }
            0x58 => {
                self.registers.e = self.registers.b;
            }
            0x59 => {
                self.registers.e = self.registers.c;
            }
            0x5a => {
                self.registers.e = self.registers.d;
            }
            0x5b => {
                self.registers.e = self.registers.e;
            }
            0x5c => {
                self.registers.e = self.registers.h;
            }
            0x5d => {
                self.registers.e = self.registers.l;
            }
            0x5e => {
                self.registers.e = self.read_address(self.registers.get_hl());
            }
            0x5f => {
                self.registers.e = self.registers.a;
            }
            0x60 => {
                self.registers.h = self.registers.b;
            }
            0x61 => {
                self.registers.h = self.registers.c;
            }
            0x62 => {
                self.registers.h = self.registers.d;
            }
            0x63 => {
                self.registers.h = self.registers.e;
            }
            0x64 => {
                self.registers.h = self.registers.h;
            }
            0x65 => {
                self.registers.h = self.registers.l;
            }
            0x66 => {
                self.registers.h = self.read_address(self.registers.get_hl());
            }
            0x67 => {
                self.registers.h = self.registers.a;
            }
            0x68 => {
                self.registers.l = self.registers.b;
            }
            0x69 => {
                self.registers.l = self.registers.c;
            }
            0x6a => {
                self.registers.l = self.registers.d;
            }
            0x6b => {
                self.registers.l = self.registers.e;
            }
            0x6c => {
                self.registers.l = self.registers.h;
            }
            0x6d => {
                self.registers.l = self.registers.l;
            }
            0x6e => {
                self.registers.l = self.read_address(self.registers.get_hl());
            }
            0x6f => {
                self.registers.l = self.registers.a;
            }
            0x70 => {
                self.write_byte(self.registers.get_hl(), self.registers.b);
            }
            0x71 => {
                self.write_byte(self.registers.get_hl(), self.registers.c);
            }
            0x72 => {
                self.write_byte(self.registers.get_hl(), self.registers.d);
            }
            0x73 => {
                self.write_byte(self.registers.get_hl(), self.registers.e);
            }
            0x74 => {
                self.write_byte(self.registers.get_hl(), self.registers.h);
            }
            0x75 => {
                self.write_byte(self.registers.get_hl(), self.registers.l);
            }
            0x76 => {
                self.halted = true;
            }
            0x77 => {
                self.write_byte(self.registers.get_hl(), self.registers.a);
            }
            0x78 => {
                self.registers.a = self.registers.b;
            }
            0x79 => {
                self.registers.a = self.registers.c;
            }
            0x7a => {
                self.registers.a = self.registers.d;
            }
            0x7b => {
                self.registers.a = self.registers.e;
            }
            0x7c => {
                self.registers.a = self.registers.h;
            }
            0x7d => {
                self.registers.a = self.registers.l;
            }
            0x7e => {
                self.registers.a = self.read_address(self.registers.get_hl());
            }
            0x7f => {
                self.registers.a = self.registers.a;
            }
            0x80 => {
                let value = self.registers.b;
                let value = self.add(value);
                self.registers.a = value;
            }
            0x81 => {
                let value = self.registers.c;
                let value = self.add(value);
                self.registers.a = value;
            }
            0x82 => {
                let value = self.registers.d;
                let value = self.add(value);
                self.registers.a = value;
            }
            0x83 => {
                let value = self.registers.e;
                let value = self.add(value);
                self.registers.a = value;
            }
            0x84 => {
                let value = self.registers.h;
                let value = self.add(value);
                self.registers.a = value;
            }
            0x85 => {
                let value = self.registers.l;
                let value = self.add(value);
                self.registers.a = value;
            }
            0x86 => {
                let value = self.read_address(self.registers.get_hl());
                let value = self.add(value);
                self.registers.a = value;
            }
            0x87 => {
                let value = self.registers.a;
                let value = self.add(value);
                self.registers.a = value;
            }
            0x88 => {
                let value = self.registers.b;
                let value = self.add_with_carry(value);
                self.registers.a = value;
            }
            0x89 => {
                let value = self.registers.c;
                let value = self.add_with_carry(value);
                self.registers.a = value;
            }
            0x8a => {
                let value = self.registers.d;
                let value = self.add_with_carry(value);
                self.registers.a = value;
            }
            0x8b => {
                let value = self.registers.e;
                let value = self.add_with_carry(value);
                self.registers.a = value;
            }
            0x8c => {
                let value = self.registers.h;
                let value = self.add_with_carry(value);
                self.registers.a = value;
            }
            0x8d => {
                let value = self.registers.l;
                let value = self.add_with_carry(value);
                self.registers.a = value;
            }
            0x8e => {
                let value = self.read_address(self.registers.get_hl());
                let value = self.add_with_carry(value);
                self.registers.a = value;
            }
            0x8f => {
                let value = self.registers.a;
                let value = self.add_with_carry(value);
                self.registers.a = value;
            }
            0x90 => {
                let value = self.registers.b;
                let value = self.sub(value);
                self.registers.a = value;
            }
            0x91 => {
                let value = self.registers.c;
                let value = self.sub(value);
                self.registers.a = value;
            }
            0x92 => {
                let value = self.registers.d;
                let value = self.sub(value);
                self.registers.a = value;
            }
            0x93 => {
                let value = self.registers.e;
                let value = self.sub(value);
                self.registers.a = value;
            }
            0x94 => {
                let value = self.registers.h;
                let value = self.sub(value);
                self.registers.a = value;
            }
            0x95 => {
                let value = self.registers.l;
                let value = self.sub(value);
                self.registers.a = value;
            }
            0x96 => {
                let value = self.read_address(self.registers.get_hl());
                let value = self.sub(value);
                self.registers.a = value;
            }
            0x97 => {
                let value = self.registers.a;
                let value = self.sub(value);
                self.registers.a = value;
            }
            0x98 => {
                let value = self.registers.b;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
            }
            0x99 => {
                let value = self.registers.c;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
            }
            0x9a => {
                let value = self.registers.d;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
            }
            0x9b => {
                let value = self.registers.e;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
            }
            0x9c => {
                let value = self.registers.h;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
            }
            0x9d => {
                let value = self.registers.l;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
            }
            0x9e => {
                let value = self.read_address(self.registers.get_hl());
                let value = self.sub_with_carry(value);
                self.registers.a = value;
            }
            0x9f => {
                let value = self.registers.a;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
            }
            0xa0 => {
                let value = self.registers.b;
                self.and(value);
            }
            0xa1 => {
                let value = self.registers.c;
                self.and(value);
            }
            0xa2 => {
                let value = self.registers.d;
                self.and(value);
            }
            0xa3 => {
                let value = self.registers.e;
                self.and(value);
            }
            0xa4 => {
                let value = self.registers.h;
                self.and(value);
            }
            0xa5 => {
                let value = self.registers.l;
                self.and(value);
            }
            0xa6 => {
                let value = self.read_address(self.registers.get_hl());
                self.and(value);
            }
            0xa7 => {
                let value = self.registers.a;
                self.and(value);
            }
            0xa8 => {
                let value = self.registers.b;
                self.xor(value);
            }
            0xa9 => {
                let value = self.registers.c;
                self.xor(value);
            }
            0xaa => {
                let value = self.registers.d;
                self.xor(value);
            }
            0xab => {
                let value = self.registers.e;
                self.xor(value);
            }
            0xac => {
                let value = self.registers.h;
                self.xor(value);
            }
            0xad => {
                let value = self.registers.l;
                self.xor(value);
            }
            0xae => {
                let value = self.read_address(self.registers.get_hl());
                self.xor(value);
            }
            0xaf => {
                let value = self.registers.a;
                self.xor(value);
            }
            0xb0 => {
                let value = self.registers.b;
                self.or(value);
            }
            0xb1 => {
                let value = self.registers.c;
                self.or(value);
            }
            0xb2 => {
                let value = self.registers.d;
                self.or(value);
            }
            0xb3 => {
                let value = self.registers.e;
                self.or(value);
            }
            0xb4 => {
                let value = self.registers.h;
                self.or(value);
            }
            0xb5 => {
                let value = self.registers.l;
                self.or(value);
            }
            0xb6 => {
                let value = self.read_address(self.registers.get_hl());
                self.or(value);
            }
            0xb7 => {
                let value = self.registers.a;
                self.or(value);
            }
            0xb8 => {
                let value = self.registers.b;
                self.cp(value);
            }
            0xb9 => {
                let value = self.registers.c;
                self.cp(value);
            }
            0xba => {
                let value = self.registers.d;
                self.cp(value);
            }
            0xbb => {
                let value = self.registers.e;
                self.cp(value);
            }
            0xbc => {
                let value = self.registers.h;
                self.cp(value);
            }
            0xbd => {
                let value = self.registers.l;
                self.cp(value);
            }
            0xbe => {
                let value = self.read_address(self.registers.get_hl());
                self.cp(value);
            }
            0xbf => {
                let value = self.registers.a;
                self.cp(value);
            }
            0xc0 => {
                self.return_(!self.registers.f.zero);
            }
            0xc1 => {
                let value = self.pop();
                self.registers.set_bc(value);
            }
            0xc2 => {
                self.jump(!self.registers.f.zero);
            }
            0xc3 => {
                self.jump(true);
            }
            0xc4 => {
                self.call(!self.registers.f.zero);
            }
            0xc5 => {
                self.internal_cycle();
                self.push(self.registers.get_bc());
            }
            0xc6 => {
                let value = self.read_pc();
                let value = self.add(value);
                self.registers.a = value;
            }
            0xc7 => {
                self.internal_cycle();
                self.push(self.pc);
                self.pc = 0x0000;
            }
            0xc8 => {
                self.return_(self.registers.f.zero);
            }
            0xc9 => {
                self.pc = self.pop();
                self.internal_cycle();
            }
            0xca => {
                self.jump(self.registers.f.zero);
            }
            0xcc => {
                self.call(self.registers.f.zero);
            }
            0xcd => {
                self.call(true);
            }
            0xce => {
                let value = self.read_pc();
                let value = self.add_with_carry(value);
                self.registers.a = value;
            }
            0xcf => {
                self.internal_cycle();
                self.push(self.pc);
                self.pc = 0x0008;
            }
            0xd0 => {
                self.return_(!self.registers.f.carry);
            }
            0xd1 => {
                let value = self.pop();
                self.registers.set_de(value);
            }
            0xd2 => {
                self.jump(!self.registers.f.carry);
            }
            0xd4 => {
                self.call(!self.registers.f.carry);
            }
            0xd5 => {
                self.internal_cycle();
                self.push(self.registers.get_de());
            }
            0xd6 => {
                let value = self.read_pc();
                let value = self.sub(value);
                self.registers.a = value;
            }
            0xd7 => {
                self.internal_cycle();
                self.push(self.pc);
                self.pc = 0x0010;
            }
            0xd8 => {
                self.return_(self.registers.f.carry);
            }
            0xd9 => {
                self.pc = self.pop();
                self.internal_cycle();
                self.ime = true;
            }
            0xda => {
                self.jump(self.registers.f.carry);
            }
            0xdc => {
                self.call(self.registers.f.carry);
            }
            0xde => {
                let value = self.read_pc();
                let value = self.sub_with_carry(value);
                self.registers.a = value;
            }
            0xdf => {
                self.internal_cycle();
                self.push(self.pc);
                self.pc = 0x0018;
            }
            0xe0 => {
                let address = self.read_pc();
                // unsafe {
                //     PRINT_DEBUG.add_data(format!("Writing to {:04X} {:02X}\n", address, self.registers.a));
                // }
                self.write_byte(0xFF00 | address as u16, self.registers.a);
            }
            0xe1 => {
                let value = self.pop();
                self.registers.set_hl(value);
            }
            0xe2 => {
                self.write_byte(0xFF00 | self.registers.c as u16, self.registers.a);
            }
            0xe5 => {
                self.internal_cycle();
                self.push(self.registers.get_hl());
            }
            0xe6 => {
                let value = self.read_pc();
                self.and(value);
                // unsafe {
                //     PRINT_DEBUG.add_data(format!("AND {:02X}\n", self.registers.a));
                // }
            }
            0xe7 => {
                self.internal_cycle();
                self.push(self.pc);
                self.pc = 0x0020;
            }
            0xe8 => {
                let value = self.read_pc();
                let value = self.add_16(value as u16);

                self.internal_cycle();
                self.internal_cycle();
                self.sp = value;
            }
            0xe9 => {
                self.pc = self.registers.get_hl();
            }
            0xea => {
                let address = self.read_next_word();
                self.write_byte(address, self.registers.a);
            }
            0xee => {
                let value = self.read_pc();
                self.xor(value);
            }
            0xef => {
                self.internal_cycle();
                self.push(self.pc);
                self.pc = 0x0028;
            }
            0xf0 => {
                let address = self.read_pc();
                self.registers.a = self.read_address(0xFF00 | address as u16);
                // self.registers.a = 0x94;
                // unsafe {
                //     PRINT_DEBUG.add_data(format!("Reading from {:04X} {:04X} val: {:04X}\n", address, 0xFF00 | address as u16, self.registers.a));
                // }
            }
            0xf1 => {
                let value = self.pop();
                self.registers.set_af(value);
            }
            0xf2 => {
                self.registers.a = self.read_address(0xFF00 | self.registers.c as u16);
            }
            0xf3 => {
                // Disable interrupts => IME = 0 and cancel any pending EI
                self.ime = false;
            }
            0xf5 => {
                self.internal_cycle();
                self.push(self.registers.get_af());
            }
            0xf6 => {
                let value = self.read_pc();
                self.or(value);
            }
            0xf7 => {
                self.internal_cycle();
                self.push(self.pc);
                self.pc = 0x0030;
            }
            0xf8 => {
                let offset = self.read_pc() as i8 as i16 as u16;
                self.registers.f.zero = false;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.sp & 0xF) + (offset & 0xF) > 0xF;
                self.registers.f.carry = (self.sp & 0xFF) + (offset & 0xFF) > 0xFF;
                self.registers.set_hl(self.sp.wrapping_add(offset));
                self.internal_cycle();
            }
            0xf9 => {
                self.sp = self.registers.get_hl();
                self.internal_cycle();
            }
            0xfa => {
                let address = self.read_next_word();
                self.registers.a = self.read_address(address);
            }
            0xfb => {
                // Schedule interrupt enable
                self.ime_scheduled = true;
            }
            0xfe => {
                let value = self.read_pc();
                self.cp(value);
            }
            0xff => {
                self.internal_cycle();
                self.push(self.pc);
                self.pc = 0x0038;
            }

            _ => panic!("Unknown instruction: {:x}", byte),
        };
    }

    pub fn execute_prefixed(&mut self, byte: u8) {
        match byte {
            0x00 => {
                self.registers.b = self.rlc(self.registers.b);
            }
            0x01 => {
                self.registers.c = self.rlc(self.registers.c);
            }
            0x02 => {
                self.registers.d = self.rlc(self.registers.d);
            }
            0x03 => {
                self.registers.e = self.rlc(self.registers.e);
            }
            0x04 => {
                self.registers.h = self.rlc(self.registers.h);
            }
            0x05 => {
                self.registers.l = self.rlc(self.registers.l);
            }
            0x06 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.rlc(value);
                self.write_byte(address, new_value);
            }
            0x07 => {
                self.registers.a = self.rlc(self.registers.a);
            }
            0x08 => {
                self.registers.b = self.rrc(self.registers.b);
            }
            0x09 => {
                self.registers.c = self.rrc(self.registers.c);
            }
            0x0a => {
                self.registers.d = self.rrc(self.registers.d);
            }
            0x0b => {
                self.registers.e = self.rrc(self.registers.e);
            }
            0x0c => {
                self.registers.h = self.rrc(self.registers.h);
            }
            0x0d => {
                self.registers.l = self.rrc(self.registers.l);
            }
            0x0e => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.rrc(value);
                self.write_byte(address, new_value);
            }
            0x0f => {
                self.registers.a = self.rrc(self.registers.a);
            }
            0x10 => {
                self.registers.b = self.rl(self.registers.b);
            }
            0x11 => {
                self.registers.c = self.rl(self.registers.c);
            }
            0x12 => {
                self.registers.d = self.rl(self.registers.d);
            }
            0x13 => {
                self.registers.e = self.rl(self.registers.e);
            }
            0x14 => {
                self.registers.h = self.rl(self.registers.h);
            }
            0x15 => {
                self.registers.l = self.rl(self.registers.l);
            }
            0x16 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.rl(value);
                self.write_byte(address, new_value);
            }
            0x17 => {
                self.registers.a = self.rl(self.registers.a);
            }
            0x18 => {
                self.registers.b = self.rr(self.registers.b);
            }
            0x19 => {
                self.registers.c = self.rr(self.registers.c);
            }
            0x1a => {
                self.registers.d = self.rr(self.registers.d);
            }
            0x1b => {
                self.registers.e = self.rr(self.registers.e);
            }
            0x1c => {
                self.registers.h = self.rr(self.registers.h);
            }
            0x1d => {
                self.registers.l = self.rr(self.registers.l);
            }
            0x1e => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.rr(value);
                self.write_byte(address, new_value);
            }
            0x1f => {
                self.registers.a = self.rr(self.registers.a);
            }
            0x20 => {
                self.registers.b = self.sla(self.registers.b);
            }
            0x21 => {
                self.registers.c = self.sla(self.registers.c);
            }
            0x22 => {
                self.registers.d = self.sla(self.registers.d);
            }
            0x23 => {
                self.registers.e = self.sla(self.registers.e);
            }
            0x24 => {
                self.registers.h = self.sla(self.registers.h);
            }
            0x25 => {
                self.registers.l = self.sla(self.registers.l);
            }
            0x26 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.sla(value);
                self.write_byte(address, new_value);
            }
            0x27 => {
                self.registers.a = self.sla(self.registers.a);
            }
            0x28 => {
                self.registers.b = self.sra(self.registers.b);
            }
            0x29 => {
                self.registers.c = self.sra(self.registers.c);
            }
            0x2a => {
                self.registers.d = self.sra(self.registers.d);
            }
            0x2b => {
                self.registers.e = self.sra(self.registers.e);
            }
            0x2c => {
                self.registers.h = self.sra(self.registers.h);
            }
            0x2d => {
                self.registers.l = self.sra(self.registers.l);
            }
            0x2e => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.sra(value);
                self.write_byte(address, new_value);
            }
            0x2f => {
                self.registers.a = self.sra(self.registers.a);
            }
            0x30 => {
                self.registers.b = self.swap(self.registers.b);
            }
            0x31 => {
                self.registers.c = self.swap(self.registers.c);
            }
            0x32 => {
                self.registers.d = self.swap(self.registers.d);
            }
            0x33 => {
                self.registers.e = self.swap(self.registers.e);
            }
            0x34 => {
                self.registers.h = self.swap(self.registers.h);
            }
            0x35 => {
                self.registers.l = self.swap(self.registers.l);
            }
            0x36 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.swap(value);
                self.write_byte(address, new_value);
            }
            0x37 => {
                self.registers.a = self.swap(self.registers.a);
            }
            0x38 => {
                self.registers.b = self.srl(self.registers.b);
            }
            0x39 => {
                self.registers.c = self.srl(self.registers.c);
            }
            0x3a => {
                self.registers.d = self.srl(self.registers.d);
            }
            0x3b => {
                self.registers.e = self.srl(self.registers.e);
            }
            0x3c => {
                self.registers.h = self.srl(self.registers.h);
            }
            0x3d => {
                self.registers.l = self.srl(self.registers.l);
            }
            0x3e => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.srl(value);
                self.write_byte(address, new_value);
            }
            0x3f => {
                self.registers.a = self.srl(self.registers.a);
            }
            0x40 => {
                self.bit(0, self.registers.b);
            }
            0x41 => {
                self.bit(0, self.registers.c);
            }
            0x42 => {
                self.bit(0, self.registers.d);
            }
            0x43 => {
                self.bit(0, self.registers.e);
            }
            0x44 => {
                self.bit(0, self.registers.h);
            }
            0x45 => {
                self.bit(0, self.registers.l);
            }
            0x46 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                self.bit(0, value);
            }
            0x47 => {
                self.bit(0, self.registers.a);
            }
            0x48 => {
                self.bit(1, self.registers.b);
            }
            0x49 => {
                self.bit(1, self.registers.c);
            }
            0x4a => {
                self.bit(1, self.registers.d);
            }
            0x4b => {
                self.bit(1, self.registers.e);
            }
            0x4c => {
                self.bit(1, self.registers.h);
            }
            0x4d => {
                self.bit(1, self.registers.l);
            }
            0x4e => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                self.bit(1, value);
            }
            0x4f => {
                self.bit(1, self.registers.a);
            }
            0x50 => {
                self.bit(2, self.registers.b);
            }
            0x51 => {
                self.bit(2, self.registers.c);
            }
            0x52 => {
                self.bit(2, self.registers.d);
            }
            0x53 => {
                self.bit(2, self.registers.e);
            }
            0x54 => {
                self.bit(2, self.registers.h);
            }
            0x55 => {
                self.bit(2, self.registers.l);
            }
            0x56 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                self.bit(2, value);
            }
            0x57 => {
                self.bit(2, self.registers.a);
            }
            0x58 => {
                self.bit(3, self.registers.b);
            }
            0x59 => {
                self.bit(3, self.registers.c);
            }
            0x5a => {
                self.bit(3, self.registers.d);
            }
            0x5b => {
                self.bit(3, self.registers.e);
            }
            0x5c => {
                self.bit(3, self.registers.h);
            }
            0x5d => {
                self.bit(3, self.registers.l);
            }
            0x5e => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                self.bit(3, value);
            }
            0x5f => {
                self.bit(3, self.registers.a);
            }
            0x60 => {
                self.bit(4, self.registers.b);
            }
            0x61 => {
                self.bit(4, self.registers.c);
            }
            0x62 => {
                self.bit(4, self.registers.d);
            }
            0x63 => {
                self.bit(4, self.registers.e);
            }
            0x64 => {
                self.bit(4, self.registers.h);
            }
            0x65 => {
                self.bit(4, self.registers.l);
            }
            0x66 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                self.bit(4, value);
            }
            0x67 => {
                self.bit(4, self.registers.a);
            }
            0x68 => {
                self.bit(5, self.registers.b);
            }
            0x69 => {
                self.bit(5, self.registers.c);
            }
            0x6a => {
                self.bit(5, self.registers.d);
            }
            0x6b => {
                self.bit(5, self.registers.e);
            }
            0x6c => {
                self.bit(5, self.registers.h);
            }
            0x6d => {
                self.bit(5, self.registers.l);
            }
            0x6e => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                self.bit(5, value);
            }
            0x6f => {
                self.bit(5, self.registers.a);
            }
            0x70 => {
                self.bit(6, self.registers.b);
            }
            0x71 => {
                self.bit(6, self.registers.c);
            }
            0x72 => {
                self.bit(6, self.registers.d);
            }
            0x73 => {
                self.bit(6, self.registers.e);
            }
            0x74 => {
                self.bit(6, self.registers.h);
            }
            0x75 => {
                self.bit(6, self.registers.l);
            }
            0x76 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                self.bit(6, value);
            }
            0x77 => {
                self.bit(6, self.registers.a);
            }
            0x78 => {
                self.bit(7, self.registers.b);
            }
            0x79 => {
                self.bit(7, self.registers.c);
            }
            0x7a => {
                self.bit(7, self.registers.d);
            }
            0x7b => {
                self.bit(7, self.registers.e);
            }
            0x7c => {
                self.bit(7, self.registers.h);
            }
            0x7d => {
                self.bit(7, self.registers.l);
            }
            0x7e => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                self.bit(7, value);
            }
            0x7f => {
                self.bit(7, self.registers.a);
            }
            0x80 => {
                self.registers.b = self.res(0, self.registers.b);
            }
            0x81 => {
                self.registers.c = self.res(0, self.registers.c);
            }
            0x82 => {
                self.registers.d = self.res(0, self.registers.d);
            }
            0x83 => {
                self.registers.e = self.res(0, self.registers.e);
            }
            0x84 => {
                self.registers.h = self.res(0, self.registers.h);
            }
            0x85 => {
                self.registers.l = self.res(0, self.registers.l);
            }
            0x86 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.res(0, value);
                self.write_byte(address, new_value);
            }
            0x87 => {
                self.registers.a = self.res(0, self.registers.a);
            }
            0x88 => {
                self.registers.b = self.res(1, self.registers.b);
            }
            0x89 => {
                self.registers.c = self.res(1, self.registers.c);
            }
            0x8a => {
                self.registers.d = self.res(1, self.registers.d);
            }
            0x8b => {
                self.registers.e = self.res(1, self.registers.e);
            }
            0x8c => {
                self.registers.h = self.res(1, self.registers.h);
            }
            0x8d => {
                self.registers.l = self.res(1, self.registers.l);
            }
            0x8e => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.res(1, value);
                self.write_byte(address, new_value);
            }
            0x8f => {
                self.registers.a = self.res(1, self.registers.a);
            }
            0x90 => {
                self.registers.b = self.res(2, self.registers.b);
            }
            0x91 => {
                self.registers.c = self.res(2, self.registers.c);
            }
            0x92 => {
                self.registers.d = self.res(2, self.registers.d);
            }
            0x93 => {
                self.registers.e = self.res(2, self.registers.e);
            }
            0x94 => {
                self.registers.h = self.res(2, self.registers.h);
            }
            0x95 => {
                self.registers.l = self.res(2, self.registers.l);
            }
            0x96 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.res(2, value);
                self.write_byte(address, new_value);
            }
            0x97 => {
                self.registers.a = self.res(2, self.registers.a);
            }
            0x98 => {
                self.registers.b = self.res(3, self.registers.b);
            }
            0x99 => {
                self.registers.c = self.res(3, self.registers.c);
            }
            0x9a => {
                self.registers.d = self.res(3, self.registers.d);
            }
            0x9b => {
                self.registers.e = self.res(3, self.registers.e);
            }
            0x9c => {
                self.registers.h = self.res(3, self.registers.h);
            }
            0x9d => {
                self.registers.l = self.res(3, self.registers.l);
            }
            0x9e => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.res(3, value);
                self.write_byte(address, new_value);
            }
            0x9f => {
                self.registers.a = self.res(3, self.registers.a);
            }
            0xa0 => {
                self.registers.b = self.res(4, self.registers.b);
            }
            0xa1 => {
                self.registers.c = self.res(4, self.registers.c);
            }
            0xa2 => {
                self.registers.d = self.res(4, self.registers.d);
            }
            0xa3 => {
                self.registers.e = self.res(4, self.registers.e);
            }
            0xa4 => {
                self.registers.h = self.res(4, self.registers.h);
            }
            0xa5 => {
                self.registers.l = self.res(4, self.registers.l);
            }
            0xa6 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.res(4, value);
                self.write_byte(address, new_value);
            }
            0xa7 => {
                self.registers.a = self.res(4, self.registers.a);
            }
            0xa8 => {
                self.registers.b = self.res(5, self.registers.b);
            }
            0xa9 => {
                self.registers.c = self.res(5, self.registers.c);
            }
            0xaa => {
                self.registers.d = self.res(5, self.registers.d);
            }
            0xab => {
                self.registers.e = self.res(5, self.registers.e);
            }
            0xac => {
                self.registers.h = self.res(5, self.registers.h);
            }
            0xad => {
                self.registers.l = self.res(5, self.registers.l);
            }
            0xae => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.res(5, value);
                self.write_byte(address, new_value);
            }
            0xaf => {
                self.registers.a = self.res(5, self.registers.a);
            }
            0xb0 => {
                self.registers.b = self.res(6, self.registers.b);
            }
            0xb1 => {
                self.registers.c = self.res(6, self.registers.c);
            }
            0xb2 => {
                self.registers.d = self.res(6, self.registers.d);
            }
            0xb3 => {
                self.registers.e = self.res(6, self.registers.e);
            }
            0xb4 => {
                self.registers.h = self.res(6, self.registers.h);
            }
            0xb5 => {
                self.registers.l = self.res(6, self.registers.l);
            }
            0xb6 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.res(6, value);
                self.write_byte(address, new_value);
            }
            0xb7 => {
                self.registers.a = self.res(6, self.registers.a);
            }
            0xb8 => {
                self.registers.b = self.res(7, self.registers.b);
            }
            0xb9 => {
                self.registers.c = self.res(7, self.registers.c);
            }
            0xba => {
                self.registers.d = self.res(7, self.registers.d);
            }
            0xbb => {
                self.registers.e = self.res(7, self.registers.e);
            }
            0xbc => {
                self.registers.h = self.res(7, self.registers.h);
            }
            0xbd => {
                self.registers.l = self.res(7, self.registers.l);
            }
            0xbe => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.res(7, value);
                self.write_byte(address, new_value);
            }
            0xbf => {
                self.registers.a = self.res(7, self.registers.a);
            }
            0xc0 => {
                self.registers.b = self.set(0, self.registers.b);
            }
            0xc1 => {
                self.registers.c = self.set(0, self.registers.c);
            }
            0xc2 => {
                self.registers.d = self.set(0, self.registers.d);
            }
            0xc3 => {
                self.registers.e = self.set(0, self.registers.e);
            }
            0xc4 => {
                self.registers.h = self.set(0, self.registers.h);
            }
            0xc5 => {
                self.registers.l = self.set(0, self.registers.l);
            }
            0xc6 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.set(0, value);
                self.write_byte(address, new_value);
            }
            0xc7 => {
                self.registers.a = self.set(0, self.registers.a);
            }
            0xc8 => {
                self.registers.b = self.set(1, self.registers.b);
            }
            0xc9 => {
                self.registers.c = self.set(1, self.registers.c);
            }
            0xca => {
                self.registers.d = self.set(1, self.registers.d);
            }
            0xcb => {
                self.registers.e = self.set(1, self.registers.e);
            }
            0xcc => {
                self.registers.h = self.set(1, self.registers.h);
            }
            0xcd => {
                self.registers.l = self.set(1, self.registers.l);
            }
            0xce => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.set(1, value);
                self.write_byte(address, new_value);
            }
            0xcf => {
                self.registers.a = self.set(1, self.registers.a);
            }
            0xd0 => {
                self.registers.b = self.set(2, self.registers.b);
            }
            0xd1 => {
                self.registers.c = self.set(2, self.registers.c);
            }
            0xd2 => {
                self.registers.d = self.set(2, self.registers.d);
            }
            0xd3 => {
                self.registers.e = self.set(2, self.registers.e);
            }
            0xd4 => {
                self.registers.h = self.set(2, self.registers.h);
            }
            0xd5 => {
                self.registers.l = self.set(2, self.registers.l);
            }
            0xd6 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.set(2, value);
                self.write_byte(address, new_value);
            }
            0xd7 => {
                self.registers.a = self.set(2, self.registers.a);
            }
            0xd8 => {
                self.registers.b = self.set(3, self.registers.b);
            }
            0xd9 => {
                self.registers.c = self.set(3, self.registers.c);
            }
            0xda => {
                self.registers.d = self.set(3, self.registers.d);
            }
            0xdb => {
                self.registers.e = self.set(3, self.registers.e);
            }
            0xdc => {
                self.registers.h = self.set(3, self.registers.h);
            }
            0xdd => {
                self.registers.l = self.set(3, self.registers.l);
            }
            0xde => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.set(3, value);
                self.write_byte(address, new_value);
            }
            0xdf => {
                self.registers.a = self.set(3, self.registers.a);
            }
            0xe0 => {
                self.registers.b = self.set(4, self.registers.b);
            }
            0xe1 => {
                self.registers.c = self.set(4, self.registers.c);
            }
            0xe2 => {
                self.registers.d = self.set(4, self.registers.d);
            }
            0xe3 => {
                self.registers.e = self.set(4, self.registers.e);
            }
            0xe4 => {
                self.registers.h = self.set(4, self.registers.h);
            }
            0xe5 => {
                self.registers.l = self.set(4, self.registers.l);
            }
            0xe6 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.set(4, value);
                self.write_byte(address, new_value);
            }
            0xe7 => {
                self.registers.a = self.set(4, self.registers.a);
            }
            0xe8 => {
                self.registers.b = self.set(5, self.registers.b);
            }
            0xe9 => {
                self.registers.c = self.set(5, self.registers.c);
            }
            0xea => {
                self.registers.d = self.set(5, self.registers.d);
            }
            0xeb => {
                self.registers.e = self.set(5, self.registers.e);
            }
            0xec => {
                self.registers.h = self.set(5, self.registers.h);
            }
            0xed => {
                self.registers.l = self.set(5, self.registers.l);
            }
            0xee => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.set(5, value);
                self.write_byte(address, new_value);
            }
            0xef => {
                self.registers.a = self.set(5, self.registers.a);
            }
            0xf0 => {
                self.registers.b = self.set(6, self.registers.b);
            }
            0xf1 => {
                self.registers.c = self.set(6, self.registers.c);
            }
            0xf2 => {
                self.registers.d = self.set(6, self.registers.d);
            }
            0xf3 => {
                self.registers.e = self.set(6, self.registers.e);
            }
            0xf4 => {
                self.registers.h = self.set(6, self.registers.h);
            }
            0xf5 => {
                self.registers.l = self.set(6, self.registers.l);
            }
            0xf6 => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.set(6, value);
                self.write_byte(address, new_value);
            }
            0xf7 => {
                self.registers.a = self.set(6, self.registers.a);
            }
            0xf8 => {
                self.registers.b = self.set(7, self.registers.b);
            }
            0xf9 => {
                self.registers.c = self.set(7, self.registers.c);
            }
            0xfa => {
                self.registers.d = self.set(7, self.registers.d);
            }
            0xfb => {
                self.registers.e = self.set(7, self.registers.e);
            }
            0xfc => {
                self.registers.h = self.set(7, self.registers.h);
            }
            0xfd => {
                self.registers.l = self.set(7, self.registers.l);
            }
            0xfe => {
                let address = self.registers.get_hl();
                let value = self.read_address(address);
                let new_value = self.set(7, value);
                self.write_byte(address, new_value);
            }
            0xff => {
                self.registers.a = self.set(7, self.registers.a);
            }
            _ => unsafe {
                PRINT_DEBUG.save_last_lines();
                println!("Unknown prefixed instruction: {:x}\n", byte);
                panic!("OOOOO putain c'est la merde")
            }
        }
    }

    pub fn check_interrupts(&mut self) {
        if self.halted && self.bus.interrupt_pending() {
            self.halted = false;
        }
        if self.ime && self.bus.interrupt_pending() {
            self.handle_interrupt();
        }
    }

    fn handle_interrupt(&mut self) {
        // println!("Handling interrupt");
        let i_enable = self.read_address(0xFFFF);
        let mut if_register_trigger = self.read_address(0xFF0F);
        self.ime = false;
        self.halted = false;

        for i in 0..=4 {
            if i_enable & if_register_trigger & (0x01 << i) == (0x01 << i) {
                if_register_trigger = if_register_trigger & !(0x01 << i);
                self.write_byte(0xFF0F, if_register_trigger);

                self.push(self.pc);

                self.pc = 0x0040 + (0x0008 * i);
                break;
            }
        }
    }

    pub fn adv_cycles(self: &mut Self, cycles: usize) {
        self.bus.adv_cycles(cycles);
    }

    // ??????????????????????????????????????
    // ??????????????????????????????????????
    // ??????????????????????????????????????
    pub fn internal_cycle(self: &mut Self) {
        self.adv_cycles(4);
        // self.curr_cycles += 4;
    }
    // ??????????????????????????????????????
    // ??????????????????????????????????????
    // ??????????????????????????????????????

    fn read_address(self: &mut Self, address: u16) -> u8 {
        let byte = self.bus.read_byte(address);
        self.adv_cycles(4);
        // self.curr_cycles += 4;
        return byte;
    }

    fn read_next_word(&mut self) -> u16 {
        let least_significant_byte = self.read_address(self.pc) as u16;
        self.pc = self.pc.wrapping_add(1);
        let most_significant_byte = self.read_address(self.pc) as u16;
        self.pc = self.pc.wrapping_add(1);
        (most_significant_byte << 8) | least_significant_byte
    }

    pub(crate) fn read_pc(&mut self) -> u8 {
        let byte = self.read_address(self.pc);
        self.pc = self.pc.wrapping_add(1);
        byte
    }

    fn write_byte(self: &mut Self, addr: u16, data: u8) {
        self.bus.write_byte(addr, data);
        self.adv_cycles(4);
        // self.curr_cycles += 4;
    }

    fn write_word(self: &mut Self, addr: u16, data: u16) {
        self.bus.write_word(addr, data);
        self.adv_cycles(8);
        // self.curr_cycles += 8;
    }

    pub fn set_keypad(self: &mut Self, event_pump: sdl2::EventPump) {
        self.bus.set_keypad(event_pump);
    }

    pub fn set_mbc(self: &mut Self, cart_mbc: MbcDefault) {
        self.bus.set_mbc(cart_mbc);
    }

    pub fn update_input(self: &mut Self) -> bool {
        return self.bus.update_input();
    }

    pub(crate) fn push(&mut self, value: u16) {
        self.sp = self.sp.wrapping_sub(1);
        self.write_byte(self.sp, ((value & 0xFF00) >> 8) as u8);

        self.sp = self.sp.wrapping_sub(1);
        self.write_byte(self.sp, (value & 0xFF) as u8);
    }

    pub(crate) fn pop(&mut self) -> u16 {
        let lsb = self.read_address(self.sp) as u16;
        self.sp = self.sp.wrapping_add(1);

        let msb = self.read_address(self.sp) as u16;
        self.sp = self.sp.wrapping_add(1);

        (msb << 8) | lsb
    }

    pub fn add(&mut self, value: u8) -> u8 {
        let (value, did_overflow) = self.registers.a.overflowing_add(value);
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.carry = did_overflow;
        self.registers.f.half_carry = (self.registers.a & 0xF) + (value & 0xF) > 0xF;
        value
    }

    pub fn add_16(&mut self, value: u16) -> u16 {
        let (value, did_overflow) = self.registers.get_hl().overflowing_add(value);
        self.registers.f.subtract = false;
        self.registers.f.carry = did_overflow;
        self.registers.f.half_carry = (self.registers.get_hl() & 0xFFF) + (value & 0xFFF) > 0xFFF;
        value
    }

    pub fn add_with_carry(&mut self, value: u8) -> u8 {
        let carry = if self.registers.f.carry { 1 } else { 0 };
        let (value, did_overflow) = self.registers.a.overflowing_add(value + carry);
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.carry = did_overflow;
        self.registers.f.half_carry = (self.registers.a & 0xF) + (value & 0xF) + carry > 0xF;
        value
    }

    pub fn sub(&mut self, value: u8) -> u8 {
        let (value, did_overflow) = self.registers.a.overflowing_sub(value);
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = true;
        self.registers.f.carry = did_overflow;
        self.registers.f.half_carry = (self.registers.a & 0xF) < (value & 0xF);
        value
    }

    pub fn sub_with_carry(&mut self, value: u8) -> u8 {
        let carry = if self.registers.f.carry { 1 } else { 0 };
        let (value, did_overflow) = self.registers.a.overflowing_sub(value + carry);
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = true;
        self.registers.f.carry = did_overflow;
        self.registers.f.half_carry = (self.registers.a & 0xF) < (value & 0xF) + carry;
        value
    }

    pub fn cp(&mut self, value: u8) {
        let (value, did_overflow) = self.registers.a.overflowing_sub(value);
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = true;
        self.registers.f.carry = did_overflow;
        self.registers.f.half_carry = (self.registers.a & 0xF) < (value & 0xF);
    }

    pub fn and(&mut self, value: u8) {
        let value = self.registers.a & value;
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = true;
        self.registers.f.carry = false;
        self.registers.a = value;
    }

    pub fn or(&mut self, value: u8) {
        let value = self.registers.a | value;
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = false;
        self.registers.f.carry = false;
        self.registers.a = value;
    }

    pub fn xor(&mut self, value: u8) {
        let value = self.registers.a ^ value;
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = false;
        self.registers.f.carry = false;
        self.registers.a = value;
    }

    pub fn jump(&mut self, should_jump: bool) {
        let least_significant_byte = self.read_pc() as u16;
        let most_significant_byte = self.read_pc() as u16;
        if should_jump {
            self.internal_cycle();
            self.pc = (most_significant_byte << 8) | least_significant_byte;
        }
        unsafe {
            if PRINT_DEBUG.global_index == 3859177 {
                PRINT_DEBUG.add_data(format!("Eval cond: {}, r16: {:#04X} -> {}\n", should_jump, (most_significant_byte << 8) | least_significant_byte, self.pc));
            }
        }
    }

    fn jump_relative(&mut self, should_jump: bool) {
        let offset = self.read_pc() as i8 as i16; // double cast to convert to signed
        if should_jump {
            self.internal_cycle();
            self.pc = self.pc.wrapping_add_signed(offset);
        }
        unsafe {
            // if PRINT_DEBUG.global_index == 98829 {
            //     PRINT_DEBUG.add_data(format!("Eval cond: {}, r8: {:#04X} -> {}\n", should_jump, offset, self.pc));
            // }
        }
    }

    fn call(&mut self, should_jump: bool) {
        let val = self.read_next_word();
        if should_jump {
            self.internal_cycle();
            self.push(self.pc);
            // unsafe {
            //     PRINT_DEBUG.add_data(format!("Calling {:04X}\n", val));
            // }
            self.pc = val;
        }
    }

    fn return_(&mut self, should_jump: bool) {
        self.internal_cycle();
        if should_jump {
            self.pc = self.pop();
            self.internal_cycle();
        }
    }

    fn rlc(&mut self, value: u8) -> u8 {
        let did_overflow = value & 0x80 == 0x80;
        let value = (value << 1) | (if did_overflow { 1 } else { 0 });
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = false;
        self.registers.f.carry = did_overflow;
        value
    }

    fn rl(&mut self, value: u8) -> u8 {
        let did_overflow = value & 0x80 == 0x80;
        let value = (value << 1) | (if self.registers.f.carry { 1 } else { 0 });
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = false;
        self.registers.f.carry = did_overflow;
        value
    }

    fn rrc(&mut self, value: u8) -> u8 {
        let did_overflow = value & 0x01 == 0x01;
        let value = (value >> 1) | (if did_overflow { 0x80 } else { 0 });
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = false;
        self.registers.f.carry = did_overflow;
        value
    }

    fn rr(&mut self, value: u8) -> u8 {
        let did_overflow = value & 0x01 == 0x01;
        let value = (value >> 1) | (if self.registers.f.carry { 0x80 } else { 0 });
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = false;
        self.registers.f.carry = did_overflow;
        value
    }

    fn sla(&mut self, value: u8) -> u8 {
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = false;
        self.registers.f.carry = (value & 0x80) != 0;
        value << 1 // ICI ICI
    }

    fn sra(&mut self, value: u8) -> u8 {
        let did_overflow = value & 0x01 == 0x01;
        let value = (value >> 1) | (value & 0x80);
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = false;
        self.registers.f.carry = did_overflow;
        value
    }

    fn swap(&mut self, value: u8) -> u8 {
        let value = ((value & 0xF) << 4) | ((value & 0xF0) >> 4);
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = false;
        self.registers.f.carry = false;
        value
    }

    fn srl(&mut self, value: u8) -> u8 {
        let did_overflow = value & 0x01 == 0x01;
        let value = value >> 1;
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = false;
        self.registers.f.carry = did_overflow;
        value
    }

    fn bit(&mut self, bit: u8, value: u8) {
        self.registers.f.zero = (value & (1 << bit)) == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = true;
    }

    fn res(&mut self, bit: u8, value: u8) -> u8 {
        value & !(1 << bit)
    }

    fn set(&mut self, bit: u8, value: u8) -> u8 {
        value | (1 << bit)
    }

    fn print_debug(byte: u8) -> String {
        match byte {
            0x00 => "NOP".to_string(), 0x01 => "LD BC, d16".to_string(), 0x02 => "LD (BC, A".to_string(), 0x03 => "INC BC".to_string(), 0x04 => "INC B".to_string(), 0x05 => "DEC B".to_string(), 0x06 => "LD B, d8".to_string(), 0x07 => "RLCA".to_string(), 0x08 => "LD (a16, SP".to_string(), 0x09 => "ADD HL, BC".to_string(), 0x0A => "LD A, (BC)".to_string(), 0x0B => "DEC BC".to_string(), 0x0C => "INC C".to_string(), 0x0D => "DEC C".to_string(), 0x0E => "LD C, d8".to_string(), 0x0F => "RRCA".to_string(),
            0x10 => "STOP".to_string(), 0x11 => "LD DE, d16".to_string(), 0x12 => "LD (DE, A".to_string(), 0x13 => "INC DE".to_string(), 0x14 => "INC D".to_string(), 0x15 => "DEC D".to_string(), 0x16 => "LD D, d8".to_string(), 0x17 => "RLA".to_string(), 0x18 => "JR r8".to_string(), 0x19 => "ADD HL, DE".to_string(), 0x1A => "LD A, (DE)".to_string(), 0x1B => "DEC DE".to_string(), 0x1C => "INC E".to_string(), 0x1D => "DEC E".to_string(), 0x1E => "LD E, d8".to_string(), 0x1F => "RRA".to_string(),
            0x20 => "JR NZ, r8".to_string(), 0x21 => "LD HL, d16".to_string(), 0x22 => "LDI (HL, A".to_string(), 0x23 => "INC HL".to_string(), 0x24 => "INC H".to_string(), 0x25 => "DEC H".to_string(), 0x26 => "LD H, d8".to_string(), 0x27 => "DAA".to_string(), 0x28 => "JR Z, r8".to_string(), 0x29 => "ADD HL, HL".to_string(), 0x2A => "LDI A, (HL)".to_string(), 0x2B => "DEC HL".to_string(), 0x2C => "INC L".to_string(), 0x2D => "DEC L".to_string(), 0x2E => "LD L, d8".to_string(), 0x2F => "CPL".to_string(),
            0x30 => "JR NC, r8".to_string(), 0x31 => "LD SP, d16".to_string(), 0x32 => "LDD (HL, A".to_string(), 0x33 => "INC SP".to_string(), 0x34 => "INC (HL)".to_string(), 0x35 => "DEC (HL)".to_string(), 0x36 => "LD (HL, d8".to_string(), 0x37 => "SCF".to_string(), 0x38 => "JR C, r8".to_string(), 0x39 => "ADD HL, SP".to_string(), 0x3A => "LDD A, (HL)".to_string(), 0x3B => "DEC SP".to_string(), 0x3C => "INC A".to_string(), 0x3D => "DEC A".to_string(), 0x3E => "LD A, d8".to_string(), 0x3F => "CCF".to_string(),
            0x40 => "LD B, B".to_string(), 0x41 => "LD B, C".to_string(), 0x42 => "LD B, D".to_string(), 0x43 => "LD B, E".to_string(), 0x44 => "LD B, H".to_string(), 0x45 => "LD B, L".to_string(), 0x46 => "LD B, (HL)".to_string(), 0x47 => "LD B, A".to_string(), 0x48 => "LD C, B".to_string(), 0x49 => "LD C, C".to_string(), 0x4A => "LD C, D".to_string(), 0x4B => "LD C, E".to_string(), 0x4C => "LD C, H".to_string(), 0x4D => "LD C, L".to_string(), 0x4E => "LD C, (HL)".to_string(), 0x4F => "LD C, A".to_string(),
            0x50 => "LD D, B".to_string(), 0x51 => "LD D, C".to_string(), 0x52 => "LD D, D".to_string(), 0x53 => "LD D, E".to_string(), 0x54 => "LD D, H".to_string(), 0x55 => "LD D, L".to_string(), 0x56 => "LD D, (HL)".to_string(), 0x57 => "LD D, A".to_string(), 0x58 => "LD E, B".to_string(), 0x59 => "LD E, C".to_string(), 0x5A => "LD E, D".to_string(), 0x5B => "LD E, E".to_string(), 0x5C => "LD E, H".to_string(), 0x5D => "LD E, L".to_string(), 0x5E => "LD E, (HL)".to_string(), 0x5F => "LD E, A".to_string(),
            0x60 => "LD H, B".to_string(), 0x61 => "LD H, C".to_string(), 0x62 => "LD H, D".to_string(), 0x63 => "LD H, E".to_string(), 0x64 => "LD H, H".to_string(), 0x65 => "LD H, L".to_string(), 0x66 => "LD H, (HL)".to_string(), 0x67 => "LD H, A".to_string(), 0x68 => "LD L, B".to_string(), 0x69 => "LD L, C".to_string(), 0x6A => "LD L, D".to_string(), 0x6B => "LD L, E".to_string(), 0x6C => "LD L, H".to_string(), 0x6D => "LD L, L".to_string(), 0x6E => "LD L, (HL)".to_string(), 0x6F => "LD L, A".to_string(),
            0x70 => "LD (HL, B".to_string(), 0x71 => "LD (HL, C".to_string(), 0x72 => "LD (HL, D".to_string(), 0x73 => "LD (HL, E".to_string(), 0x74 => "LD (HL, H".to_string(), 0x75 => "LD (HL, L".to_string(), 0x76 => "HALT".to_string(), 0x77 => "LD (HL, A".to_string(), 0x78 => "LD A, B".to_string(), 0x79 => "LD A, C".to_string(), 0x7A => "LD A, D".to_string(), 0x7B => "LD A, E".to_string(), 0x7C => "LD A, H".to_string(), 0x7D => "LD A, L".to_string(), 0x7E => "LD A, (HL)".to_string(), 0x7F => "LD A, A".to_string(),
            0x80 => "ADD A, B".to_string(), 0x81 => "ADD A, C".to_string(), 0x82 => "ADD A, D".to_string(), 0x83 => "ADD A, E".to_string(), 0x84 => "ADD A, H".to_string(), 0x85 => "ADD A, L".to_string(), 0x86 => "ADD A, (HL)".to_string(), 0x87 => "ADD A, A".to_string(), 0x88 => "ADC A, B".to_string(), 0x89 => "ADC A, C".to_string(), 0x8A => "ADC A, D".to_string(), 0x8B => "ADC A, E".to_string(), 0x8C => "ADC A, H".to_string(), 0x8D => "ADC A, L".to_string(), 0x8E => "ADC A, (HL)".to_string(), 0x8F => "ADC A, A".to_string(),
            0x90 => "SUB B".to_string(), 0x91 => "SUB C".to_string(), 0x92 => "SUB D".to_string(), 0x93 => "SUB E".to_string(), 0x94 => "SUB H".to_string(), 0x95 => "SUB L".to_string(), 0x96 => "SUB (HL)".to_string(), 0x97 => "SUB A".to_string(), 0x98 => "SBC A, B".to_string(), 0x99 => "SBC A, C".to_string(), 0x9A => "SBC A, D".to_string(), 0x9B => "SBC A, E".to_string(), 0x9C => "SBC A, H".to_string(), 0x9D => "SBC A, L".to_string(), 0x9E => "SBC A, (HL)".to_string(), 0x9F => "SBC A, A".to_string(),
            0xA0 => "AND B".to_string(), 0xA1 => "AND C".to_string(), 0xA2 => "AND D".to_string(), 0xA3 => "AND E".to_string(), 0xA4 => "AND H".to_string(), 0xA5 => "AND L".to_string(), 0xA6 => "AND (HL)".to_string(), 0xA7 => "AND A".to_string(), 0xA8 => "XOR B".to_string(), 0xA9 => "XOR C".to_string(), 0xAA => "XOR D".to_string(), 0xAB => "XOR E".to_string(), 0xAC => "XOR H".to_string(), 0xAD => "XOR L".to_string(), 0xAE => "XOR (HL)".to_string(), 0xAF => "XOR A".to_string(),
            0xB0 => "OR B".to_string(), 0xB1 => "OR C".to_string(), 0xB2 => "OR D".to_string(), 0xB3 => "OR E".to_string(), 0xB4 => "OR H".to_string(), 0xB5 => "OR L".to_string(), 0xB6 => "OR (HL)".to_string(), 0xB7 => "OR A".to_string(), 0xB8 => "CP B".to_string(), 0xB9 => "CP C".to_string(), 0xBA => "CP D".to_string(), 0xBB => "CP E".to_string(), 0xBC => "CP H".to_string(), 0xBD => "CP L".to_string(), 0xBE => "CP (HL)".to_string(), 0xBF => "CP A".to_string(),
            0xC0 => "RET NZ".to_string(), 0xC1 => "POP BC".to_string(), 0xC2 => "JP NZ, a16".to_string(), 0xC3 => "JP a16".to_string(), 0xC4 => "CALL NZ, a16".to_string(), 0xC5 => "PUSH BC".to_string(), 0xC6 => "ADD A, d8".to_string(), 0xC7 => "RST 00H".to_string(), 0xC8 => "RET Z".to_string(), 0xC9 => "RET".to_string(), 0xCA => "JP Z, a16".to_string(), 0xCC => "CALL Z, a16".to_string(), 0xCD => "CALL a16".to_string(), 0xCE => "ADC A, d8".to_string(), 0xCF => "RST 08H".to_string(),
            0xD0 => "RET NC".to_string(), 0xD1 => "POP DE".to_string(), 0xD2 => "JP NC, a16".to_string(), 0xD4 => "CALL NC, a16".to_string(), 0xD5 => "PUSH DE".to_string(), 0xD6 => "SUB d8".to_string(), 0xD7 => "RST 10H".to_string(), 0xD8 => "RET C".to_string(), 0xD9 => "RETI".to_string(), 0xDA => "JP C, a16".to_string(), 0xDC => "CALL C, a16".to_string(), 0xDE => "SBC A, d8".to_string(), 0xDF => "RST 18H".to_string(),
            0xE0 => "LDH (a8, A".to_string(), 0xE1 => "POP HL".to_string(), 0xE2 => "LD (C, A".to_string(), 0xE5 => "PUSH HL".to_string(), 0xE6 => "AND d8".to_string(), 0xE7 => "RST 20H".to_string(), 0xE8 => "ADD SP, r8".to_string(), 0xE9 => "JP (HL)".to_string(), 0xEA => "LD (a16, A".to_string(), 0xEE => "XOR d8".to_string(), 0xEF => "RST 28H".to_string(),
            0xF0 => "LDH A, (a8)".to_string(), 0xF1 => "POP AF".to_string(), 0xF2 => "LD A, (C)".to_string(), 0xF3 => "DI".to_string(), 0xF5 => "PUSH AF".to_string(), 0xF6 => "OR d8".to_string(), 0xF7 => "RST 30H".to_string(), 0xF8 => "LD HL, SP+r8".to_string(), 0xF9 => "LD SP, HL".to_string(), 0xFA => "LD A, (a16)".to_string(), 0xFB => "EI".to_string(), 0xFE => "CP d8".to_string(), 0xFF => "RST 38H".to_string(),
            _ => "Unknown".to_string(),
        }
    }

    fn print_debug_prefixed(byte: u8) -> String {
        match byte {
            0x00 => "Prefix: RLC B".to_string(), 0x01 => "Prefix: RLC C".to_string(), 0x02 => "Prefix: RLC D".to_string(), 0x03 => "Prefix: RLC E".to_string(), 0x04 => "Prefix: RLC H".to_string(), 0x05 => "Prefix: RLC L".to_string(), 0x06 => "Prefix: RLC (HL)".to_string(), 0x07 => "Prefix: RLC A".to_string(), 0x08 => "Prefix: RRC B".to_string(), 0x09 => "Prefix: RRC C".to_string(), 0x0a => "Prefix: RRC D".to_string(), 0x0b => "Prefix: RRC E".to_string(), 0x0c => "Prefix: RRC H".to_string(), 0x10 => "Prefix: RL B".to_string(), 0x11 => "Prefix: RL C".to_string(), 0x12 => "Prefix: RL D".to_string(),
            0x13 => "Prefix: RL E".to_string(), 0x14 => "Prefix: RL H".to_string(), 0x15 => "Prefix: RL L".to_string(), 0x16 => "Prefix: RL (HL)".to_string(), 0x17 => "Prefix: RL A".to_string(), 0x18 => "Prefix: RR B".to_string(), 0x19 => "Prefix: RR C".to_string(), 0x1a => "Prefix: RR D".to_string(), 0x1b => "Prefix: RR E".to_string(), 0x0d => "Prefix: Prefix: RRC L".to_string(), 0x0e => "Prefix: Prefix: RRC (HL)".to_string(), 0x0f => "Prefix: Prefix: RRC A".to_string(), 0x1c => "Prefix: RR H".to_string(), 0x1d => "Prefix: RR L".to_string(), 0x1e => "Prefix: RR (HL)".to_string(), 0x1f => "Prefix: RR A".to_string(),
            0x20 => "Prefix: SLA B".to_string(), 0x21 => "Prefix: SLA C".to_string(), 0x22 => "Prefix: SLA D".to_string(), 0x23 => "Prefix: SLA E".to_string(), 0x24 => "Prefix: SLA H".to_string(), 0x25 => "Prefix: SLA L".to_string(), 0x26 => "Prefix: SLA (HL)".to_string(), 0x27 => "Prefix: SLA A".to_string(), 0x28 => "Prefix: SRA B".to_string(), 0x29 => "Prefix: SRA C".to_string(), 0x2a => "Prefix: SRA D".to_string(), 0x2b => "Prefix: SRA E".to_string(), 0x2c => "Prefix: SRA H".to_string(), 0x2d => "Prefix: SRA L".to_string(), 0x2e => "Prefix: SRA (HL)".to_string(), 0x2f => "Prefix: SRA A".to_string(),
            0x30 => "Prefix: SWAP B".to_string(), 0x31 => "Prefix: SWAP C".to_string(), 0x32 => "Prefix: SWAP D".to_string(), 0x33 => "Prefix: SWAP E".to_string(), 0x34 => "Prefix: SWAP H".to_string(), 0x35 => "Prefix: SWAP L".to_string(), 0x36 => "Prefix: SWAP (HL)".to_string(), 0x37 => "Prefix: SWAP A".to_string(), 0x38 => "Prefix: SRL B".to_string(), 0x39 => "Prefix: SRL C".to_string(), 0x3a => "Prefix: SRL D".to_string(), 0x3b => "Prefix: SRL E".to_string(), 0x3c => "Prefix: SRL H".to_string(), 0x3d => "Prefix: SRL L".to_string(), 0x3e => "Prefix: SRL (HL)".to_string(), 0x3f => "Prefix: SRL A".to_string(),
            0x40 => "Prefix: BIT 0, B".to_string(), 0x41 => "Prefix: BIT 0, C".to_string(), 0x42 => "Prefix: BIT 0, D".to_string(), 0x43 => "Prefix: BIT 0, E".to_string(), 0x44 => "Prefix: BIT 0, H".to_string(), 0x45 => "Prefix: BIT 0, L".to_string(), 0x46 => "Prefix: BIT 0, (HL)".to_string(), 0x47 => "Prefix: BIT 0, A".to_string(), 0x48 => "Prefix: BIT 1, B".to_string(), 0x49 => "Prefix: BIT 1, C".to_string(), 0x4a => "Prefix: BIT 1, D".to_string(), 0x4b => "Prefix: BIT 1, E".to_string(), 0x4c => "Prefix: BIT 1, H".to_string(), 0x4d => "Prefix: BIT 1, L".to_string(), 0x4e => "Prefix: BIT 1, (HL)".to_string(), 0x4f => "Prefix: BIT 1, A".to_string(),
            0x50 => "Prefix: BIT 2, B".to_string(), 0x51 => "Prefix: BIT 2, C".to_string(), 0x52 => "Prefix: BIT 2, D".to_string(), 0x53 => "Prefix: BIT 2, E".to_string(), 0x54 => "Prefix: BIT 2, H".to_string(), 0x55 => "Prefix: BIT 2, L".to_string(), 0x56 => "Prefix: BIT 2, (HL)".to_string(), 0x57 => "Prefix: BIT 2, A".to_string(), 0x58 => "Prefix: BIT 3, B".to_string(), 0x59 => "Prefix: BIT 3, C".to_string(), 0x5a => "Prefix: BIT 3, D".to_string(), 0x5b => "Prefix: BIT 3, E".to_string(), 0x5c => "Prefix: BIT 3, H".to_string(), 0x5d => "Prefix: BIT 3, L".to_string(), 0x5e => "Prefix: BIT 3, (HL)".to_string(), 0x5f => "Prefix: BIT 3, A".to_string(),
            0x60 => "Prefix: BIT 4, B".to_string(), 0x61 => "Prefix: BIT 4, C".to_string(), 0x62 => "Prefix: BIT 4, D".to_string(), 0x63 => "Prefix: BIT 4, E".to_string(), 0x64 => "Prefix: BIT 4, H".to_string(), 0x65 => "Prefix: BIT 4, L".to_string(), 0x66 => "Prefix: BIT 4, (HL)".to_string(), 0x67 => "Prefix: BIT 4, A".to_string(), 0x68 => "Prefix: BIT 5, B".to_string(), 0x69 => "Prefix: BIT 5, C".to_string(), 0x6a => "Prefix: BIT 5, D".to_string(), 0x6b => "Prefix: BIT 5, E".to_string(), 0x6c => "Prefix: BIT 5, H".to_string(), 0x6d => "Prefix: BIT 5, L".to_string(), 0x6e => "Prefix: BIT 5, (HL)".to_string(), 0x6f => "Prefix: BIT 5, A".to_string(),
            0x70 => "Prefix: BIT 6, B".to_string(), 0x71 => "Prefix: BIT 6, C".to_string(), 0x72 => "Prefix: BIT 6, D".to_string(), 0x73 => "Prefix: BIT 6, E".to_string(), 0x74 => "Prefix: BIT 6, H".to_string(), 0x75 => "Prefix: BIT 6, L".to_string(), 0x76 => "Prefix: BIT 6, (HL)".to_string(), 0x77 => "Prefix: BIT 6, A".to_string(), 0x78 => "Prefix: BIT 7, B".to_string(), 0x79 => "Prefix: BIT 7, C".to_string(), 0x7a => "Prefix: BIT 7, D".to_string(), 0x7b => "Prefix: BIT 7, E".to_string(), 0x7c => "Prefix: BIT 7, H".to_string(), 0x7d => "Prefix: BIT 7, L".to_string(), 0x7e => "Prefix: BIT 7, (HL)".to_string(), 0x7f => "Prefix: BIT 7, A".to_string(),
            0x80 => "Prefix: RES 0, B".to_string(), 0x81 => "Prefix: RES 0, C".to_string(), 0x82 => "Prefix: RES 0, D".to_string(), 0x83 => "Prefix: RES 0, E".to_string(), 0x84 => "Prefix: RES 0, H".to_string(), 0x85 => "Prefix: RES 0, L".to_string(), 0x86 => "Prefix: RES 0, (HL)".to_string(), 0x87 => "Prefix: RES 0, A".to_string(), 0x88 => "Prefix: RES 1, B".to_string(), 0x89 => "Prefix: RES 1, C".to_string(), 0x8a => "Prefix: RES 1, D".to_string(), 0x8b => "Prefix: RES 1, E".to_string(), 0x8c => "Prefix: RES 1, H".to_string(), 0x8d => "Prefix: RES 1, L".to_string(), 0x8e => "Prefix: RES 1, (HL)".to_string(), 0x8f => "Prefix: RES 1, A".to_string(),
            0x90 => "Prefix: RES 2, B".to_string(), 0x91 => "Prefix: RES 2, C".to_string(), 0x92 => "Prefix: RES 2, D".to_string(), 0x93 => "Prefix: RES 2, E".to_string(), 0x94 => "Prefix: RES 2, H".to_string(), 0x95 => "Prefix: RES 2, L".to_string(), 0x96 => "Prefix: RES 2, (HL)".to_string(), 0x97 => "Prefix: RES 2, A".to_string(), 0x98 => "Prefix: RES 3, B".to_string(), 0x99 => "Prefix: RES 3, C".to_string(), 0x9a => "Prefix: RES 3, D".to_string(), 0x9b => "Prefix: RES 3, E".to_string(), 0x9c => "Prefix: RES 3, H".to_string(), 0x9d => "Prefix: RES 3, L".to_string(), 0x9e => "Prefix: RES 3, (HL)".to_string(), 0x9f => "Prefix: RES 3, A".to_string(),
            0xa0 => "Prefix: RES 4, B".to_string(), 0xa1 => "Prefix: RES 4, C".to_string(), 0xa2 => "Prefix: RES 4, D".to_string(), 0xa3 => "Prefix: RES 4, E".to_string(), 0xa4 => "Prefix: RES 4, H".to_string(), 0xa5 => "Prefix: RES 4, L".to_string(), 0xa6 => "Prefix: RES 4, (HL)".to_string(), 0xa7 => "Prefix: RES 4, A".to_string(), 0xa8 => "Prefix: RES 5, B".to_string(), 0xa9 => "Prefix: RES 5, C".to_string(), 0xaa => "Prefix: RES 5, D".to_string(), 0xab => "Prefix: RES 5, E".to_string(), 0xac => "Prefix: RES 5, H".to_string(), 0xad => "Prefix: RES 5, L".to_string(), 0xae => "Prefix: RES 5, (HL)".to_string(), 0xaf => "Prefix: RES 5, A".to_string(),
            0xb0 => "Prefix: RES 6, B".to_string(), 0xb1 => "Prefix: RES 6, C".to_string(), 0xb2 => "Prefix: RES 6, D".to_string(), 0xb3 => "Prefix: RES 6, E".to_string(), 0xb4 => "Prefix: RES 6, H".to_string(), 0xb5 => "Prefix: RES 6, L".to_string(), 0xb6 => "Prefix: RES 6, (HL)".to_string(), 0xb7 => "Prefix: RES 6, A".to_string(), 0xb8 => "Prefix: RES 7, B".to_string(), 0xb9 => "Prefix: RES 7, C".to_string(), 0xba => "Prefix: RES 7, D".to_string(), 0xbb => "Prefix: RES 7, E".to_string(), 0xbc => "Prefix: RES 7, H".to_string(), 0xbd => "Prefix: RES 7, L".to_string(), 0xbe => "Prefix: RES 7, (HL)".to_string(), 0xbf => "Prefix: RES 7, A".to_string(),
            0xc0 => "Prefix: SET 0, B".to_string(), 0xc1 => "Prefix: SET 0, C".to_string(), 0xc2 => "Prefix: SET 0, D".to_string(), 0xc3 => "Prefix: SET 0, E".to_string(), 0xc4 => "Prefix: SET 0, H".to_string(), 0xc5 => "Prefix: SET 0, L".to_string(), 0xc6 => "Prefix: SET 0, (HL)".to_string(), 0xc7 => "Prefix: SET 0, A".to_string(), 0xc8 => "Prefix: SET 1, B".to_string(), 0xc9 => "Prefix: SET 1, C".to_string(), 0xca => "Prefix: SET 1, D".to_string(), 0xcb => "Prefix: SET 1, E".to_string(), 0xcc => "Prefix: SET 1, H".to_string(), 0xcd => "Prefix: SET 1, L".to_string(), 0xce => "Prefix: SET 1, (HL)".to_string(), 0xcf => "Prefix: SET 1, A".to_string(),
            0xd0 => "Prefix: SET 2, B".to_string(), 0xd1 => "Prefix: SET 2, C".to_string(), 0xd2 => "Prefix: SET 2, D".to_string(), 0xd3 => "Prefix: SET 2, E".to_string(), 0xd4 => "Prefix: SET 2, H".to_string(), 0xd5 => "Prefix: SET 2, L".to_string(), 0xd6 => "Prefix: SET 2, (HL)".to_string(), 0xd7 => "Prefix: SET 2, A".to_string(), 0xd8 => "Prefix: SET 3, B".to_string(), 0xd9 => "Prefix: SET 3, C".to_string(), 0xda => "Prefix: SET 3, D".to_string(), 0xdb => "Prefix: SET 3, E".to_string(), 0xdc => "Prefix: SET 3, H".to_string(), 0xdd => "Prefix: SET 3, L".to_string(), 0xde => "Prefix: SET 3, (HL)".to_string(), 0xdf => "Prefix: SET 3, A".to_string(),
            0xe0 => "Prefix: SET 4, B".to_string(), 0xe1 => "Prefix: SET 4, C".to_string(), 0xe2 => "Prefix: SET 4, D".to_string(), 0xe3 => "Prefix: SET 4, E".to_string(), 0xe4 => "Prefix: SET 4, H".to_string(), 0xe5 => "Prefix: SET 4, L".to_string(), 0xe6 => "Prefix: SET 4, (HL)".to_string(), 0xe7 => "Prefix: SET 4, A".to_string(), 0xe8 => "Prefix: SET 5, B".to_string(), 0xe9 => "Prefix: SET 5, C".to_string(), 0xea => "Prefix: SET 5, D".to_string(), 0xeb => "Prefix: SET 5, E".to_string(), 0xec => "Prefix: SET 5, H".to_string(), 0xed => "Prefix: SET 5, L".to_string(), 0xee => "Prefix: SET 5, (HL)".to_string(), 0xef => "Prefix: SET 5, A".to_string(),
            0xf0 => "Prefix: SET 6, B".to_string(), 0xf1 => "Prefix: SET 6, C".to_string(), 0xf2 => "Prefix: SET 6, D".to_string(), 0xf3 => "Prefix: SET 6, E".to_string(), 0xf4 => "Prefix: SET 6, H".to_string(), 0xf5 => "Prefix: SET 6, L".to_string(), 0xf6 => "Prefix: SET 6, (HL)".to_string(), 0xf7 => "Prefix: SET 6, A".to_string(), 0xf8 => "Prefix: SET 7, B".to_string(), 0xf9 => "Prefix: SET 7, C".to_string(), 0xfa => "Prefix: SET 7, D".to_string(), 0xfb => "Prefix: SET 7, E".to_string(), 0xfc => "Prefix: SET 7, H".to_string(), 0xfd => "Prefix: SET 7, L".to_string(), 0xfe => "Prefix: SET 7, (HL)".to_string(), 0xff => "Prefix: SET 7, A".to_string(),
        }
    }

    pub fn update_display(self: &mut Self, texture: &mut Texture) -> bool {
        return self.bus.update_display(texture);
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