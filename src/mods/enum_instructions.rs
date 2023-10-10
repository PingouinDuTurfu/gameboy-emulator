use crate::mods::enum_instructions::AddType::ToA;

pub enum Instruction {
    PUSH(StackTarget),                   // OK
    POP(StackTarget),                    // OK

    ADD(AddType),                        // OK

    ADC(ArithmeticTarget),               // OK
    SUB(ArithmeticTarget),               // OK
    SBC(ArithmeticTarget),               // OK
    CP(ArithmeticTarget),                // OK

    AND(ArithmeticTarget),               // OK
    OR(ArithmeticTarget),                // OK
    XOR(ArithmeticTarget),               // OK

    INC(IncDecTarget),                   // OK
    DEC(IncDecTarget),                   // OK

    JP(JumpTestWithHLI),                 // OK
    CALL(JumpTest),                      // OK
    RET(JumpTest),                       // OK
    RETI,
    JR(JumpTest),                        // OK

    RST(RstTarget),                      // OK

    LD(LoadType),                        // OK
    LDH_A8I_to_A,                        // OK
    LDH_A_to_A8I,                        // OK

    CCF,                                 // OK
    SCF,                                 // OK
    DAA,                                 // OK
    CPL,                                 // OK

    RLCA,                                // OK
    RLA,                                 // OK
    RRCA,                                // OK
    RRA,                                 // OK

    NOP,                                 // OK
    STOP,
    HALT,                                // OK
    DI,
    EI,


    // PREFIXED INSTRUCTIONS
    RLC(PrefixTarget),                   // OK
    RRC(PrefixTarget),                   // OK
    RL(PrefixTarget),                    // OK
    RR(PrefixTarget),                    // OK
    SLA(PrefixTarget),                   // OK
    SRA(PrefixTarget),                   // OK
    SWAP(PrefixTarget),                  // OK
    SRL(PrefixTarget),                   // OK
    BIT(PrefixU8, PrefixTarget),         // OK
    RES(PrefixU8, PrefixTarget),         // OK
    SET(PrefixU8, PrefixTarget),         // OK
}

pub enum LoadType { Byte(LoadByteTarget, LoadByteSource), Word(LoadWordTarget, LoadWordSource) }
pub enum AddType { ToA(ArithmeticTarget), ToHL(Arithmetic16Target), ToSP }
pub enum StackTarget { BC, DE, HL, AF }
pub enum ArithmeticTarget { A, B, C, D, E, H, L, HLI, D8 }
pub enum Arithmetic16Target { BC, DE, HL, SP }
pub enum IncDecTarget { A, B, C, D, E, H, L, BC, DE, HL, SP, HLI }
pub enum JumpTest { NotZero, Zero, NotCarry, Carry, Always }
pub enum JumpTestWithHLI { NotZero, Zero, NotCarry, Carry, Always, HLI }
pub enum LoadByteTarget { A, B, C, D, E, H, L, HLI, BCI, DEI, HLIInc, HLIDec, A16I, A8I, CI }
pub enum LoadByteSource { A, B, C, D, E, H, L, D8, HLI, BCI, DEI, HLIInc, HLIDec, A16I, A8I, CI }
pub enum LoadWordTarget { BC, DE, HL, SP, A16I }
pub enum LoadWordSource { D16, SP, HL, SPPlusD8 }
pub enum RstTarget { H00, H08, H10, H18, H20, H28, H30, H38 }
pub enum PrefixTarget { A, B, C, D, E, H, L, HLI }
pub enum PrefixU8 { U0, U1, U2, U3, U4, U5, U6, U7 }

impl Instruction {
    pub(crate) fn from_byte(byte: u8, prefixed: bool) -> Option<Instruction> {
        if prefixed {
            Instruction::print_debug_prefixed(byte.clone());
            Instruction::from_byte_prefixed(byte)
        } else {
            Instruction::print_debug(byte.clone());
            Instruction::from_byte_not_prefixed(byte)
        }
    }

