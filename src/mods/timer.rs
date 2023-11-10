use crate::mods::input_output::InputOutput;

pub const TIMER_START: u16 = 0xFF04;
pub const TIMER_END: u16 = 0xFF07;
pub const DIV_REG: u16 = 0xFF04; // Divider Register for time tracking.
pub const TIMA_REG: u16 = 0xFF05; // Timer Counter Register for counter management.
pub const TMA_REG: u16 = 0xFF06; // Timer Modulo Register for managing overflow values.
pub const TAC_REG: u16 = 0xFF07; // Timer Control Register for configuring timer operation.

pub struct Timer {
    div: u16,
    tima: u8,
    tma: u8,
    tac: u8,
    overflow_source: TimaOverflowState,
}

enum TimaOverflowState {
    Done,
    Advancing,
    None,
}

impl TimaOverflowState {

    pub fn is_done(&self) -> bool {
        matches!(self, TimaOverflowState::Done)
    }
}

impl Timer {
    pub fn new() -> Timer {
        Timer {
            div: 0,
            tima: 0,
            tma: 0,
            tac: 0,
            overflow_source: TimaOverflowState::None,
        }
    }

    pub fn init(&mut self) {
        self.div = 0xABCC;
        self.tima = 0x00;
        self.tma = 0x00;
        self.tac = 0xF8;
    }

    pub fn read_byte(&self, addr: u16) -> u8 {
        match addr {
            DIV_REG => (self.div >> 8) as u8,
            TIMA_REG => self.tima,
            TMA_REG => self.tma,
            TAC_REG => self.tac,
            _ => panic!("Timer does not handle reads from addr: {}", addr),
        }
    }

    pub fn write_byte(&mut self, addr: u16, data: u8) {
        match addr {
            DIV_REG => self.write_div(),
            TIMA_REG => {
                self.tima = match self.overflow_source {
                    TimaOverflowState::Advancing => {
                        self.overflow_source = TimaOverflowState::None;
                        data
                    }
                    TimaOverflowState::Done => self.tima,
                    TimaOverflowState::None => data,
                }
            }
            TMA_REG => {
                self.tma = data;
                if self.overflow_source.is_done() {
                    self.tima = self.tma;
                }
            }
            TAC_REG => { self.write_tac(data); }
            _ => panic!("Timer does not handle writes to addr: {}", addr),
        }
    }

    pub fn adv_cycles(&mut self, io: &mut InputOutput, cycles: usize) {
        match self.overflow_source {
            TimaOverflowState::Advancing => {
                self.tima = self.tma;
                self.overflow_source = TimaOverflowState::Done;
                io.request_timer_interrupt();
            }
            TimaOverflowState::Done => self.overflow_source = TimaOverflowState::None,
            TimaOverflowState::None => {}
        }

        let (timer_enable, _) = self.decode_tac();
        let old_div_bit = self.div_tac_multiplexer();

        self.div = self.div.wrapping_add(cycles as u16);

        let new_div_bit = self.div_tac_multiplexer();

        let should_incr =
            self.detected_falling_edge(old_div_bit, new_div_bit, timer_enable, timer_enable);

        if should_incr {
            self.incr_timer();
        }
        io.clean_if_register_trigger();
    }

    fn write_div(&mut self) {
        let (timer_enable, _) = self.decode_tac();
        let old_div_bit = self.div_tac_multiplexer();

        self.div = 0;

        let new_div_bit = self.div_tac_multiplexer();

        let should_incr =
            self.detected_falling_edge(old_div_bit, new_div_bit, timer_enable, timer_enable);
        if should_incr {
            self.incr_timer();
        }
    }

    fn write_tac(&mut self, data: u8) {
        let old_div_bit = self.div_tac_multiplexer();
        let (old_enbl, _) = self.decode_tac();

        self.tac = (data & 0x07) | 0xF8;

        let new_div_bit = self.div_tac_multiplexer();
        let (new_enbl, _) = self.decode_tac();

        let should_incr = self.detected_falling_edge(old_div_bit, new_div_bit, old_enbl, new_enbl);

        if should_incr {
            self.incr_timer();
        }
    }

    fn incr_timer(&mut self) -> bool {
        let (new_tima, overflow) = self.tima.overflowing_add(1);

        self.tima = new_tima;

        if overflow {
            self.tima = 0x00;
            self.overflow_source = TimaOverflowState::Advancing;
        }

        overflow
    }

    pub fn decode_tac(&mut self) -> (bool, usize) {
        let tac = self.tac;

        match ((tac & 0x04) == 0x04, tac & 0x03) {
            (enable, 0) => (enable, 1024),
            (enable, 1) => (enable, 16),
            (enable, 2) => (enable, 64),
            (enable, 3) => (enable, 256),
            _ => panic!("Should be impossible"),
        }
    }

    fn div_tac_multiplexer(&self) -> bool {
        match self.tac & 0x03 {
            0 => (self.div >> 9) & 0x01 == 0x01,
            1 => (self.div >> 3) & 0x01 == 0x01,
            2 => (self.div >> 5) & 0x01 == 0x01,
            3 => (self.div >> 7) & 0x01 == 0x01,
            _ => panic!("double check the `AND` operation"),
        }
    }

    fn detected_falling_edge(
        &self,
        old_div: bool,
        new_div: bool,
        old_enbl: bool,
        new_enbl: bool,
    ) -> bool {
        (old_div && old_enbl) && !(new_div && new_enbl)
    }
}