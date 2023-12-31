use sdl2::render::Texture;

use crate::mods::bus::Bus;
use crate::mods::mbc_5::Mbc5;
use crate::mods::mbc_default::MbcDefault;
use crate::mods::register::Registers;

pub struct Cpu {
    registers: Registers,
    bus: Bus,
    pc: u16,
    sp: u16,
    ime: bool,
    ime_scheduled: bool,
    halted: bool
}

impl Cpu {

    pub fn new() -> Cpu {
        Cpu {
            registers: Registers::new(),
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

    pub(crate) fn step(&mut self) {
        if self.ime_scheduled {
            self.ime_scheduled = false;
            self.ime = true;
        }

        let instruction_byte = self.read_pc();

        let prefixed = instruction_byte == 0xCB;
        if prefixed {
            let prefix_instruction_byte = self.read_pc();
            self.execute_prefixed(prefix_instruction_byte);
        } else {
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
                self.jump_relative(self.registers.f.zero);
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
            0x40 => {}
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
            0x49 => {}
            0x4a => {
                self.registers.c = self.registers.d;
            }
            0x4b => {}
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
            0x52 => {}
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
            0x5b => {}
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
            0x64 => {}
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
            0x6d => {}
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
            0x7f => {}
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
            }
            0xf1 => {
                let value = self.pop();
                self.registers.set_af(value);
            }
            0xf2 => {
                self.registers.a = self.read_address(0xFF00 | self.registers.c as u16);
            }
            0xf3 => {
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
        let i_enable = self.read_address(0xFFFF);
        let mut if_register_trigger = self.read_address(0xFF0F);
        self.ime = false;
        self.halted = false;

        for i in 0..=4 {
            if i_enable & if_register_trigger & (0x01 << i) == (0x01 << i) {
                if_register_trigger &= !(0x01 << i);
                self.write_byte(0xFF0F, if_register_trigger);

                self.push(self.pc);

                self.pc = 0x0040 + (0x0008 * i);
                break;
            }
        }
    }

    pub fn adv_cycles(&mut self, cycles: usize) {
        self.bus.adv_cycles(cycles);
    }

    pub fn internal_cycle(&mut self) {
        self.adv_cycles(4);
        // self.curr_cycles += 4;
    }

    fn read_address(&mut self, address: u16) -> u8 {
        let byte = self.bus.read_byte(address);
        self.adv_cycles(4);
        // self.curr_cycles += 4;
        byte
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

    fn write_byte(&mut self, addr: u16, data: u8) {
        self.bus.write_byte(addr, data);
        self.adv_cycles(4);
        // self.curr_cycles += 4;
    }

    fn write_word(&mut self, addr: u16, data: u16) {
        self.bus.write_word(addr, data);
        self.adv_cycles(8);
        // self.curr_cycles += 8;
    }

    pub fn set_keypad(&mut self, event_pump: sdl2::EventPump) {
        self.bus.set_keypad(event_pump);
    }

    pub fn set_mbc_default(&mut self, cart_mbc: MbcDefault) {
        self.bus.set_mbc_default(cart_mbc);
    }

    pub fn set_mbc_5(&mut self, cart_mbc: Box<Mbc5>) {
        self.bus.set_mbc_5(cart_mbc);
    }

    pub fn update_input(&mut self) -> bool {
        self.bus.update_input()
    }

    pub fn push(&mut self, value: u16) {
        self.sp = self.sp.wrapping_sub(1);
        self.write_byte(self.sp, ((value & 0xFF00) >> 8) as u8);

        self.sp = self.sp.wrapping_sub(1);
        self.write_byte(self.sp, (value & 0xFF) as u8);
    }

    pub fn pop(&mut self) -> u16 {
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
        let (value, did_overflow) = self.registers.a.overflowing_add(value);
        let (value, did_overflow2) = value.overflowing_add(carry);
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = false;
        self.registers.f.carry = did_overflow | did_overflow2;
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
        let (value, did_overflow) = self.registers.a.overflowing_sub(value);
        let (value, did_overflow2) = value.overflowing_sub(carry);
        self.registers.f.zero = value == 0;
        self.registers.f.subtract = true;
        self.registers.f.carry = did_overflow | did_overflow2;
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
    }

    fn jump_relative(&mut self, should_jump: bool) {
        let offset = self.read_pc() as i8 as i16; // double cast to convert to signed
        if should_jump {
            self.internal_cycle();
            self.pc = self.pc.wrapping_add_signed(offset);
        }
    }

    fn call(&mut self, should_jump: bool) {
        let val = self.read_next_word();
        if should_jump {
            self.internal_cycle();
            self.push(self.pc);
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

    pub fn update_display(&mut self, texture: &mut Texture) -> bool {
        self.bus.update_display(texture)
    }

    pub fn halted(&mut self) -> bool {
        self.halted
    }
}