    fn print_debug(byte: u8) {
        print!("0x{:02X} ", byte);
        match byte {
            0x00 => println!("NOP"), 0x01 => println!("LD BC, d16"), 0x02 => println!("LD (BC), A"), 0x03 => println!("INC BC"), 0x04 => println!("INC B"), 0x05 => println!("DEC B"), 0x06 => println!("LD B, d8"), 0x07 => println!("RLCA"), 0x08 => println!("LD (a16), SP"), 0x09 => println!("ADD HL, BC"), 0x0A => println!("LD A, (BC)"), 0x0B => println!("DEC BC"), 0x0C => println!("INC C"), 0x0D => println!("DEC C"), 0x0E => println!("LD C, d8"), 0x0F => println!("RRCA"),
            0x10 => println!("STOP"), 0x11 => println!("LD DE, d16"), 0x12 => println!("LD (DE), A"), 0x13 => println!("INC DE"), 0x14 => println!("INC D"), 0x15 => println!("DEC D"), 0x16 => println!("LD D, d8"), 0x17 => println!("RLA"), 0x18 => println!("JR r8"), 0x19 => println!("ADD HL, DE"), 0x1A => println!("LD A, (DE)"), 0x1B => println!("DEC DE"), 0x1C => println!("INC E"), 0x1D => println!("DEC E"), 0x1E => println!("LD E, d8"), 0x1F => println!("RRA"),
            0x20 => println!("JR NZ, r8"), 0x21 => println!("LD HL, d16"), 0x22 => println!("LDI (HL), A"), 0x23 => println!("INC HL"), 0x24 => println!("INC H"), 0x25 => println!("DEC H"), 0x26 => println!("LD H, d8"), 0x27 => println!("DAA"), 0x28 => println!("JR Z, r8"), 0x29 => println!("ADD HL, HL"), 0x2A => println!("LDI A, (HL)"), 0x2B => println!("DEC HL"), 0x2C => println!("INC L"), 0x2D => println!("DEC L"), 0x2E => println!("LD L, d8"), 0x2F => println!("CPL"),
            0x30 => println!("JR NC, r8"), 0x31 => println!("LD SP, d16"), 0x32 => println!("LDD (HL), A"), 0x33 => println!("INC SP"), 0x34 => println!("INC (HL)"), 0x35 => println!("DEC (HL)"), 0x36 => println!("LD (HL), d8"), 0x37 => println!("SCF"), 0x38 => println!("JR C, r8"), 0x39 => println!("ADD HL, SP"), 0x3A => println!("LDD A, (HL)"), 0x3B => println!("DEC SP"), 0x3C => println!("INC A"), 0x3D => println!("DEC A"), 0x3E => println!("LD A, d8"), 0x3F => println!("CCF"),
            0x40 => println!("LD B, B"), 0x41 => println!("LD B, C"), 0x42 => println!("LD B, D"), 0x43 => println!("LD B, E"), 0x44 => println!("LD B, H"), 0x45 => println!("LD B, L"), 0x46 => println!("LD B, (HL)"), 0x47 => println!("LD B, A"), 0x48 => println!("LD C, B"), 0x49 => println!("LD C, C"), 0x4A => println!("LD C, D"), 0x4B => println!("LD C, E"), 0x4C => println!("LD C, H"), 0x4D => println!("LD C, L"), 0x4E => println!("LD C, (HL)"), 0x4F => println!("LD C, A"),
            0x50 => println!("LD D, B"), 0x51 => println!("LD D, C"), 0x52 => println!("LD D, D"), 0x53 => println!("LD D, E"), 0x54 => println!("LD D, H"), 0x55 => println!("LD D, L"), 0x56 => println!("LD D, (HL)"), 0x57 => println!("LD D, A"), 0x58 => println!("LD E, B"), 0x59 => println!("LD E, C"), 0x5A => println!("LD E, D"), 0x5B => println!("LD E, E"), 0x5C => println!("LD E, H"), 0x5D => println!("LD E, L"), 0x5E => println!("LD E, (HL)"), 0x5F => println!("LD E, A"),
            0x60 => println!("LD H, B"), 0x61 => println!("LD H, C"), 0x62 => println!("LD H, D"), 0x63 => println!("LD H, E"), 0x64 => println!("LD H, H"), 0x65 => println!("LD H, L"), 0x66 => println!("LD H, (HL)"), 0x67 => println!("LD H, A"), 0x68 => println!("LD L, B"), 0x69 => println!("LD L, C"), 0x6A => println!("LD L, D"), 0x6B => println!("LD L, E"), 0x6C => println!("LD L, H"), 0x6D => println!("LD L, L"), 0x6E => println!("LD L, (HL)"), 0x6F => println!("LD L, A"),
            0x70 => println!("LD (HL), B"), 0x71 => println!("LD (HL), C"), 0x72 => println!("LD (HL), D"), 0x73 => println!("LD (HL), E"), 0x74 => println!("LD (HL), H"), 0x75 => println!("LD (HL), L"), 0x76 => println!("HALT"), 0x77 => println!("LD (HL), A"), 0x78 => println!("LD A, B"), 0x79 => println!("LD A, C"), 0x7A => println!("LD A, D"), 0x7B => println!("LD A, E"), 0x7C => println!("LD A, H"), 0x7D => println!("LD A, L"), 0x7E => println!("LD A, (HL)"), 0x7F => println!("LD A, A"),
            0x80 => println!("ADD A, B"), 0x81 => println!("ADD A, C"), 0x82 => println!("ADD A, D"), 0x83 => println!("ADD A, E"), 0x84 => println!("ADD A, H"), 0x85 => println!("ADD A, L"), 0x86 => println!("ADD A, (HL)"), 0x87 => println!("ADD A, A"), 0x88 => println!("ADC A, B"), 0x89 => println!("ADC A, C"), 0x8A => println!("ADC A, D"), 0x8B => println!("ADC A, E"), 0x8C => println!("ADC A, H"), 0x8D => println!("ADC A, L"), 0x8E => println!("ADC A, (HL)"), 0x8F => println!("ADC A, A"),
            0x90 => println!("SUB B"), 0x91 => println!("SUB C"), 0x92 => println!("SUB D"), 0x93 => println!("SUB E"), 0x94 => println!("SUB H"), 0x95 => println!("SUB L"), 0x96 => println!("SUB (HL)"), 0x97 => println!("SUB A"), 0x98 => println!("SBC A, B"), 0x99 => println!("SBC A, C"), 0x9A => println!("SBC A, D"), 0x9B => println!("SBC A, E"), 0x9C => println!("SBC A, H"), 0x9D => println!("SBC A, L"), 0x9E => println!("SBC A, (HL)"), 0x9F => println!("SBC A, A"),
            0xA0 => println!("AND B"), 0xA1 => println!("AND C"), 0xA2 => println!("AND D"), 0xA3 => println!("AND E"), 0xA4 => println!("AND H"), 0xA5 => println!("AND L"), 0xA6 => println!("AND (HL)"), 0xA7 => println!("AND A"), 0xA8 => println!("XOR B"), 0xA9 => println!("XOR C"), 0xAA => println!("XOR D"), 0xAB => println!("XOR E"), 0xAC => println!("XOR H"), 0xAD => println!("XOR L"), 0xAE => println!("XOR (HL)"), 0xAF => println!("XOR A"),
            0xB0 => println!("OR B"), 0xB1 => println!("OR C"), 0xB2 => println!("OR D"), 0xB3 => println!("OR E"), 0xB4 => println!("OR H"), 0xB5 => println!("OR L"), 0xB6 => println!("OR (HL)"), 0xB7 => println!("OR A"), 0xB8 => println!("CP B"), 0xB9 => println!("CP C"), 0xBA => println!("CP D"), 0xBB => println!("CP E"), 0xBC => println!("CP H"), 0xBD => println!("CP L"), 0xBE => println!("CP (HL)"), 0xBF => println!("CP A"),
            0xC0 => println!("RET NZ"), 0xC1 => println!("POP BC"), 0xC2 => println!("JP NZ, a16"), 0xC3 => println!("JP a16"), 0xC4 => println!("CALL NZ, a16"), 0xC5 => println!("PUSH BC"), 0xC6 => println!("ADD A, d8"), 0xC7 => println!("RST 00H"), 0xC8 => println!("RET Z"), 0xC9 => println!("RET"), 0xCA => println!("JP Z, a16"), 0xCC => println!("CALL Z, a16"), 0xCD => println!("CALL a16"), 0xCE => println!("ADC A, d8"), 0xCF => println!("RST 08H"),
            0xD0 => println!("RET NC"), 0xD1 => println!("POP DE"), 0xD2 => println!("JP NC, a16"), 0xD4 => println!("CALL NC, a16"), 0xD5 => println!("PUSH DE"), 0xD6 => println!("SUB d8"), 0xD7 => println!("RST 10H"), 0xD8 => println!("RET C"), 0xD9 => println!("RETI"), 0xDA => println!("JP C, a16"), 0xDC => println!("CALL C, a16"), 0xDE => println!("SBC A, d8"), 0xDF => println!("RST 18H"),
            0xE0 => println!("LDH (a8), A"), 0xE1 => println!("POP HL"), 0xE2 => println!("LD (C), A"), 0xE5 => println!("PUSH HL"), 0xE6 => println!("AND d8"), 0xE7 => println!("RST 20H"), 0xE8 => println!("ADD SP, r8"), 0xE9 => println!("JP (HL)"), 0xEA => println!("LD (a16), A"), 0xEE => println!("XOR d8"), 0xEF => println!("RST 28H"),
            0xF0 => println!("LDH A, (a8)"), 0xF1 => println!("POP AF"), 0xF2 => println!("LD A, (C)"), 0xF3 => println!("DI"), 0xF5 => println!("PUSH AF"), 0xF6 => println!("OR d8"), 0xF7 => println!("RST 30H"), 0xF8 => println!("LD HL, SP+r8"), 0xF9 => println!("LD SP, HL"), 0xFA => println!("LD A, (a16)"), 0xFB => println!("EI"), 0xFE => println!("CP d8"), 0xFF => println!("RST 38H"),
            _ => {}
        }
    }

