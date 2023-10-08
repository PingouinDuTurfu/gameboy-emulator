use crate::mods::enum_instructions::AddType::ToA;

pub enum Instruction {
    PUSH(StackTarget),
    POP(StackTarget),
    ADD(AddType),
    INC(IncDecTarget),
    DEC(IncDecTarget),
    RLC(PrefixTarget),
    JP(JumpTest),
    LD(LoadType),
    NOP,
    STOP,
    HALT,
    DI,
    EI,
}

pub enum LoadType { Byte(LoadByteTarget, LoadByteSource), Word(LoadWordTarget, LoadWordSource) }
pub enum AddType { ToA(ArithmeticTarget), ToHL(Arithmetic16Target), ToSP() }

pub enum StackTarget { BC, DE }
pub enum ArithmeticTarget { A, B, C, D, E, H, L, HLI, D8 }
pub enum Arithmetic16Target { BC, DE, HL, SP }
pub enum IncDecTarget { A, B, C, D, E, H, L, BC, DE, HL, SP, HLI }
pub enum PrefixTarget { B }
pub enum JumpTest { NotZero, Zero, NotCarry, Carry, Always }
pub enum LoadByteTarget { A, B, C, D, E, H, L, HLI, BCI, DEI, HLIInc, HLIDec }
pub enum LoadByteSource { A, B, C, D, E, H, L, D8, HLI }
pub enum LoadWordTarget { BC, DE, HL, SP, A16 }
pub enum LoadWordSource { D16, SP, HLInc, HLDec }

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
            // FIST ROW
            0x00 => Some(Instruction::NOP),
            0x01 => Some(Instruction::LD(LoadType::Word(LoadWordTarget::BC, LoadWordSource::D16))),
            0x02 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::BCI, LoadByteSource::A))),
            0x03 => Some(Instruction::INC(IncDecTarget::BC)),
            0x04 => Some(Instruction::INC(IncDecTarget::B)),
            0x05 => Some(Instruction::DEC(IncDecTarget::B)),
            0x06 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::B, LoadByteSource::D8))),
            // TODO: Add 0x07
            0x08 => Some(Instruction::LD(LoadType::Word(LoadWordTarget::A16, LoadWordSource::SP))),
            0x09 => Some(Instruction::ADD(AddType::ToHL(Arithmetic16Target::BC))),
            // TODO: Add 0x0a
            0x0b => Some(Instruction::DEC(IncDecTarget::BC)),
            0x0c => Some(Instruction::INC(IncDecTarget::C)),
            0x0d => Some(Instruction::DEC(IncDecTarget::C)),
            0x0e => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::C, LoadByteSource::D8))),
            // TODO: Add 0x0f


            // SECOND ROW
            0x10 => Some(Instruction::STOP),
            // TODO: Add 0x11
            0x12 => Some(Instruction::LD(LoadType::Byte(LoadByteTarget::HLI, LoadByteSource::A))),
            0x13 => Some(Instruction::INC(IncDecTarget::DE)),
            0x14 => Some(Instruction::INC(IncDecTarget::D)),
            0x15 => Some(Instruction::DEC(IncDecTarget::D)),
            // 0x19 => Some(Instruction::ADD(ArithmeticTarget::DE)),
            0x1b => Some(Instruction::DEC(IncDecTarget::DE)),
            0x1c => Some(Instruction::INC(IncDecTarget::E)),
            0x1d => Some(Instruction::DEC(IncDecTarget::E)),


            // THIRD ROW
            0x23 => Some(Instruction::INC(IncDecTarget::HL)),
            0x24 => Some(Instruction::INC(IncDecTarget::H)),
            0x25 => Some(Instruction::DEC(IncDecTarget::H)),
            // 0x29 => Some(Instruction::ADD(ArithmeticTarget::HL)),
            0x2b => Some(Instruction::DEC(IncDecTarget::HL)),
            0x2c => Some(Instruction::INC(IncDecTarget::L)),
            0x2d => Some(Instruction::DEC(IncDecTarget::L)),


            // FOURTH ROW
            0x33 => Some(Instruction::INC(IncDecTarget::SP)),
            0x34 => Some(Instruction::INC(IncDecTarget::HLI)),
            0x35 => Some(Instruction::DEC(IncDecTarget::HLI)),
            // 0x39 => Some(Instruction::ADD(ArithmeticTarget::SP)),
            0x3b => Some(Instruction::DEC(IncDecTarget::SP)),
            0x3c => Some(Instruction::INC(IncDecTarget::A)),
            0x3d => Some(Instruction::DEC(IncDecTarget::A)),


            0x80 => Some(Instruction::ADD(ToA(ArithmeticTarget::B))),
            0x81 => Some(Instruction::ADD(ToA(ArithmeticTarget::C))),
            0x82 => Some(Instruction::ADD(ToA(ArithmeticTarget::D))),
            0x83 => Some(Instruction::ADD(ToA(ArithmeticTarget::E))),
            0x84 => Some(Instruction::ADD(ToA(ArithmeticTarget::H))),
            0x85 => Some(Instruction::ADD(ToA(ArithmeticTarget::L))),
            0x86 => Some(Instruction::ADD(ToA(ArithmeticTarget::HLI))),
            0x87 => Some(Instruction::ADD(ToA(ArithmeticTarget::A))),


            0xc2 => Some(Instruction::JP(JumpTest::NotZero)),
            0xc3 => Some(Instruction::JP(JumpTest::Always)),

            _ => /* TODO: Add mapping for rest of instructions */ None
        }
    }
}