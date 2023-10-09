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

    JP(JumpTestWithHLI),                  // OK
    CALL(JumpTest),                      // OK
    RET(JumpTest),                       // OK
    JR(JumpTest),                        // OK

    RST(RstTarget),                      // OK

    LD(LoadType),                        // OK

    CCF,                                 // OK
    SCF,                                 // OK
    DAA,                                 // OK
    CPL,                                 // OK

    NOP,                                 // OK
    STOP,
    HALT,                                // OK
    DI,
    EI,

    RLC(PrefixTarget),
}

pub enum LoadType { Byte(LoadByteTarget, LoadByteSource), Word(LoadWordTarget, LoadWordSource) }
pub enum AddType { ToA(ArithmeticTarget), ToHL(Arithmetic16Target), ToSP }

pub enum StackTarget { BC, DE, HL, AF }
pub enum ArithmeticTarget { A, B, C, D, E, H, L, HLI, D8 }
pub enum Arithmetic16Target { BC, DE, HL, SP }
pub enum IncDecTarget { A, B, C, D, E, H, L, BC, DE, HL, SP, HLI }
pub enum PrefixTarget { B }
pub enum JumpTest { NotZero, Zero, NotCarry, Carry, Always }
pub enum JumpTestWithHLI { NotZero, Zero, NotCarry, Carry, Always, HLI }
pub enum LoadByteTarget { A, B, C, D, E, H, L, HLI, BCI, DEI, HLIInc, HLIDec, A16I, A8I }
pub enum LoadByteSource { A, B, C, D, E, H, L, D8, HLI, BCI, DEI, HLIInc, HLIDec, A16I, A8I }
pub enum LoadWordTarget { BC, DE, HL, SP, A16I }
pub enum LoadWordSource { D16, SP, HL, SPPlusD8 }
pub enum RstTarget { H00, H08, H10, H18, H20, H28, H30, H38 }

impl Instruction {
    pub(crate) fn from_byte(byte: u8, prefixed: bool) -> Option<Instruction> {
        if prefixed {
            Instruction::from_byte_prefixed(byte)
        } else {
            Instruction::from_byte_not_prefixed(byte)
        }
    }

    fn from_byte_prefixed(byte: u8) -> Option<Instruction> {
        match byte {
            0x00 => Some(Instruction::RLC(PrefixTarget::B)),
            _ => /* TODO: Add mapping for rest of instructions */ None
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
            // TODO: Add 0x07
            0x08 => Some(Instruction::LD(LoadType::Word(LoadWordTarget::A16I, LoadWordSource::SP))),
            0x09 => Some(Instruction::ADD(AddType::ToHL(Arithmetic16Target::BC))),
            0x0a => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::BCI))),
            0x0b => Some(Instruction::DEC(IncDecTarget::BC)),
            0x0c => Some(Instruction::INC(IncDecTarget::C)),
            0x0d => Some(Instruction::DEC(IncDecTarget::C)),
            0x0e => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::C, LoadByteSource::D8))),
            // TODO: Add 0x0f


            // SECOND ROW -> 0x1.
            0x10 => Some(Instruction::STOP),
            0x11 => Some(Instruction::LD(LoadType::Word(LoadWordTarget::DE, LoadWordSource::D16))),
            0x12 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::HLI, LoadByteSource::A))),
            0x13 => Some(Instruction::INC(IncDecTarget::DE)),
            0x14 => Some(Instruction::INC(IncDecTarget::D)),
            0x15 => Some(Instruction::DEC(IncDecTarget::D)),
            0x16 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::D, LoadByteSource::D8))),
            // TODO: Add 0x17
            0x18 => Some(Instruction::JR(JumpTest::Always)),
            0x19 => Some(Instruction::ADD(AddType::ToHL(Arithmetic16Target::DE))),
            0x1a => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::DEI))),
            0x1b => Some(Instruction::DEC(IncDecTarget::DE)),
            0x1c => Some(Instruction::INC(IncDecTarget::E)),
            0x1d => Some(Instruction::DEC(IncDecTarget::E)),
            0x1e => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::E, LoadByteSource::D8))),
            // TODO: Add 0x1f


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
            0xd9 => Some(Instruction::RET(JumpTest::Always)),
            0xda => Some(Instruction::JP(JumpTestWithHLI::Carry)),
            0xdc => Some(Instruction::CALL(JumpTest::Carry)),
            0xde => Some(Instruction::SBC(ArithmeticTarget::D8)),
            0xdf => Some(Instruction::RST(RstTarget::H18)),


            // FIFTEENTH ROW -> 0xe.
            0xe0 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A8I, LoadByteSource::A))),
            0xe1 => Some(Instruction::POP(StackTarget::HL)),
            0xe2 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::BCI, LoadByteSource::A))),
            0xe5 => Some(Instruction::PUSH(StackTarget::HL)),
            0xe6 => Some(Instruction::AND(ArithmeticTarget::D8)),
            0xe7 => Some(Instruction::RST(RstTarget::H20)),
            0xe8 => Some(Instruction::ADD(AddType::ToSP)),
            0xe9 => Some(Instruction::JP(JumpTestWithHLI::HLI)),
            0xea => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A16I, LoadByteSource::A))),
            0xee => Some(Instruction::XOR(ArithmeticTarget::D8)),
            0xef => Some(Instruction::RST(RstTarget::H28)),


            // SIXTEENTH ROW -> 0xf.
            0xf0 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::A8I))),
            0xf1 => Some(Instruction::POP(StackTarget::AF)),
            0xf2 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::A, LoadByteSource::BCI))),
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
}