    fn print_debug_prefixed(byte: u8) {
        match byte {
            0x00 => println!("Prefix: RLC B"), 0x01 => println!("Prefix: RLC C"), 0x02 => println!("Prefix: RLC D"), 0x03 => println!("Prefix: RLC E"), 0x04 => println!("Prefix: RLC H"), 0x05 => println!("Prefix: RLC L"), 0x06 => println!("Prefix: RLC (HL)"), 0x07 => println!("Prefix: RLC A"), 0x08 => println!("Prefix: RRC B"), 0x09 => println!("Prefix: RRC C"), 0x0a => println!("Prefix: RRC D"), 0x0b => println!("Prefix: RRC E"), 0x0c => println!("Prefix: RRC H"), 0x10 => println!("Prefix: RL B"), 0x11 => println!("Prefix: RL C"), 0x12 => println!("Prefix: RL D"),
            0x13 => println!("Prefix: RL E"), 0x14 => println!("Prefix: RL H"), 0x15 => println!("Prefix: RL L"), 0x16 => println!("Prefix: RL (HL)"), 0x17 => println!("Prefix: RL A"), 0x18 => println!("Prefix: RR B"), 0x19 => println!("Prefix: RR C"), 0x1a => println!("Prefix: RR D"), 0x1b => println!("Prefix: RR E"), 0x0d => println!("Prefix: Prefix: RRC L"), 0x0e => println!("Prefix: Prefix: RRC (HL)"), 0x0f => println!("Prefix: Prefix: RRC A"), 0x1c => println!("Prefix: RR H"), 0x1d => println!("Prefix: RR L"), 0x1e => println!("Prefix: RR (HL)"), 0x1f => println!("Prefix: RR A"),
            0x20 => println!("Prefix: SLA B"), 0x21 => println!("Prefix: SLA C"), 0x22 => println!("Prefix: SLA D"), 0x23 => println!("Prefix: SLA E"), 0x24 => println!("Prefix: SLA H"), 0x25 => println!("Prefix: SLA L"), 0x26 => println!("Prefix: SLA (HL)"), 0x27 => println!("Prefix: SLA A"), 0x28 => println!("Prefix: SRA B"), 0x29 => println!("Prefix: SRA C"), 0x2a => println!("Prefix: SRA D"), 0x2b => println!("Prefix: SRA E"), 0x2c => println!("Prefix: SRA H"), 0x2d => println!("Prefix: SRA L"), 0x2e => println!("Prefix: SRA (HL)"), 0x2f => println!("Prefix: SRA A"),
            0x30 => println!("Prefix: SWAP B"), 0x31 => println!("Prefix: SWAP C"), 0x32 => println!("Prefix: SWAP D"), 0x33 => println!("Prefix: SWAP E"), 0x34 => println!("Prefix: SWAP H"), 0x35 => println!("Prefix: SWAP L"), 0x36 => println!("Prefix: SWAP (HL)"), 0x37 => println!("Prefix: SWAP A"), 0x38 => println!("Prefix: SRL B"), 0x39 => println!("Prefix: SRL C"), 0x3a => println!("Prefix: SRL D"), 0x3b => println!("Prefix: SRL E"), 0x3c => println!("Prefix: SRL H"), 0x3d => println!("Prefix: SRL L"), 0x3e => println!("Prefix: SRL (HL)"), 0x3f => println!("Prefix: SRL A"),
            0x40 => println!("Prefix: BIT 0, B"), 0x41 => println!("Prefix: BIT 0, C"), 0x42 => println!("Prefix: BIT 0, D"), 0x43 => println!("Prefix: BIT 0, E"), 0x44 => println!("Prefix: BIT 0, H"), 0x45 => println!("Prefix: BIT 0, L"), 0x46 => println!("Prefix: BIT 0, (HL)"), 0x47 => println!("Prefix: BIT 0, A"), 0x48 => println!("Prefix: BIT 1, B"), 0x49 => println!("Prefix: BIT 1, C"), 0x4a => println!("Prefix: BIT 1, D"), 0x4b => println!("Prefix: BIT 1, E"), 0x4c => println!("Prefix: BIT 1, H"), 0x4d => println!("Prefix: BIT 1, L"), 0x4e => println!("Prefix: BIT 1, (HL)"), 0x4f => println!("Prefix: BIT 1, A"),
            0x50 => println!("Prefix: BIT 2, B"), 0x51 => println!("Prefix: BIT 2, C"), 0x52 => println!("Prefix: BIT 2, D"), 0x53 => println!("Prefix: BIT 2, E"), 0x54 => println!("Prefix: BIT 2, H"), 0x55 => println!("Prefix: BIT 2, L"), 0x56 => println!("Prefix: BIT 2, (HL)"), 0x57 => println!("Prefix: BIT 2, A"), 0x58 => println!("Prefix: BIT 3, B"), 0x59 => println!("Prefix: BIT 3, C"), 0x5a => println!("Prefix: BIT 3, D"), 0x5b => println!("Prefix: BIT 3, E"), 0x5c => println!("Prefix: BIT 3, H"), 0x5d => println!("Prefix: BIT 3, L"), 0x5e => println!("Prefix: BIT 3, (HL)"), 0x5f => println!("Prefix: BIT 3, A"),
            0x60 => println!("Prefix: BIT 4, B"), 0x61 => println!("Prefix: BIT 4, C"), 0x62 => println!("Prefix: BIT 4, D"), 0x63 => println!("Prefix: BIT 4, E"), 0x64 => println!("Prefix: BIT 4, H"), 0x65 => println!("Prefix: BIT 4, L"), 0x66 => println!("Prefix: BIT 4, (HL)"), 0x67 => println!("Prefix: BIT 4, A"), 0x68 => println!("Prefix: BIT 5, B"), 0x69 => println!("Prefix: BIT 5, C"), 0x6a => println!("Prefix: BIT 5, D"), 0x6b => println!("Prefix: BIT 5, E"), 0x6c => println!("Prefix: BIT 5, H"), 0x6d => println!("Prefix: BIT 5, L"), 0x6e => println!("Prefix: BIT 5, (HL)"), 0x6f => println!("Prefix: BIT 5, A"),
            0x70 => println!("Prefix: BIT 6, B"), 0x71 => println!("Prefix: BIT 6, C"), 0x72 => println!("Prefix: BIT 6, D"), 0x73 => println!("Prefix: BIT 6, E"), 0x74 => println!("Prefix: BIT 6, H"), 0x75 => println!("Prefix: BIT 6, L"), 0x76 => println!("Prefix: BIT 6, (HL)"), 0x77 => println!("Prefix: BIT 6, A"), 0x78 => println!("Prefix: BIT 7, B"), 0x79 => println!("Prefix: BIT 7, C"), 0x7a => println!("Prefix: BIT 7, D"), 0x7b => println!("Prefix: BIT 7, E"), 0x7c => println!("Prefix: BIT 7, H"), 0x7d => println!("Prefix: BIT 7, L"), 0x7e => println!("Prefix: BIT 7, (HL)"), 0x7f => println!("Prefix: BIT 7, A"),
            0x80 => println!("Prefix: RES 0, B"), 0x81 => println!("Prefix: RES 0, C"), 0x82 => println!("Prefix: RES 0, D"), 0x83 => println!("Prefix: RES 0, E"), 0x84 => println!("Prefix: RES 0, H"), 0x85 => println!("Prefix: RES 0, L"), 0x86 => println!("Prefix: RES 0, (HL)"), 0x87 => println!("Prefix: RES 0, A"), 0x88 => println!("Prefix: RES 1, B"), 0x89 => println!("Prefix: RES 1, C"), 0x8a => println!("Prefix: RES 1, D"), 0x8b => println!("Prefix: RES 1, E"), 0x8c => println!("Prefix: RES 1, H"), 0x8d => println!("Prefix: RES 1, L"), 0x8e => println!("Prefix: RES 1, (HL)"), 0x8f => println!("Prefix: RES 1, A"),
            0x90 => println!("Prefix: RES 2, B"), 0x91 => println!("Prefix: RES 2, C"), 0x92 => println!("Prefix: RES 2, D"), 0x93 => println!("Prefix: RES 2, E"), 0x94 => println!("Prefix: RES 2, H"), 0x95 => println!("Prefix: RES 2, L"), 0x96 => println!("Prefix: RES 2, (HL)"), 0x97 => println!("Prefix: RES 2, A"), 0x98 => println!("Prefix: RES 3, B"), 0x99 => println!("Prefix: RES 3, C"), 0x9a => println!("Prefix: RES 3, D"), 0x9b => println!("Prefix: RES 3, E"), 0x9c => println!("Prefix: RES 3, H"), 0x9d => println!("Prefix: RES 3, L"), 0x9e => println!("Prefix: RES 3, (HL)"), 0x9f => println!("Prefix: RES 3, A"),
            0xa0 => println!("Prefix: RES 4, B"), 0xa1 => println!("Prefix: RES 4, C"), 0xa2 => println!("Prefix: RES 4, D"), 0xa3 => println!("Prefix: RES 4, E"), 0xa4 => println!("Prefix: RES 4, H"), 0xa5 => println!("Prefix: RES 4, L"), 0xa6 => println!("Prefix: RES 4, (HL)"), 0xa7 => println!("Prefix: RES 4, A"), 0xa8 => println!("Prefix: RES 5, B"), 0xa9 => println!("Prefix: RES 5, C"), 0xaa => println!("Prefix: RES 5, D"), 0xab => println!("Prefix: RES 5, E"), 0xac => println!("Prefix: RES 5, H"), 0xad => println!("Prefix: RES 5, L"), 0xae => println!("Prefix: RES 5, (HL)"), 0xaf => println!("Prefix: RES 5, A"),
            0xb0 => println!("Prefix: RES 6, B"), 0xb1 => println!("Prefix: RES 6, C"), 0xb2 => println!("Prefix: RES 6, D"), 0xb3 => println!("Prefix: RES 6, E"), 0xb4 => println!("Prefix: RES 6, H"), 0xb5 => println!("Prefix: RES 6, L"), 0xb6 => println!("Prefix: RES 6, (HL)"), 0xb7 => println!("Prefix: RES 6, A"), 0xb8 => println!("Prefix: RES 7, B"), 0xb9 => println!("Prefix: RES 7, C"), 0xba => println!("Prefix: RES 7, D"), 0xbb => println!("Prefix: RES 7, E"), 0xbc => println!("Prefix: RES 7, H"), 0xbd => println!("Prefix: RES 7, L"), 0xbe => println!("Prefix: RES 7, (HL)"), 0xbf => println!("Prefix: RES 7, A"),
            0xc0 => println!("Prefix: SET 0, B"), 0xc1 => println!("Prefix: SET 0, C"), 0xc2 => println!("Prefix: SET 0, D"), 0xc3 => println!("Prefix: SET 0, E"), 0xc4 => println!("Prefix: SET 0, H"), 0xc5 => println!("Prefix: SET 0, L"), 0xc6 => println!("Prefix: SET 0, (HL)"), 0xc7 => println!("Prefix: SET 0, A"), 0xc8 => println!("Prefix: SET 1, B"), 0xc9 => println!("Prefix: SET 1, C"), 0xca => println!("Prefix: SET 1, D"), 0xcb => println!("Prefix: SET 1, E"), 0xcc => println!("Prefix: SET 1, H"), 0xcd => println!("Prefix: SET 1, L"), 0xce => println!("Prefix: SET 1, (HL)"), 0xcf => println!("Prefix: SET 1, A"),
            0xd0 => println!("Prefix: SET 2, B"), 0xd1 => println!("Prefix: SET 2, C"), 0xd2 => println!("Prefix: SET 2, D"), 0xd3 => println!("Prefix: SET 2, E"), 0xd4 => println!("Prefix: SET 2, H"), 0xd5 => println!("Prefix: SET 2, L"), 0xd6 => println!("Prefix: SET 2, (HL)"), 0xd7 => println!("Prefix: SET 2, A"), 0xd8 => println!("Prefix: SET 3, B"), 0xd9 => println!("Prefix: SET 3, C"), 0xda => println!("Prefix: SET 3, D"), 0xdb => println!("Prefix: SET 3, E"), 0xdc => println!("Prefix: SET 3, H"), 0xdd => println!("Prefix: SET 3, L"), 0xde => println!("Prefix: SET 3, (HL)"), 0xdf => println!("Prefix: SET 3, A"),
            0xe0 => println!("Prefix: SET 4, B"), 0xe1 => println!("Prefix: SET 4, C"), 0xe2 => println!("Prefix: SET 4, D"), 0xe3 => println!("Prefix: SET 4, E"), 0xe4 => println!("Prefix: SET 4, H"), 0xe5 => println!("Prefix: SET 4, L"), 0xe6 => println!("Prefix: SET 4, (HL)"), 0xe7 => println!("Prefix: SET 4, A"), 0xe8 => println!("Prefix: SET 5, B"), 0xe9 => println!("Prefix: SET 5, C"), 0xea => println!("Prefix: SET 5, D"), 0xeb => println!("Prefix: SET 5, E"), 0xec => println!("Prefix: SET 5, H"), 0xed => println!("Prefix: SET 5, L"), 0xee => println!("Prefix: SET 5, (HL)"), 0xef => println!("Prefix: SET 5, A"),
            0xf0 => println!("Prefix: SET 6, B"), 0xf1 => println!("Prefix: SET 6, C"), 0xf2 => println!("Prefix: SET 6, D"), 0xf3 => println!("Prefix: SET 6, E"), 0xf4 => println!("Prefix: SET 6, H"), 0xf5 => println!("Prefix: SET 6, L"), 0xf6 => println!("Prefix: SET 6, (HL)"), 0xf7 => println!("Prefix: SET 6, A"), 0xf8 => println!("Prefix: SET 7, B"), 0xf9 => println!("Prefix: SET 7, C"), 0xfa => println!("Prefix: SET 7, D"), 0xfb => println!("Prefix: SET 7, E"), 0xfc => println!("Prefix: SET 7, H"), 0xfd => println!("Prefix: SET 7, L"), 0xfe => println!("Prefix: SET 7, (HL)"), 0xff => println!("Prefix: SET 7, A"),
            _ => {}
        }
    }

