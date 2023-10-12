use std::fmt::{Display, Formatter, Result};
use std::ops::Add;

use crate::mods::bus::Bus;
use crate::mods::enum_instructions::{AddType, Arithmetic16Target, ArithmeticTarget, IncDecTarget, Instruction, JumpTest, JumpTestWithHLI, LoadByteSource, LoadByteTarget, LoadType, LoadWordSource, LoadWordTarget, PrefixTarget, PrefixU8, RstTarget, StackTarget};
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
        if(debug) {
            print!("step 0x{:04X} ", self.pc);
        }

        if self.ime_scheduled == true {
            self.ime_scheduled = false;
            self.ime = true;
        }

        let mut instruction_byte = self.read_byte(self.pc);
        let prefixed = instruction_byte == 0xCB;
        if prefixed {
            instruction_byte = self.read_byte(self.pc + 1);
        }

        let next_pc = self.execute(instruction_byte);

        self.pc = next_pc;
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
        let i_enable = self.read_byte(0xFFFF);
        let mut if_register_trigger = self.read_byte(0xFF0F);
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

    pub fn execute(&mut self, byte: u8) -> u16 {
        if self.halted {
            return self.pc.wrapping_add(1);
        }

        match byte {
            0x00 => self.pc.wrapping_add(1),
            0x01 => {
                let value = self.read_next_word();
                self.registers.set_bc(value); 
                self.pc.wrapping_add(3)
            },
            0x02 => {
                let value = self.registers.a;
                let address = self.registers.get_bc();
                self.write_byte(address, value);
                self.pc.wrapping_add(1)},
            0x03 => {
                let value =  self.registers.get_bc().wrapping_add(1);
                self.registers.set_bc(value);
                self.pc.wrapping_add(1)
            },
            0x04 => {
                let value = self.registers.b.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.b & 0xF) + 0x1 > 0xF;
                self.registers.b = value;
                self.pc.wrapping_add(1)
            },
            0x05 => {
                let value = self.registers.b.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.b & 0xF) < 0x1;
                self.registers.b = value;
                self.pc.wrapping_add(1)
            },
            0x06 => {
                self.registers.b = self.read_next_byte();
                self.pc.wrapping_add(2)
            },
            0x07 => {
                let value = self.registers.a;
                let value = self.rlc(value);
                self.registers.a = value;
                self.registers.f.zero = false;
                self.pc.wrapping_add(1)
            },
            0x08 => {
                let address = self.read_next_word();
                self.write_word(address, self.sp);
                self.pc.wrapping_add(3)
            },

            0x09 => {
                let value = self.registers.get_bc();
                let value = self.add_16(value);
                self.registers.set_hl(value);
                self.pc.wrapping_add(1)
            },
            0x0a => {
                self.registers.a = self.read_byte(self.registers.get_bc());
                self.pc.wrapping_add(1)
            },
            0x0b => {
                let value =  self.registers.get_bc().wrapping_sub(1);
                self.registers.set_bc(value);
                self.pc.wrapping_add(1)
            },
            0x0c => {
                let value = self.registers.c.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.c & 0xF) + 0x1 > 0xF;
                self.registers.c = value;
                self.pc.wrapping_add(1)
            },
            0x0d =>  {
                let value = self.registers.c.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.c & 0xF) < 0x1;
                self.registers.c = value;
                self.pc.wrapping_add(1)
            },
            0x0e => {
                self.registers.c = self.read_next_byte();
                self.pc.wrapping_add(2)
            },
            0x0f => {
                let value = self.registers.a;
                let value = self.rrc(value);
                self.registers.a = value;
                self.registers.f.zero = false;
                self.pc.wrapping_add(1)
            },
            0x10 => {
                // Stop clock
                panic!("TODO: implement STOP")
            },
            0x11 => {
                let value = self.read_next_word();
                self.registers.set_de(value);
                self.pc.wrapping_add(3)
            },
            0x12 => {
                self.write_byte(self.registers.get_hl(), self.registers.a);
                self.pc.wrapping_add(1)
            },
            0x13 =>  {
                let value =  self.registers.get_de().wrapping_add(1);
                self.registers.set_de(value);
                self.pc.wrapping_add(1)
            },
            0x14 => {
                let value = self.registers.d.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.d & 0xF) + 0x1 > 0xF;
                self.registers.d = value;
                self.pc.wrapping_add(1)
            },
            0x15 => {
                let value = self.registers.d.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.d & 0xF) < 0x1;
                self.registers.d = value;
                self.pc.wrapping_add(1)
            },
            0x16 => {
                self.registers.d = self.read_next_byte();
                self.pc.wrapping_add(2)
            },
            0x17 => {
                let value = self.registers.a;
                let value = self.rl(value);
                self.registers.a = value;
                self.registers.f.zero = false;
                self.pc.wrapping_add(1)
            },
            0x18 => self.jump_relative(true),
            0x19 => {
                let value = self.registers.get_de();
                let value = self.add_16(value);
                self.registers.set_hl(value);
                self.pc.wrapping_add(1)
            },
            0x1a => {
                self.registers.a = self.read_byte(self.registers.get_de());
                self.pc.wrapping_add(1)
            },
            0x1b =>  {
                let value =  self.registers.get_de().wrapping_sub(1);
                self.registers.set_de(value);
                self.pc.wrapping_add(1)
            },
            0x1c => {
                let value = self.registers.e.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.e & 0xF) + 0x1 > 0xF;
                self.registers.e = value;
                self.pc.wrapping_add(1)
            },
            0x1d => {
                let value = self.registers.e.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.e & 0xF) < 0x1;
                self.registers.e = value;
                self.pc.wrapping_add(1)
            },
            0x1e => {
                self.registers.e = self.read_next_byte();
                self.pc.wrapping_add(2)
            },
            0x1f => {
                let value = self.registers.a;
                let value = self.rr(value);
                self.registers.a = value;
                self.registers.f.zero = false;
                self.pc.wrapping_add(1)
            },
            0x20 => self.jump_relative(!self.registers.f.zero),
            0x21 => {
                // ICI
                let value = self.read_next_word();
                self.registers.set_hl(value);
                self.pc.wrapping_add(3)
            },
            0x22 => {
                self.write_byte(self.registers.get_hl(), self.registers.a);
                self.registers.set_hl(self.registers.get_hl().wrapping_add(1));
                self.pc.wrapping_add(1)
            },
            0x23 => {
                let value =  self.registers.get_hl().wrapping_add(1);
                self.registers.set_hl(value);
                self.pc.wrapping_add(1)
            },
            0x24 => {
                let value =  self.registers.h.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.h & 0xF) + 0x1 > 0xF;
                self.registers.h = value;
                self.pc.wrapping_add(1)
            },
            0x25 => {
                let value =  self.registers.h.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.h & 0xF) < 0x1;
                self.registers.h = value;
                self.pc.wrapping_add(1)
            },
            0x26 => {
                self.registers.h = self.read_next_byte();
                self.pc.wrapping_add(2)
            },
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
                self.pc.wrapping_add(1)
            },
            0x28 => self.jump_relative(self.registers.f.zero),
            0x29 => {
                let value = self.registers.get_hl();
                let value = self.add_16(value);
                self.registers.set_hl(value);
                self.pc.wrapping_add(1)
            },
            0x2a => {
                self.registers.a = self.read_byte(self.registers.get_hl());
                self.registers.set_hl(self.registers.get_hl().wrapping_add(1));
                self.pc.wrapping_add(1)
            },
            0x2b => {
                let value =  self.registers.get_hl().wrapping_sub(1);
                self.registers.set_hl(value);
                self.pc.wrapping_add(1)
            },
            0x2c => {
                let value =  self.registers.l.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.l & 0xF) + 0x1 > 0xF;
                self.registers.l = value;
                self.pc.wrapping_add(1)
            },
            0x2d => {
                let value =  self.registers.l.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.l & 0xF) < 0x1;
                self.registers.l = value;
                self.pc.wrapping_add(1)
            },
            0x2e => {
                self.registers.l = self.read_next_byte();
                self.pc.wrapping_add(2)
            },
            0x2f => {
                self.registers.a = !self.registers.a;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = true;
                self.pc.wrapping_add(1)
            },
            0x30 => self.jump_relative(!self.registers.f.carry),
            0x31 => {
                self.sp = self.read_next_word();
                self.pc.wrapping_add(3)
            },
            0x32 => {
                self.write_byte(self.registers.get_hl(), self.registers.a);
                self.registers.set_hl(self.registers.get_hl().wrapping_sub(1));
                self.pc.wrapping_add(1)
            },
            0x33 => {
                let value =  self.sp.wrapping_add(1);
                self.sp = value;
                self.pc.wrapping_add(1)
            },
            0x34 => {
                let value =  self.read_byte(self.registers.get_hl()).wrapping_add(1);
                self.write_byte(self.registers.get_hl(), value);
                self.pc.wrapping_add(1)
            },
            0x35 => {
                let value =  self.read_byte(self.registers.get_hl()).wrapping_sub(1);
                self.write_byte(self.registers.get_hl(), value);
                self.pc.wrapping_add(1)
            },
            0x36 => {
                let value = self.read_next_byte();
                let address = self.registers.get_hl();
                self.write_byte(address, value);
                self.pc.wrapping_add(2)
            },
            0x37 => {
                self.registers.f.subtract = false;
                self.registers.f.half_carry = false;
                self.registers.f.carry = true;
                self.pc.wrapping_add(1)
            },
            0x38 => self.jump_relative(self.registers.f.carry),
            0x39 => {
                let value = self.sp;
                let value = self.add_16(value);
                self.registers.set_hl(value);
                self.pc.wrapping_add(1)
            },
            0x3a => {
                self.registers.a = self.read_byte(self.registers.get_hl());
                self.registers.set_hl(self.registers.get_hl().wrapping_sub(1));
                self.pc.wrapping_add(1)
            },
            0x3b => {
                let value =  self.sp.wrapping_sub(1);
                self.sp = value;
                self.pc.wrapping_add(1)
            },
            0x3c => {
                let value =  self.registers.a.wrapping_add(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.registers.a & 0xF) + 0x1 > 0xF;
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x3d => {
                let value =  self.registers.a.wrapping_sub(1);
                self.registers.f.zero = value == 0;
                self.registers.f.subtract = true;
                self.registers.f.half_carry = (self.registers.a & 0xF) < 0x1;
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x3e => {
                self.registers.a = self.read_next_byte();
                self.pc.wrapping_add(2)
            },
            0x3f => {
                self.registers.f.subtract = false;
                self.registers.f.half_carry = false;
                self.registers.f.carry = !self.registers.f.carry;
                self.pc.wrapping_add(1)
            },
            0x40 => {
                self.registers.b = self.registers.b;
                self.pc.wrapping_add(1)
            },
            0x41 => {
                self.registers.b = self.registers.c;
                self.pc.wrapping_add(1)
            },
            0x42 => {
                self.registers.b = self.registers.d;
                self.pc.wrapping_add(1)
            },
            0x43 => {
                self.registers.b = self.registers.e;
                self.pc.wrapping_add(1)
            },
            0x44 => {
                self.registers.b = self.registers.h;
                self.pc.wrapping_add(1)
            },
            0x45 => {
                self.registers.b = self.registers.l;
                self.pc.wrapping_add(1)
            },
            0x46 => {
                self.registers.b = self.read_byte(self.registers.get_hl());
                self.pc.wrapping_add(1)
            },
            0x47 => {
                self.registers.b = self.registers.a;
                self.pc.wrapping_add(1)
            },
            0x48 => {
                self.registers.c = self.registers.b;
                self.pc.wrapping_add(1)
            },
            0x49 => {
                self.registers.c = self.registers.c;
                self.pc.wrapping_add(1)
            },
            0x4a => {
                self.registers.c = self.registers.d;
                self.pc.wrapping_add(1)
            },
            0x4b => {
                self.registers.c = self.registers.e;
                self.pc.wrapping_add(1)
            },
            0x4c => {
                self.registers.c = self.registers.h;
                self.pc.wrapping_add(1)
            },
            0x4d => {
                self.registers.c = self.registers.l;
                self.pc.wrapping_add(1)
            },
            0x4e => {
                self.registers.c = self.read_byte(self.registers.get_hl());
                self.pc.wrapping_add(1)
            },
            0x4f => {
                self.registers.c = self.registers.a;
                self.pc.wrapping_add(1)
            },
            0x50 => {
                self.registers.d = self.registers.b;
                self.pc.wrapping_add(1)
            },
            0x51 => {
                self.registers.d = self.registers.c;
                self.pc.wrapping_add(1)
            },
            0x52 => {
                self.registers.d = self.registers.d;
                self.pc.wrapping_add(1)
            },
            0x53 => {
                self.registers.d = self.registers.e;
                self.pc.wrapping_add(1)
            },
            0x54 => {
                self.registers.d = self.registers.h;
                self.pc.wrapping_add(1)
            },
            0x55 => {
                self.registers.d = self.registers.l;
                self.pc.wrapping_add(1)
            },
            0x56 => {
                self.registers.d = self.read_byte(self.registers.get_hl());
                self.pc.wrapping_add(1)
            },
            0x57 => {
                self.registers.d = self.registers.a;
                self.pc.wrapping_add(1)
            },
            0x58 => {
                self.registers.e = self.registers.b;
                self.pc.wrapping_add(1)
            },
            0x59 => {
                self.registers.e = self.registers.c;
                self.pc.wrapping_add(1)
            },
            0x5a => {
                self.registers.e = self.registers.d;
                self.pc.wrapping_add(1)
            },
            0x5b => {
                self.registers.e = self.registers.e;
                self.pc.wrapping_add(1)
            },
            0x5c => {
                self.registers.e = self.registers.h;
                self.pc.wrapping_add(1)
            },
            0x5d => {
                self.registers.e = self.registers.l;
                self.pc.wrapping_add(1)
            },
            0x5e => {
                self.registers.e = self.read_byte(self.registers.get_hl());
                self.pc.wrapping_add(1)
            },
            0x5f => {
                self.registers.e = self.registers.a;
                self.pc.wrapping_add(1)
            },
            0x60 => {
                self.registers.h = self.registers.b;
                self.pc.wrapping_add(1)
            },
            0x61 => {
                self.registers.h = self.registers.c;
                self.pc.wrapping_add(1)
            },
            0x62 => {
                self.registers.h = self.registers.d;
                self.pc.wrapping_add(1)
            },
            0x63 => {
                self.registers.h = self.registers.e;
                self.pc.wrapping_add(1)
            },
            0x64 => {
                self.registers.h = self.registers.h;
                self.pc.wrapping_add(1)
            },
            0x65 => {
                self.registers.h = self.registers.l;
                self.pc.wrapping_add(1)
            },
            0x66 => {
                self.registers.h = self.read_byte(self.registers.get_hl());
                self.pc.wrapping_add(1)
            },
            0x67 => {
                self.registers.h = self.registers.a;
                self.pc.wrapping_add(1)
            },
            0x68 => {
                self.registers.l = self.registers.b;
                self.pc.wrapping_add(1)
            },
            0x69 => {
                self.registers.l = self.registers.c;
                self.pc.wrapping_add(1)
            },
            0x6a => {
                self.registers.l = self.registers.d;
                self.pc.wrapping_add(1)
            },
            0x6b => {
                self.registers.l = self.registers.e;
                self.pc.wrapping_add(1)
            },
            0x6c => {
                self.registers.l = self.registers.h;
                self.pc.wrapping_add(1)
            },
            0x6d => {
                self.registers.l = self.registers.l;
                self.pc.wrapping_add(1)
            },
            0x6e => {
                self.registers.l = self.read_byte(self.registers.get_hl());
                self.pc.wrapping_add(1)
            },
            0x6f => {
                self.registers.l = self.registers.a;
                self.pc.wrapping_add(1)
            },
            0x70 => {
                self.write_byte(self.registers.get_hl(), self.registers.b);
                self.pc.wrapping_add(1)
            },
            0x71 => {
                self.write_byte(self.registers.get_hl(), self.registers.c);
                self.pc.wrapping_add(1)
            },
            0x72 => {
                self.write_byte(self.registers.get_hl(), self.registers.d);
                self.pc.wrapping_add(1)
            },
            0x73 => {
                self.write_byte(self.registers.get_hl(), self.registers.e);
                self.pc.wrapping_add(1)
            },
            0x74 => {
                self.write_byte(self.registers.get_hl(), self.registers.h);
                self.pc.wrapping_add(1)
            },
            0x75 => {
                self.write_byte(self.registers.get_hl(), self.registers.l);
                self.pc.wrapping_add(1)
            },
            0x76 => {
                self.halted = true;
                self.pc.wrapping_add(1)
            },
            0x77 => {
                self.write_byte(self.registers.get_hl(), self.registers.a);
                self.pc.wrapping_add(1)
            },
            0x78 => {
                self.registers.a = self.registers.b;
                self.pc.wrapping_add(1)
            },
            0x79 => {
                self.registers.a = self.registers.c;
                self.pc.wrapping_add(1)
            },
            0x7a => {
                self.registers.a = self.registers.d;
                self.pc.wrapping_add(1)
            },
            0x7b => {
                self.registers.a = self.registers.e;
                self.pc.wrapping_add(1)
            },
            0x7c => {
                self.registers.a = self.registers.h;
                self.pc.wrapping_add(1)
            },
            0x7d => {
                self.registers.a = self.registers.l;
                self.pc.wrapping_add(1)
            },
            0x7e => {
                self.registers.a = self.read_byte(self.registers.get_hl());
                self.pc.wrapping_add(1)
            },
            0x7f => {
                self.registers.a = self.registers.a;
                self.pc.wrapping_add(1)
            },
            0x80 => {
                let value = self.registers.b;
                let value = self.add(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x81 => {
                let value = self.registers.c;
                let value = self.add(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x82 => {
                let value = self.registers.d;
                let value = self.add(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x83 => {
                let value = self.registers.e;
                let value = self.add(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x84 => {
                let value = self.registers.h;
                let value = self.add(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x85 => {
                let value = self.registers.l;
                let value = self.add(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x86 => {
                let value = self.read_byte(self.registers.get_hl());
                let value = self.add(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x87 => {
                let value = self.registers.a;
                let value = self.add(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x88 => {
                let value = self.registers.b;
                let value = self.add_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x89 => {
                let value = self.registers.c;
                let value = self.add_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x8a => {
                let value = self.registers.d;
                let value = self.add_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x8b => {
                let value = self.registers.e;
                let value = self.add_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x8c => {
                let value = self.registers.h;
                let value = self.add_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x8d => {
                let value = self.registers.l;
                let value = self.add_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x8e => {
                let value = self.read_byte(self.registers.get_hl());
                let value = self.add_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x8f => {
                let value = self.registers.a;
                let value = self.add_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x90 => {
                let value = self.registers.b;
                let value = self.sub(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x91 => {
                let value = self.registers.c;
                let value = self.sub(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x92 => {
                let value = self.registers.d;
                let value = self.sub(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x93 => {
                let value = self.registers.e;
                let value = self.sub(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x94 => {
                let value = self.registers.h;
                let value = self.sub(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x95 => {
                let value = self.registers.l;
                let value = self.sub(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x96 => {
                let value = self.read_byte(self.registers.get_hl());
                let value = self.sub(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x97 => {
                let value = self.registers.a;
                let value = self.sub(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x98 => {
                let value = self.registers.b;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x99 => {
                let value = self.registers.c;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x9a => {
                let value = self.registers.d;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x9b => {
                let value = self.registers.e;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x9c => {
                let value = self.registers.h;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x9d => {
                let value = self.registers.l;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x9e => {
                let value = self.read_byte(self.registers.get_hl());
                let value = self.sub_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0x9f => {
                let value = self.registers.a;
                let value = self.sub_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(1)
            },
            0xa0 => {
                let value = self.registers.b;
                self.and(value);
                self.pc.wrapping_add(1)
            },
            0xa1 => {
                let value = self.registers.c;
                self.and(value);
                self.pc.wrapping_add(1)
            },
            0xa2 => {
                let value = self.registers.d;
                self.and(value);
                self.pc.wrapping_add(1)
            },
            0xa3 => {
                let value = self.registers.e;
                self.and(value);
                self.pc.wrapping_add(1)
            },
            0xa4 => {
                let value = self.registers.h;
                self.and(value);
                self.pc.wrapping_add(1)
            },
            0xa5 => {
                let value = self.registers.l;
                self.and(value);
                self.pc.wrapping_add(1)
            },
            0xa6 => {
                let value = self.read_byte(self.registers.get_hl());
                self.and(value);
                self.pc.wrapping_add(1)
            },
            0xa7 => {
                let value = self.registers.a;
                self.and(value);
                self.pc.wrapping_add(1)
            },
            0xa8 => {
                let value = self.registers.b;
                self.xor(value);
                self.pc.wrapping_add(1)
            },
            0xa9 => {
                let value = self.registers.c;
                self.xor(value);
                self.pc.wrapping_add(1)
            },
            0xaa => {
                let value = self.registers.d;
                self.xor(value);
                self.pc.wrapping_add(1)
            },
            0xab => {
                let value = self.registers.e;
                self.xor(value);
                self.pc.wrapping_add(1)
            },
            0xac => {
                let value = self.registers.h;
                self.xor(value);
                self.pc.wrapping_add(1)
            },
            0xad => {
                let value = self.registers.l;
                self.xor(value);
                self.pc.wrapping_add(1)
            },
            0xae => {
                let value = self.read_byte(self.registers.get_hl());
                self.xor(value);
                self.pc.wrapping_add(1)
            },
            0xaf => {
                let value = self.registers.a;
                self.xor(value);
                self.pc.wrapping_add(1)
            },
            0xb0 => {
                let value = self.registers.b;
                self.or(value);
                self.pc.wrapping_add(1)
            }
            0xb1 => {
                let value = self.registers.c;
                self.or(value);
                self.pc.wrapping_add(1)
            }
            0xb2 => {
                let value = self.registers.d;
                self.or(value);
                self.pc.wrapping_add(1)
            }
            0xb3 => {
                let value = self.registers.e;
                self.or(value);
                self.pc.wrapping_add(1)
            }
            0xb4 => {
                let value = self.registers.h;
                self.or(value);
                self.pc.wrapping_add(1)
            }
            0xb5 => {
                let value = self.registers.l;
                self.or(value);
                self.pc.wrapping_add(1)
            }
            0xb6 => {
                let value = self.read_byte(self.registers.get_hl());
                self.or(value);
                self.pc.wrapping_add(1)
            }
            0xb7 => {
                let value = self.registers.a;
                self.or(value);
                self.pc.wrapping_add(1)
            }
            0xb8 => {
                let value = self.registers.b;
                self.cp(value);
                self.pc.wrapping_add(1)
            },
            0xb9 => {
                let value = self.registers.c;
                self.cp(value);
                self.pc.wrapping_add(1)
            },
            0xba => {
                let value = self.registers.d;
                self.cp(value);
                self.pc.wrapping_add(1)
            },
            0xbb => {
                let value = self.registers.e;
                self.cp(value);
                self.pc.wrapping_add(1)
            },
            0xbc => {
                let value = self.registers.h;
                self.cp(value);
                self.pc.wrapping_add(1)
            },
            0xbd => {
                let value = self.registers.l;
                self.cp(value);
                self.pc.wrapping_add(1)
            },
            0xbe => {
                let value = self.read_byte(self.registers.get_hl());
                self.cp(value);
                self.pc.wrapping_add(1)
            },
            0xbf => {
                let value = self.registers.a;
                self.cp(value);
                self.pc.wrapping_add(1)
            },
            0xc0 => self.return_(!self.registers.f.zero),
            0xc1 => {
                let value = self.pop();
                self.registers.set_bc(value);
                self.pc.wrapping_add(1)
            },
            0xc2 => self.jump(!self.registers.f.zero),
            0xc3 => self.jump(true),
            0xc4 => self.call(!self.registers.f.zero),
            0xc5 => {
                self.push(self.registers.get_bc());
                self.pc.wrapping_add(1)
            },
            0xc6 => {
                let value = self.read_next_byte();
                let value = self.add(value);
                self.registers.a = value;
                self.pc.wrapping_add(2)
            },
            0xc7 => {
                self.push(self.pc);
                self.pc = 0x0000;
                self.pc.wrapping_add(1)
            },
            0xc8 => self.return_(self.registers.f.zero),
            0xc9 => self.return_(true),
            0xca => self.jump(self.registers.f.zero),
            0xcc => self.call(self.registers.f.zero),
            0xcd => self.call(true),
            0xce => {
                let value = self.read_next_byte();
                let value = self.add_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(2)
            },
            0xcf => {
                self.push(self.pc);
                self.pc = 0x0008;
                self.pc.wrapping_add(1)
            },
            0xd0 => self.return_(!self.registers.f.carry),
            0xd1 => {
                let value = self.pop();
                self.registers.set_de(value);
                self.pc.wrapping_add(1)
            },
            0xd2 => self.jump(!self.registers.f.carry),
            0xd4 => self.call(!self.registers.f.carry),
            0xd5 => {
                self.push(self.registers.get_de());
                self.pc.wrapping_add(1)
            },
            0xd6 => {
                let value = self.read_next_byte();
                let value = self.sub(value);
                self.registers.a = value;
                self.pc.wrapping_add(2)
            },
            0xd7 => {
                self.push(self.pc);
                self.pc = 0x0010;
                self.pc.wrapping_add(1)
            },
            0xd8 => self.return_(self.registers.f.carry),
            0xd9 => {
                self.return_(true);
                self.ime = true;
                self.pc.wrapping_add(1)
            },
            0xda => self.jump(self.registers.f.carry),
            0xdc => self.call(self.registers.f.carry),
            0xde => {
                let value = self.read_next_byte();
                let value = self.sub_with_carry(value);
                self.registers.a = value;
                self.pc.wrapping_add(2)
            },
            0xdf => {
                self.push(self.pc);
                self.pc = 0x0018;
                self.pc.wrapping_add(1)
            },
            0xe0 => {
                let address = self.read_next_byte();
                self.write_byte(0xFF00 | address as u16, self.registers.a);
                self.pc.wrapping_add(2)
            },
            0xe1 => {
                let value = self.pop();
                self.registers.set_hl(value);
                self.pc.wrapping_add(1)
            },
            0xe2 => {
                self.write_byte(0xFF00 | self.registers.c as u16, self.registers.a);
                self.pc.wrapping_add(1)
            },
            0xe5 => {
                self.push(self.registers.get_hl());
                self.pc.wrapping_add(1)
            },
            0xe6 => {
                let value = self.read_next_byte();
                self.and(value);
                self.pc.wrapping_add(2)
            },
            0xe7 => {
                self.push(self.pc);
                self.pc = 0x0020;
                self.pc.wrapping_add(1)
            },
            0xe8 => {
                let value = self.read_next_byte();
                let value = self.add_16(value as u16);
                self.sp = value;
                self.pc.wrapping_add(2)
            },
            0xe9 => {
                self.pc = self.registers.get_hl();
                self.pc.wrapping_add(1)
            },
            0xea => {
                let address = self.read_next_word();
                self.write_byte(address, self.registers.a);
                self.pc.wrapping_add(3)
            },
            0xee => {
                let value = self.read_next_byte();
                self.xor(value);
                self.pc.wrapping_add(2)
            },
            0xef => {
                self.push(self.pc);
                self.pc = 0x0028;
                self.pc.wrapping_add(1)
            },
            0xf0 => {
                let address = self.read_next_byte();
                self.registers.a = self.read_byte(0xFF00 | address as u16);
                self.pc.wrapping_add(2)
            },
            0xf1 => {
                let value = self.pop();
                self.registers.set_af(value);
                self.pc.wrapping_add(1)
            },
            0xf2 => {
                self.registers.a = self.read_byte(0xFF00 | self.registers.c as u16);
                self.pc.wrapping_add(2)
            },
            0xf3 => {
                // Disable interrupts => IME = 0 and cancel any pending EI
                self.ime = false;
                self.pc.wrapping_add(1)
            },
            0xf5 => {
                self.push(self.registers.get_af());
                self.pc.wrapping_add(1)
            },
            0xf6 => {
                let value = self.read_next_byte();
                self.or(value);
                self.pc.wrapping_add(2)
            },
            0xf7 => {
                self.push(self.pc);
                self.pc = 0x0030;
                self.pc.wrapping_add(1)
            },
            0xf8 => {
                let offset = self.read_next_byte() as i8 as i16 as u16;
                self.registers.f.zero = false;
                self.registers.f.subtract = false;
                self.registers.f.half_carry = (self.sp & 0xF) + (offset & 0xF) > 0xF;
                self.registers.f.carry = (self.sp & 0xFF) + (offset & 0xFF) > 0xFF;
                self.registers.set_hl(self.sp.wrapping_add(offset));
                self.pc.wrapping_add(2)
            },
            0xf9 => {
                self.sp = self.registers.get_hl();
                self.pc.wrapping_add(1)
            },
            0xfa => {
                let address = self.read_next_word();
                self.registers.a = self.read_byte(address);
                self.pc.wrapping_add(3)
            },
            0xfb => {
                // Schedule interrupt enable
                self.ime_scheduled = true;
                self.pc.wrapping_add(1)
            },
            0xfe => {
                let value = self.read_next_byte();
                self.cp(value);
                self.pc.wrapping_add(2)
            },
            0xff => {
                self.push(self.pc);
                self.pc = 0x0038;
                self.pc.wrapping_add(1)
            },

            _ => panic!("Unknown instruction: {:x}", byte)
        }
    }

    fn read_byte(self: &mut Self, addr: u16) -> u8 {
        let byte = self.bus.read_byte(addr);
        // self.adv_cycles(4);
        // self.curr_cycles += 4;
        return byte;
    }

    fn write_byte(self: &mut Self, addr: u16, data: u8) {
        self.bus.write_byte(addr, data);
        // self.adv_cycles(4);
        // self.curr_cycles += 4;
    }

    fn write_word(self: &mut Self, addr: u16, data: u16) {
        self.bus.write_word(addr, data);
        // self.adv_cycles(8);
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
        let lsb = self.read_byte(self.sp) as u16;
        self.sp = self.sp.wrapping_add(1);

        let msb = self.read_byte(self.sp) as u16;
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

    pub fn jump(&mut self, should_jump: bool) -> u16 {
        if should_jump {
            let least_significant_byte = self.read_byte(self.pc + 1) as u16;
            let most_significant_byte = self.read_byte(self.pc + 2) as u16;
            (most_significant_byte << 8) | least_significant_byte
        } else {
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
            self.pc = self.pc.wrapping_add(1);
            let offset = self.read_next_byte() as i8 as i16;
            self.pc = self.pc.wrapping_add(offset as u16);
            self.pc.wrapping_add(1)
        } else {
            self.pc.wrapping_add(2)
        }
    }

    fn read_next_word(&mut self) -> u16 {
        let least_significant_byte = self.read_byte(self.pc + 1) as u16;
        let most_significant_byte = self.read_byte(self.pc + 2) as u16;
        (most_significant_byte << 8) | least_significant_byte
    }

    pub(crate) fn read_next_byte(&mut self) -> u8 {
        let byte = self.read_byte(self.pc);
        // self.pc = self.pc.wrapping_add(1);
        byte
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
        let did_overflow = value & 0x80 == 0x80;
        let value = value << 1;
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.half_carry = false;
        self.registers.f.carry = did_overflow;
        value
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
        let value = ((value & 0xF0) >> 4) | ((value & 0x0F) << 4);
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