    fn from_byte_not_prefixed(byte: u8) -> Option<Instruction> {
        match byte {
            // FIST ROW -> 0x0.
            0x00 => Some(Instruction::NOP),
            0x01 => Some(Instruction::LD(LoadType::Word(LoadWordTarget::BC, LoadWordSource::D16))),
            0x02 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::BCI, LoadByteSource::A))),
            0x03 => Some(Instruction::INC(IncDecTarget::BC)),
            0x04 => Some(Instruction::INC(IncDecTarget::B)),
            0x05 => Some(Instruction::DEC(IncDecTarget::B)),
            0x06 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::B, LoadByteSource::D8))),
            0x07 => Some(Instruction::RLCA),
            0x08 => Some(Instruction::LD(LoadType::Word(LoadWordTarget::A16I, LoadWordSource::SP))),
            0x09 => Some(Instruction::ADD(AddType::ToHL(Arithmetic16Target::BC))),
            0x0a => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::BCI))),
            0x0b => Some(Instruction::DEC(IncDecTarget::BC)),
            0x0c => Some(Instruction::INC(IncDecTarget::C)),
            0x0d => Some(Instruction::DEC(IncDecTarget::C)),
            0x0e => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::C, LoadByteSource::D8))),
            0x0f => Some(Instruction::RRCA),


            // SECOND ROW -> 0x1.
            0x10 => Some(Instruction::STOP),
            0x11 => Some(Instruction::LD(LoadType::Word(LoadWordTarget::DE, LoadWordSource::D16))),
            0x12 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::HLI, LoadByteSource::A))),
            0x13 => Some(Instruction::INC(IncDecTarget::DE)),
            0x14 => Some(Instruction::INC(IncDecTarget::D)),
            0x15 => Some(Instruction::DEC(IncDecTarget::D)),
            0x16 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::D, LoadByteSource::D8))),
            0x17 => Some(Instruction::RLA),
            0x18 => Some(Instruction::JR(JumpTest::Always)),
            0x19 => Some(Instruction::ADD(AddType::ToHL(Arithmetic16Target::DE))),
            0x1a => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::DEI))),
            0x1b => Some(Instruction::DEC(IncDecTarget::DE)),
            0x1c => Some(Instruction::INC(IncDecTarget::E)),
            0x1d => Some(Instruction::DEC(IncDecTarget::E)),
            0x1e => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::E, LoadByteSource::D8))),
            0x1f => Some(Instruction::RRA),


            // THIRD ROW -> 0x2.
            0x20 => Some(Instruction::JR(JumpTest::NotZero)),
            0x21 => Some(Instruction::LD(LoadType::Word(LoadWordTarget::HL, LoadWordSource::D16))),
            0x22 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::HLIInc, LoadByteSource::A))),
            0x23 => Some(Instruction::INC(IncDecTarget::HL)),
            0x24 => Some(Instruction::INC(IncDecTarget::H)),
            0x25 => Some(Instruction::DEC(IncDecTarget::H)),
            0x26 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::H, LoadByteSource::D8))),
            0x27 => Some(Instruction::DAA),
            0x28 => Some(Instruction::JR(JumpTest::Zero)),
            0x29 => Some(Instruction::ADD(AddType::ToHL(Arithmetic16Target::HL))),
            0x2a => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::HLIInc))),
            0x2b => Some(Instruction::DEC(IncDecTarget::HL)),
            0x2c => Some(Instruction::INC(IncDecTarget::L)),
            0x2d => Some(Instruction::DEC(IncDecTarget::L)),
            0x2e => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::L, LoadByteSource::D8))),
            0x2f => Some(Instruction::CPL),


            // FOURTH ROW -> 0x3.
            0x30 => Some(Instruction::JR(JumpTest::NotCarry)),
            0x31 => Some(Instruction::LD(LoadType::Word(LoadWordTarget::SP, LoadWordSource::D16))),
            0x32 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::HLIDec, LoadByteSource::A))),
            0x33 => Some(Instruction::INC(IncDecTarget::SP)),
            0x34 => Some(Instruction::INC(IncDecTarget::HLI)),
            0x35 => Some(Instruction::DEC(IncDecTarget::HLI)),
            0x36 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::HLI, LoadByteSource::D8))),
            0x37 => Some(Instruction::SCF),
            0x38 => Some(Instruction::JR(JumpTest::Carry)),
            0x39 => Some(Instruction::ADD(AddType::ToHL(Arithmetic16Target::SP))),
            0x3a => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::HLIDec))),
            0x3b => Some(Instruction::DEC(IncDecTarget::SP)),
            0x3c => Some(Instruction::INC(IncDecTarget::A)),
            0x3d => Some(Instruction::DEC(IncDecTarget::A)),
            0x3e => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::D8))),
            0x3f => Some(Instruction::CCF),


            // FIFTH ROW -> 0x4.
            0x40 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::B, LoadByteSource::B))),
            0x41 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::B, LoadByteSource::C))),
            0x42 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::B, LoadByteSource::D))),
            0x43 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::B, LoadByteSource::E))),
            0x44 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::B, LoadByteSource::H))),
            0x45 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::B, LoadByteSource::L))),
            0x46 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::B, LoadByteSource::HLI))),
            0x47 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::B, LoadByteSource::A))),
            0x48 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::C, LoadByteSource::B))),
            0x49 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::C, LoadByteSource::C))),
            0x4a => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::C, LoadByteSource::D))),
            0x4b => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::C, LoadByteSource::E))),
            0x4c => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::C, LoadByteSource::H))),
            0x4d => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::C, LoadByteSource::L))),
            0x4e => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::C, LoadByteSource::HLI))),
            0x4f => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::C, LoadByteSource::A))),


            // SIXTH ROW -> 0x5.
            0x50 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::D, LoadByteSource::B))),
            0x51 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::D, LoadByteSource::C))),
            0x52 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::D, LoadByteSource::D))),
            0x53 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::D, LoadByteSource::E))),
            0x54 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::D, LoadByteSource::H))),
            0x55 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::D, LoadByteSource::L))),
            0x56 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::D, LoadByteSource::HLI))),
            0x57 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::D, LoadByteSource::A))),
            0x58 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::E, LoadByteSource::B))),
            0x59 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::E, LoadByteSource::C))),
            0x5a => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::E, LoadByteSource::D))),
            0x5b => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::E, LoadByteSource::E))),
            0x5c => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::E, LoadByteSource::H))),
            0x5d => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::E, LoadByteSource::L))),
            0x5e => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::E, LoadByteSource::HLI))),
            0x5f => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::E, LoadByteSource::A))),


            // SEVENTH ROW -> 0x6.
            0x60 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::H, LoadByteSource::B))),
            0x61 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::H, LoadByteSource::C))),
            0x62 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::H, LoadByteSource::D))),
            0x63 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::H, LoadByteSource::E))),
            0x64 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::H, LoadByteSource::H))),
            0x65 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::H, LoadByteSource::L))),
            0x66 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::H, LoadByteSource::HLI))),
            0x67 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::H, LoadByteSource::A))),
            0x68 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::L, LoadByteSource::B))),
            0x69 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::L, LoadByteSource::C))),
            0x6a => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::L, LoadByteSource::D))),
            0x6b => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::L, LoadByteSource::E))),
            0x6c => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::L, LoadByteSource::H))),
            0x6d => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::L, LoadByteSource::L))),
            0x6e => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::L, LoadByteSource::HLI))),
            0x6f => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::L, LoadByteSource::A))),


            // EIGHTH ROW -> 0x7.
            0x70 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::HLI, LoadByteSource::B))),
            0x71 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::HLI, LoadByteSource::C))),
            0x72 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::HLI, LoadByteSource::D))),
            0x73 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::HLI, LoadByteSource::E))),
            0x74 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::HLI, LoadByteSource::H))),
            0x75 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::HLI, LoadByteSource::L))),
            0x76 => Some(Instruction::HALT),
            0x77 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::HLI, LoadByteSource::A))),
            0x78 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::B))),
            0x79 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::C))),
            0x7a => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::D))),
            0x7b => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::E))),
            0x7c => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::H))),
            0x7d => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::L))),
            0x7e => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::HLI))),
            0x7f => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::A))),


            // NINTH ROW -> 0x8.
            0x80 => Some(Instruction::ADD(ToA(ArithmeticTarget::B))),
            0x81 => Some(Instruction::ADD(ToA(ArithmeticTarget::C))),
            0x82 => Some(Instruction::ADD(ToA(ArithmeticTarget::D))),
            0x83 => Some(Instruction::ADD(ToA(ArithmeticTarget::E))),
            0x84 => Some(Instruction::ADD(ToA(ArithmeticTarget::H))),
            0x85 => Some(Instruction::ADD(ToA(ArithmeticTarget::L))),
            0x86 => Some(Instruction::ADD(ToA(ArithmeticTarget::HLI))),
            0x87 => Some(Instruction::ADD(ToA(ArithmeticTarget::A))),
            0x88 => Some(Instruction::ADC(ArithmeticTarget::B)),
            0x89 => Some(Instruction::ADC(ArithmeticTarget::C)),
            0x8a => Some(Instruction::ADC(ArithmeticTarget::D)),
            0x8b => Some(Instruction::ADC(ArithmeticTarget::E)),
            0x8c => Some(Instruction::ADC(ArithmeticTarget::H)),
            0x8d => Some(Instruction::ADC(ArithmeticTarget::L)),
            0x8e => Some(Instruction::ADC(ArithmeticTarget::HLI)),
            0x8f => Some(Instruction::ADC(ArithmeticTarget::A)),


            // TENTH ROW -> 0x9.
            0x90 => Some(Instruction::SUB(ArithmeticTarget::B)),
            0x91 => Some(Instruction::SUB(ArithmeticTarget::C)),
            0x92 => Some(Instruction::SUB(ArithmeticTarget::D)),
            0x93 => Some(Instruction::SUB(ArithmeticTarget::E)),
            0x94 => Some(Instruction::SUB(ArithmeticTarget::H)),
            0x95 => Some(Instruction::SUB(ArithmeticTarget::L)),
            0x96 => Some(Instruction::SUB(ArithmeticTarget::HLI)),
            0x97 => Some(Instruction::SUB(ArithmeticTarget::A)),
            0x98 => Some(Instruction::SBC(ArithmeticTarget::B)),
            0x99 => Some(Instruction::SBC(ArithmeticTarget::C)),
            0x9a => Some(Instruction::SBC(ArithmeticTarget::D)),
            0x9b => Some(Instruction::SBC(ArithmeticTarget::E)),
            0x9c => Some(Instruction::SBC(ArithmeticTarget::H)),
            0x9d => Some(Instruction::SBC(ArithmeticTarget::L)),
            0x9e => Some(Instruction::SBC(ArithmeticTarget::HLI)),
            0x9f => Some(Instruction::SBC(ArithmeticTarget::A)),


            // ELEVENTH ROW -> 0xa.
            0xa0 => Some(Instruction::AND(ArithmeticTarget::B)),
            0xa1 => Some(Instruction::AND(ArithmeticTarget::C)),
            0xa2 => Some(Instruction::AND(ArithmeticTarget::D)),
            0xa3 => Some(Instruction::AND(ArithmeticTarget::E)),
            0xa4 => Some(Instruction::AND(ArithmeticTarget::H)),
            0xa5 => Some(Instruction::AND(ArithmeticTarget::L)),
            0xa6 => Some(Instruction::AND(ArithmeticTarget::HLI)),
            0xa7 => Some(Instruction::AND(ArithmeticTarget::A)),
            0xa8 => Some(Instruction::XOR(ArithmeticTarget::B)),
            0xa9 => Some(Instruction::XOR(ArithmeticTarget::C)),
            0xaa => Some(Instruction::XOR(ArithmeticTarget::D)),
            0xab => Some(Instruction::XOR(ArithmeticTarget::E)),
            0xac => Some(Instruction::XOR(ArithmeticTarget::H)),
            0xad => Some(Instruction::XOR(ArithmeticTarget::L)),
            0xae => Some(Instruction::XOR(ArithmeticTarget::HLI)),
            0xaf => Some(Instruction::XOR(ArithmeticTarget::A)),


            // TWELFTH ROW -> 0xb.
            0xb0 => Some(Instruction::OR(ArithmeticTarget::B)),
            0xb1 => Some(Instruction::OR(ArithmeticTarget::C)),
            0xb2 => Some(Instruction::OR(ArithmeticTarget::D)),
            0xb3 => Some(Instruction::OR(ArithmeticTarget::E)),
            0xb4 => Some(Instruction::OR(ArithmeticTarget::H)),
            0xb5 => Some(Instruction::OR(ArithmeticTarget::L)),
            0xb6 => Some(Instruction::OR(ArithmeticTarget::HLI)),
            0xb7 => Some(Instruction::OR(ArithmeticTarget::A)),
            0xb8 => Some(Instruction::CP(ArithmeticTarget::B)),
            0xb9 => Some(Instruction::CP(ArithmeticTarget::C)),
            0xba => Some(Instruction::CP(ArithmeticTarget::D)),
            0xbb => Some(Instruction::CP(ArithmeticTarget::E)),
            0xbc => Some(Instruction::CP(ArithmeticTarget::H)),
            0xbd => Some(Instruction::CP(ArithmeticTarget::L)),
            0xbe => Some(Instruction::CP(ArithmeticTarget::HLI)),
            0xbf => Some(Instruction::CP(ArithmeticTarget::A)),


            // THIRTEENTH ROW -> 0xc.
            0xc0 => Some(Instruction::RET(JumpTest::NotZero)),
            0xc1 => Some(Instruction::POP(StackTarget::BC)),
            0xc2 => Some(Instruction::JP(JumpTestWithHLI::NotZero)),
            0xc3 => Some(Instruction::JP(JumpTestWithHLI::Always)),
            0xc4 => Some(Instruction::CALL(JumpTest::NotZero)),
            0xc5 => Some(Instruction::PUSH(StackTarget::BC)),
            0xc6 => Some(Instruction::ADD(ToA(ArithmeticTarget::D8))),
            0xc7 => Some(Instruction::RST(RstTarget::H00)),
            0xc8 => Some(Instruction::RET(JumpTest::Zero)),
            0xc9 => Some(Instruction::RET(JumpTest::Always)),
            0xca => Some(Instruction::JP(JumpTestWithHLI::Zero)),
            0xcc => Some(Instruction::CALL(JumpTest::Zero)),
            0xcd => Some(Instruction::CALL(JumpTest::Always)),
            0xce => Some(Instruction::ADC(ArithmeticTarget::D8)),
            0xcf => Some(Instruction::RST(RstTarget::H08)),


            // FOURTEENTH ROW -> 0xd.
            0xd0 => Some(Instruction::RET(JumpTest::NotCarry)),
            0xd1 => Some(Instruction::POP(StackTarget::DE)),
            0xd2 => Some(Instruction::JP(JumpTestWithHLI::NotCarry)),
            0xd4 => Some(Instruction::CALL(JumpTest::NotCarry)),
            0xd5 => Some(Instruction::PUSH(StackTarget::DE)),
            0xd6 => Some(Instruction::SUB(ArithmeticTarget::D8)),
            0xd7 => Some(Instruction::RST(RstTarget::H10)),
            0xd8 => Some(Instruction::RET(JumpTest::Carry)),
            0xd9 => Some(Instruction::RETI),
            0xda => Some(Instruction::JP(JumpTestWithHLI::Carry)),
            0xdc => Some(Instruction::CALL(JumpTest::Carry)),
            0xde => Some(Instruction::SBC(ArithmeticTarget::D8)),
            0xdf => Some(Instruction::RST(RstTarget::H18)),


            // FIFTEENTH ROW -> 0xe.
            0xe0 => Some(Instruction::LDH_A_to_A8I),
            0xe1 => Some(Instruction::POP(StackTarget::HL)),
            0xe2 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::CI, LoadByteSource::A))),
            0xe5 => Some(Instruction::PUSH(StackTarget::HL)),
            0xe6 => Some(Instruction::AND(ArithmeticTarget::D8)),
            0xe7 => Some(Instruction::RST(RstTarget::H20)),
            0xe8 => Some(Instruction::ADD(AddType::ToSP)),
            0xe9 => Some(Instruction::JP(JumpTestWithHLI::HLI)),
            0xea => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A16I, LoadByteSource::A))),
            0xee => Some(Instruction::XOR(ArithmeticTarget::D8)),
            0xef => Some(Instruction::RST(RstTarget::H28)),


            // SIXTEENTH ROW -> 0xf.
            0xf0 => Some(Instruction::LDH_A8I_to_A),
            0xf1 => Some(Instruction::POP(StackTarget::AF)),
            0xf2 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::CI))),
            0xf3 => Some(Instruction::DI),
            0xf5 => Some(Instruction::PUSH(StackTarget::AF)),
            0xf6 => Some(Instruction::OR(ArithmeticTarget::D8)),
            0xf7 => Some(Instruction::RST(RstTarget::H30)),
            0xf8 => Some(Instruction::LD(LoadType::Word(LoadWordTarget::HL, LoadWordSource::SPPlusD8))),
            0xf9 => Some(Instruction::LD(LoadType::Word(LoadWordTarget::SP, LoadWordSource::HL))),
            0xfa => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::A16I))),
            0xfb => Some(Instruction::EI),
            0xfe => Some(Instruction::CP(ArithmeticTarget::D8)),
            0xff => Some(Instruction::RST(RstTarget::H38)),

            _ => panic!("Unknown instruction: {:x}", byte)
        }
    }

    fn from_byte_prefixed(byte: u8) -> Option<Instruction> {
        match byte {
            // FIRST ROW -> 0x0.
            0x00 => Some(Instruction::RLC(PrefixTarget::B)),
            0x01 => Some(Instruction::RLC(PrefixTarget::C)),
            0x02 => Some(Instruction::RLC(PrefixTarget::D)),
            0x03 => Some(Instruction::RLC(PrefixTarget::E)),
            0x04 => Some(Instruction::RLC(PrefixTarget::H)),
            0x05 => Some(Instruction::RLC(PrefixTarget::L)),
            0x06 => Some(Instruction::RLC(PrefixTarget::HLI)),
            0x07 => Some(Instruction::RLC(PrefixTarget::A)),
            0x08 => Some(Instruction::RRC(PrefixTarget::B)),
            0x09 => Some(Instruction::RRC(PrefixTarget::C)),
            0x0a => Some(Instruction::RRC(PrefixTarget::D)),
            0x0b => Some(Instruction::RRC(PrefixTarget::E)),
            0x0c => Some(Instruction::RRC(PrefixTarget::H)),
            0x0d => Some(Instruction::RRC(PrefixTarget::L)),
            0x0e => Some(Instruction::RRC(PrefixTarget::HLI)),
            0x0f => Some(Instruction::RRC(PrefixTarget::A)),


            // SECOND ROW -> 0x1.
            0x10 => Some(Instruction::RL(PrefixTarget::B)),
            0x11 => Some(Instruction::RL(PrefixTarget::C)),
            0x12 => Some(Instruction::RL(PrefixTarget::D)),
            0x13 => Some(Instruction::RL(PrefixTarget::E)),
            0x14 => Some(Instruction::RL(PrefixTarget::H)),
            0x15 => Some(Instruction::RL(PrefixTarget::L)),
            0x16 => Some(Instruction::RL(PrefixTarget::HLI)),
            0x17 => Some(Instruction::RL(PrefixTarget::A)),
            0x18 => Some(Instruction::RR(PrefixTarget::B)),
            0x19 => Some(Instruction::RR(PrefixTarget::C)),
            0x1a => Some(Instruction::RR(PrefixTarget::D)),
            0x1b => Some(Instruction::RR(PrefixTarget::E)),
            0x1c => Some(Instruction::RR(PrefixTarget::H)),
            0x1d => Some(Instruction::RR(PrefixTarget::L)),
            0x1e => Some(Instruction::RR(PrefixTarget::HLI)),
            0x1f => Some(Instruction::RR(PrefixTarget::A)),


            // THIRD ROW -> 0x2.
            0x20 => Some(Instruction::SLA(PrefixTarget::B)),
            0x21 => Some(Instruction::SLA(PrefixTarget::C)),
            0x22 => Some(Instruction::SLA(PrefixTarget::D)),
            0x23 => Some(Instruction::SLA(PrefixTarget::E)),
            0x24 => Some(Instruction::SLA(PrefixTarget::H)),
            0x25 => Some(Instruction::SLA(PrefixTarget::L)),
            0x26 => Some(Instruction::SLA(PrefixTarget::HLI)),
            0x27 => Some(Instruction::SLA(PrefixTarget::A)),
            0x28 => Some(Instruction::SRA(PrefixTarget::B)),
            0x29 => Some(Instruction::SRA(PrefixTarget::C)),
            0x2a => Some(Instruction::SRA(PrefixTarget::D)),
            0x2b => Some(Instruction::SRA(PrefixTarget::E)),
            0x2c => Some(Instruction::SRA(PrefixTarget::H)),
            0x2d => Some(Instruction::SRA(PrefixTarget::L)),
            0x2e => Some(Instruction::SRA(PrefixTarget::HLI)),
            0x2f => Some(Instruction::SRA(PrefixTarget::A)),


            // FOURTH ROW -> 0x3.
            0x30 => Some(Instruction::SWAP(PrefixTarget::B)),
            0x31 => Some(Instruction::SWAP(PrefixTarget::C)),
            0x32 => Some(Instruction::SWAP(PrefixTarget::D)),
            0x33 => Some(Instruction::SWAP(PrefixTarget::E)),
            0x34 => Some(Instruction::SWAP(PrefixTarget::H)),
            0x35 => Some(Instruction::SWAP(PrefixTarget::L)),
            0x36 => Some(Instruction::SWAP(PrefixTarget::HLI)),
            0x37 => Some(Instruction::SWAP(PrefixTarget::A)),
            0x38 => Some(Instruction::SRL(PrefixTarget::B)),
            0x39 => Some(Instruction::SRL(PrefixTarget::C)),
            0x3a => Some(Instruction::SRL(PrefixTarget::D)),
            0x3b => Some(Instruction::SRL(PrefixTarget::E)),
            0x3c => Some(Instruction::SRL(PrefixTarget::H)),
            0x3d => Some(Instruction::SRL(PrefixTarget::L)),
            0x3e => Some(Instruction::SRL(PrefixTarget::HLI)),
            0x3f => Some(Instruction::SRL(PrefixTarget::A)),


            // FIFTH ROW -> 0x4.
            0x40 => Some(Instruction::BIT(PrefixU8::U0, PrefixTarget::B)),
            0x41 => Some(Instruction::BIT(PrefixU8::U0, PrefixTarget::C)),
            0x42 => Some(Instruction::BIT(PrefixU8::U0, PrefixTarget::D)),
            0x43 => Some(Instruction::BIT(PrefixU8::U0, PrefixTarget::E)),
            0x44 => Some(Instruction::BIT(PrefixU8::U0, PrefixTarget::H)),
            0x45 => Some(Instruction::BIT(PrefixU8::U0, PrefixTarget::L)),
            0x46 => Some(Instruction::BIT(PrefixU8::U0, PrefixTarget::HLI)),
            0x47 => Some(Instruction::BIT(PrefixU8::U0, PrefixTarget::A)),
            0x48 => Some(Instruction::BIT(PrefixU8::U1, PrefixTarget::B)),
            0x49 => Some(Instruction::BIT(PrefixU8::U1, PrefixTarget::C)),
            0x4a => Some(Instruction::BIT(PrefixU8::U1, PrefixTarget::D)),
            0x4b => Some(Instruction::BIT(PrefixU8::U1, PrefixTarget::E)),
            0x4c => Some(Instruction::BIT(PrefixU8::U1, PrefixTarget::H)),
            0x4d => Some(Instruction::BIT(PrefixU8::U1, PrefixTarget::L)),
            0x4e => Some(Instruction::BIT(PrefixU8::U1, PrefixTarget::HLI)),
            0x4f => Some(Instruction::BIT(PrefixU8::U1, PrefixTarget::A)),


            // SIXTH ROW -> 0x5.
            0x50 => Some(Instruction::BIT(PrefixU8::U2, PrefixTarget::B)),
            0x51 => Some(Instruction::BIT(PrefixU8::U2, PrefixTarget::C)),
            0x52 => Some(Instruction::BIT(PrefixU8::U2, PrefixTarget::D)),
            0x53 => Some(Instruction::BIT(PrefixU8::U2, PrefixTarget::E)),
            0x54 => Some(Instruction::BIT(PrefixU8::U2, PrefixTarget::H)),
            0x55 => Some(Instruction::BIT(PrefixU8::U2, PrefixTarget::L)),
            0x56 => Some(Instruction::BIT(PrefixU8::U2, PrefixTarget::HLI)),
            0x57 => Some(Instruction::BIT(PrefixU8::U2, PrefixTarget::A)),
            0x58 => Some(Instruction::BIT(PrefixU8::U3, PrefixTarget::B)),
            0x59 => Some(Instruction::BIT(PrefixU8::U3, PrefixTarget::C)),
            0x5a => Some(Instruction::BIT(PrefixU8::U3, PrefixTarget::D)),
            0x5b => Some(Instruction::BIT(PrefixU8::U3, PrefixTarget::E)),
            0x5c => Some(Instruction::BIT(PrefixU8::U3, PrefixTarget::H)),
            0x5d => Some(Instruction::BIT(PrefixU8::U3, PrefixTarget::L)),
            0x5e => Some(Instruction::BIT(PrefixU8::U3, PrefixTarget::HLI)),
            0x5f => Some(Instruction::BIT(PrefixU8::U3, PrefixTarget::A)),


            // SEVENTH ROW -> 0x6.
            0x60 => Some(Instruction::BIT(PrefixU8::U4, PrefixTarget::B)),
            0x61 => Some(Instruction::BIT(PrefixU8::U4, PrefixTarget::C)),
            0x62 => Some(Instruction::BIT(PrefixU8::U4, PrefixTarget::D)),
            0x63 => Some(Instruction::BIT(PrefixU8::U4, PrefixTarget::E)),
            0x64 => Some(Instruction::BIT(PrefixU8::U4, PrefixTarget::H)),
            0x65 => Some(Instruction::BIT(PrefixU8::U4, PrefixTarget::L)),
            0x66 => Some(Instruction::BIT(PrefixU8::U4, PrefixTarget::HLI)),
            0x67 => Some(Instruction::BIT(PrefixU8::U4, PrefixTarget::A)),
            0x68 => Some(Instruction::BIT(PrefixU8::U5, PrefixTarget::B)),
            0x69 => Some(Instruction::BIT(PrefixU8::U5, PrefixTarget::C)),
            0x6a => Some(Instruction::BIT(PrefixU8::U5, PrefixTarget::D)),
            0x6b => Some(Instruction::BIT(PrefixU8::U5, PrefixTarget::E)),
            0x6c => Some(Instruction::BIT(PrefixU8::U5, PrefixTarget::H)),
            0x6d => Some(Instruction::BIT(PrefixU8::U5, PrefixTarget::L)),
            0x6e => Some(Instruction::BIT(PrefixU8::U5, PrefixTarget::HLI)),
            0x6f => Some(Instruction::BIT(PrefixU8::U5, PrefixTarget::A)),


            // EIGHTH ROW -> 0x7.
            0x70 => Some(Instruction::BIT(PrefixU8::U6, PrefixTarget::B)),
            0x71 => Some(Instruction::BIT(PrefixU8::U6, PrefixTarget::C)),
            0x72 => Some(Instruction::BIT(PrefixU8::U6, PrefixTarget::D)),
            0x73 => Some(Instruction::BIT(PrefixU8::U6, PrefixTarget::E)),
            0x74 => Some(Instruction::BIT(PrefixU8::U6, PrefixTarget::H)),
            0x75 => Some(Instruction::BIT(PrefixU8::U6, PrefixTarget::L)),
            0x76 => Some(Instruction::BIT(PrefixU8::U6, PrefixTarget::HLI)),
            0x77 => Some(Instruction::BIT(PrefixU8::U6, PrefixTarget::A)),
            0x78 => Some(Instruction::BIT(PrefixU8::U7, PrefixTarget::B)),
            0x79 => Some(Instruction::BIT(PrefixU8::U7, PrefixTarget::C)),
            0x7a => Some(Instruction::BIT(PrefixU8::U7, PrefixTarget::D)),
            0x7b => Some(Instruction::BIT(PrefixU8::U7, PrefixTarget::E)),
            0x7c => Some(Instruction::BIT(PrefixU8::U7, PrefixTarget::H)),
            0x7d => Some(Instruction::BIT(PrefixU8::U7, PrefixTarget::L)),
            0x7e => Some(Instruction::BIT(PrefixU8::U7, PrefixTarget::HLI)),
            0x7f => Some(Instruction::BIT(PrefixU8::U7, PrefixTarget::A)),


            // NINTH ROW -> 0x8.
            0x80 => Some(Instruction::RES(PrefixU8::U0, PrefixTarget::B)),
            0x81 => Some(Instruction::RES(PrefixU8::U0, PrefixTarget::C)),
            0x82 => Some(Instruction::RES(PrefixU8::U0, PrefixTarget::D)),
            0x83 => Some(Instruction::RES(PrefixU8::U0, PrefixTarget::E)),
            0x84 => Some(Instruction::RES(PrefixU8::U0, PrefixTarget::H)),
            0x85 => Some(Instruction::RES(PrefixU8::U0, PrefixTarget::L)),
            0x86 => Some(Instruction::RES(PrefixU8::U0, PrefixTarget::HLI)),
            0x87 => Some(Instruction::RES(PrefixU8::U0, PrefixTarget::A)),
            0x88 => Some(Instruction::RES(PrefixU8::U1, PrefixTarget::B)),
            0x89 => Some(Instruction::RES(PrefixU8::U1, PrefixTarget::C)),
            0x8a => Some(Instruction::RES(PrefixU8::U1, PrefixTarget::D)),
            0x8b => Some(Instruction::RES(PrefixU8::U1, PrefixTarget::E)),
            0x8c => Some(Instruction::RES(PrefixU8::U1, PrefixTarget::H)),
            0x8d => Some(Instruction::RES(PrefixU8::U1, PrefixTarget::L)),
            0x8e => Some(Instruction::RES(PrefixU8::U1, PrefixTarget::HLI)),
            0x8f => Some(Instruction::RES(PrefixU8::U1, PrefixTarget::A)),


            // TENTH ROW -> 0x9.
            0x90 => Some(Instruction::RES(PrefixU8::U2, PrefixTarget::B)),
            0x91 => Some(Instruction::RES(PrefixU8::U2, PrefixTarget::C)),
            0x92 => Some(Instruction::RES(PrefixU8::U2, PrefixTarget::D)),
            0x93 => Some(Instruction::RES(PrefixU8::U2, PrefixTarget::E)),
            0x94 => Some(Instruction::RES(PrefixU8::U2, PrefixTarget::H)),
            0x95 => Some(Instruction::RES(PrefixU8::U2, PrefixTarget::L)),
            0x96 => Some(Instruction::RES(PrefixU8::U2, PrefixTarget::HLI)),
            0x97 => Some(Instruction::RES(PrefixU8::U2, PrefixTarget::A)),
            0x98 => Some(Instruction::RES(PrefixU8::U3, PrefixTarget::B)),
            0x99 => Some(Instruction::RES(PrefixU8::U3, PrefixTarget::C)),
            0x9a => Some(Instruction::RES(PrefixU8::U3, PrefixTarget::D)),
            0x9b => Some(Instruction::RES(PrefixU8::U3, PrefixTarget::E)),
            0x9c => Some(Instruction::RES(PrefixU8::U3, PrefixTarget::H)),
            0x9d => Some(Instruction::RES(PrefixU8::U3, PrefixTarget::L)),
            0x9e => Some(Instruction::RES(PrefixU8::U3, PrefixTarget::HLI)),
            0x9f => Some(Instruction::RES(PrefixU8::U3, PrefixTarget::A)),


            // ELEVENTH ROW -> 0xa.
            0xa0 => Some(Instruction::RES(PrefixU8::U4, PrefixTarget::B)),
            0xa1 => Some(Instruction::RES(PrefixU8::U4, PrefixTarget::C)),
            0xa2 => Some(Instruction::RES(PrefixU8::U4, PrefixTarget::D)),
            0xa3 => Some(Instruction::RES(PrefixU8::U4, PrefixTarget::E)),
            0xa4 => Some(Instruction::RES(PrefixU8::U4, PrefixTarget::H)),
            0xa5 => Some(Instruction::RES(PrefixU8::U4, PrefixTarget::L)),
            0xa6 => Some(Instruction::RES(PrefixU8::U4, PrefixTarget::HLI)),
            0xa7 => Some(Instruction::RES(PrefixU8::U4, PrefixTarget::A)),
            0xa8 => Some(Instruction::RES(PrefixU8::U5, PrefixTarget::B)),
            0xa9 => Some(Instruction::RES(PrefixU8::U5, PrefixTarget::C)),
            0xaa => Some(Instruction::RES(PrefixU8::U5, PrefixTarget::D)),
            0xab => Some(Instruction::RES(PrefixU8::U5, PrefixTarget::E)),
            0xac => Some(Instruction::RES(PrefixU8::U5, PrefixTarget::H)),
            0xad => Some(Instruction::RES(PrefixU8::U5, PrefixTarget::L)),
            0xae => Some(Instruction::RES(PrefixU8::U5, PrefixTarget::HLI)),
            0xaf => Some(Instruction::RES(PrefixU8::U5, PrefixTarget::A)),


            // TWELFTH ROW -> 0xb.
            0xb0 => Some(Instruction::RES(PrefixU8::U6, PrefixTarget::B)),
            0xb1 => Some(Instruction::RES(PrefixU8::U6, PrefixTarget::C)),
            0xb2 => Some(Instruction::RES(PrefixU8::U6, PrefixTarget::D)),
            0xb3 => Some(Instruction::RES(PrefixU8::U6, PrefixTarget::E)),
            0xb4 => Some(Instruction::RES(PrefixU8::U6, PrefixTarget::H)),
            0xb5 => Some(Instruction::RES(PrefixU8::U6, PrefixTarget::L)),
            0xb6 => Some(Instruction::RES(PrefixU8::U6, PrefixTarget::HLI)),
            0xb7 => Some(Instruction::RES(PrefixU8::U6, PrefixTarget::A)),
            0xb8 => Some(Instruction::RES(PrefixU8::U7, PrefixTarget::B)),
            0xb9 => Some(Instruction::RES(PrefixU8::U7, PrefixTarget::C)),
            0xba => Some(Instruction::RES(PrefixU8::U7, PrefixTarget::D)),
            0xbb => Some(Instruction::RES(PrefixU8::U7, PrefixTarget::E)),
            0xbc => Some(Instruction::RES(PrefixU8::U7, PrefixTarget::H)),
            0xbd => Some(Instruction::RES(PrefixU8::U7, PrefixTarget::L)),
            0xbe => Some(Instruction::RES(PrefixU8::U7, PrefixTarget::HLI)),
            0xbf => Some(Instruction::RES(PrefixU8::U7, PrefixTarget::A)),


            // THIRTEENTH ROW -> 0xc.
            0xc0 => Some(Instruction::SET(PrefixU8::U0, PrefixTarget::B)),
            0xc1 => Some(Instruction::SET(PrefixU8::U0, PrefixTarget::C)),
            0xc2 => Some(Instruction::SET(PrefixU8::U0, PrefixTarget::D)),
            0xc3 => Some(Instruction::SET(PrefixU8::U0, PrefixTarget::E)),
            0xc4 => Some(Instruction::SET(PrefixU8::U0, PrefixTarget::H)),
            0xc5 => Some(Instruction::SET(PrefixU8::U0, PrefixTarget::L)),
            0xc6 => Some(Instruction::SET(PrefixU8::U0, PrefixTarget::HLI)),
            0xc7 => Some(Instruction::SET(PrefixU8::U0, PrefixTarget::A)),
            0xc8 => Some(Instruction::SET(PrefixU8::U1, PrefixTarget::B)),
            0xc9 => Some(Instruction::SET(PrefixU8::U1, PrefixTarget::C)),
            0xca => Some(Instruction::SET(PrefixU8::U1, PrefixTarget::D)),
            0xcb => Some(Instruction::SET(PrefixU8::U1, PrefixTarget::E)),
            0xcc => Some(Instruction::SET(PrefixU8::U1, PrefixTarget::H)),
            0xcd => Some(Instruction::SET(PrefixU8::U1, PrefixTarget::L)),
            0xce => Some(Instruction::SET(PrefixU8::U1, PrefixTarget::HLI)),
            0xcf => Some(Instruction::SET(PrefixU8::U1, PrefixTarget::A)),


            // FOURTEENTH ROW -> 0xd.
            0xd0 => Some(Instruction::SET(PrefixU8::U2, PrefixTarget::B)),
            0xd1 => Some(Instruction::SET(PrefixU8::U2, PrefixTarget::C)),
            0xd2 => Some(Instruction::SET(PrefixU8::U2, PrefixTarget::D)),
            0xd3 => Some(Instruction::SET(PrefixU8::U2, PrefixTarget::E)),
            0xd4 => Some(Instruction::SET(PrefixU8::U2, PrefixTarget::H)),
            0xd5 => Some(Instruction::SET(PrefixU8::U2, PrefixTarget::L)),
            0xd6 => Some(Instruction::SET(PrefixU8::U2, PrefixTarget::HLI)),
            0xd7 => Some(Instruction::SET(PrefixU8::U2, PrefixTarget::A)),
            0xd8 => Some(Instruction::SET(PrefixU8::U3, PrefixTarget::B)),
            0xd9 => Some(Instruction::SET(PrefixU8::U3, PrefixTarget::C)),
            0xda => Some(Instruction::SET(PrefixU8::U3, PrefixTarget::D)),
            0xdb => Some(Instruction::SET(PrefixU8::U3, PrefixTarget::E)),
            0xdc => Some(Instruction::SET(PrefixU8::U3, PrefixTarget::H)),
            0xdd => Some(Instruction::SET(PrefixU8::U3, PrefixTarget::L)),
            0xde => Some(Instruction::SET(PrefixU8::U3, PrefixTarget::HLI)),
            0xdf => Some(Instruction::SET(PrefixU8::U3, PrefixTarget::A)),


            // FIFTEENTH ROW -> 0xe.
            0xe0 => Some(Instruction::SET(PrefixU8::U4, PrefixTarget::B)),
            0xe1 => Some(Instruction::SET(PrefixU8::U4, PrefixTarget::C)),
            0xe2 => Some(Instruction::SET(PrefixU8::U4, PrefixTarget::D)),
            0xe3 => Some(Instruction::SET(PrefixU8::U4, PrefixTarget::E)),
            0xe4 => Some(Instruction::SET(PrefixU8::U4, PrefixTarget::H)),
            0xe5 => Some(Instruction::SET(PrefixU8::U4, PrefixTarget::L)),
            0xe6 => Some(Instruction::SET(PrefixU8::U4, PrefixTarget::HLI)),
            0xe7 => Some(Instruction::SET(PrefixU8::U4, PrefixTarget::A)),
            0xe8 => Some(Instruction::SET(PrefixU8::U5, PrefixTarget::B)),
            0xe9 => Some(Instruction::SET(PrefixU8::U5, PrefixTarget::C)),
            0xea => Some(Instruction::SET(PrefixU8::U5, PrefixTarget::D)),
            0xeb => Some(Instruction::SET(PrefixU8::U5, PrefixTarget::E)),
            0xec => Some(Instruction::SET(PrefixU8::U5, PrefixTarget::H)),
            0xed => Some(Instruction::SET(PrefixU8::U5, PrefixTarget::L)),
            0xee => Some(Instruction::SET(PrefixU8::U5, PrefixTarget::HLI)),
            0xef => Some(Instruction::SET(PrefixU8::U5, PrefixTarget::A)),


            // SIXTEENTH ROW -> 0xf.
            0xf0 => Some(Instruction::SET(PrefixU8::U6, PrefixTarget::B)),
            0xf1 => Some(Instruction::SET(PrefixU8::U6, PrefixTarget::C)),
            0xf2 => Some(Instruction::SET(PrefixU8::U6, PrefixTarget::D)),
            0xf3 => Some(Instruction::SET(PrefixU8::U6, PrefixTarget::E)),
            0xf4 => Some(Instruction::SET(PrefixU8::U6, PrefixTarget::H)),
            0xf5 => Some(Instruction::SET(PrefixU8::U6, PrefixTarget::L)),
            0xf6 => Some(Instruction::SET(PrefixU8::U6, PrefixTarget::HLI)),
            0xf7 => Some(Instruction::SET(PrefixU8::U6, PrefixTarget::A)),
            0xf8 => Some(Instruction::SET(PrefixU8::U7, PrefixTarget::B)),
            0xf9 => Some(Instruction::SET(PrefixU8::U7, PrefixTarget::C)),
            0xfa => Some(Instruction::SET(PrefixU8::U7, PrefixTarget::D)),
            0xfb => Some(Instruction::SET(PrefixU8::U7, PrefixTarget::E)),
            0xfc => Some(Instruction::SET(PrefixU8::U7, PrefixTarget::H)),
            0xfd => Some(Instruction::SET(PrefixU8::U7, PrefixTarget::L)),
            0xfe => Some(Instruction::SET(PrefixU8::U7, PrefixTarget::HLI)),
            0xff => Some(Instruction::SET(PrefixU8::U7, PrefixTarget::A)),

            _ => panic!("Unknown instruction: {:x}", byte)
        }
    }
}