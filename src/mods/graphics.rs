use std::time::Instant;

use sdl2::render::Texture;
use crate::mods::emulator::NUM_PIXELS_X;

use crate::mods::gpu_memory::{GpuMemory, LCD_CONTROL_REG, OBJECT_ATTRIBUTE_MEMORY_END, OBJECT_ATTRIBUTE_MEMORY_START, RBG24_BYTES_PER_PIXEL, STAT_REG, VIDEO_RAM_END, VIDEO_RAM_START};
use crate::mods::input_output::InputOutput;
use crate::mods::physics_processing_unit;
use crate::mods::physics_processing_unit::PhysicsProcessingUnitState;
use crate::mods::physics_processing_unit::PhysicsProcessingUnitState::{HorizontalBlank, ObjectAttributeMemory, PictureGeneration, VerticalBlank};

pub struct Graphics {
    state: PhysicsProcessingUnitState,
    gpu_data: GpuMemory,
    frame_ready: bool,
    cycles: usize,
    previous_frame_time: Instant,
}

impl Graphics {
    pub fn new() -> Graphics {
        let gpu_mem = GpuMemory::new();
        Graphics {
            state: physics_processing_unit::init(&gpu_mem),
            gpu_data: GpuMemory::new(),
            frame_ready: false,
            cycles: 0,
            previous_frame_time: Instant::now(),
        }
    }

    pub fn init(&mut self) {
        self.gpu_data.init();
    }

    pub fn read_byte(&self, addr: u16) -> u8 {
        match &self.state {
            ObjectAttributeMemory(os) => os.read_byte(&self.gpu_data, addr),
            PictureGeneration(pg) => pg.read_byte(&self.gpu_data, addr),
            HorizontalBlank(hb) => hb.read_byte(&self.gpu_data, addr),
            VerticalBlank(vb) => vb.read_byte(&self.gpu_data, addr),
            _ => panic!("Physic Processing Unit not cover this state {:04X}", addr),
        }
    }

    pub fn write_byte(&mut self, addr: u16, data: u8) {
        match &mut self.state {
            ObjectAttributeMemory(os) => os.write_byte(&mut self.gpu_data, addr, data),
            PictureGeneration(pg) => pg.write_byte(&mut self.gpu_data, addr, data),
            HorizontalBlank(hb) => hb.write_byte(&mut self.gpu_data, addr, data),
            VerticalBlank(vb) => vb.write_byte(&mut self.gpu_data, addr, data),
            _ => panic!("Physic Processing Unit not cover this state {:04X}", addr),
        }
    }
    pub fn read_byte_for_dma(&self, addr: u16) -> u8 {
        match addr {
            VIDEO_RAM_START..=VIDEO_RAM_END => self.gpu_data.video_ram[usize::from(addr - VIDEO_RAM_START)],
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => self.gpu_data.video_ram[usize::from(addr - OBJECT_ATTRIBUTE_MEMORY_START)],
            0xFEA0..=0xFEFF => 0x00,
            _ => panic!("DMA shouldnt not read from address: {:04X}", addr),
        }
    }
    pub fn write_byte_for_dma(&mut self, addr: u16, data: u8) {
        self.gpu_data.object_attribute_memory[usize::from(addr)] = data;
    }

    pub fn read_io_byte(&self, addr: u16) -> u8 {
        self.gpu_data.read_physics_processing_unit_io(addr)
    }

    pub fn write_io_byte(&mut self, addr: u16, data: u8) {
        match addr {
            LCD_CONTROL_REG => {
                let is_enable_old = self.gpu_data.is_physics_processing_unit_enabled();
                self.gpu_data.write_physics_processing_unit_io(addr, data);
                let is_enable_new = self.gpu_data.is_physics_processing_unit_enabled();

                if is_enable_old && !is_enable_new {
                    self.disable_ppu();
                }
                if !is_enable_old && is_enable_new {
                    self.enable_ppu();
                }
            }
            STAT_REG => {
                if self.stat_quirk(data) {
                    self.gpu_data.write_physics_processing_unit_io(addr, 0xFF);
                }
            }
            _ => self.gpu_data.write_physics_processing_unit_io(addr, data),
        }
    }

    pub fn adv_cycles(&mut self, io: &mut InputOutput, cycles: usize) {
        if !self.gpu_data.is_physics_processing_unit_enabled() {
            return;
        }

        self.cycles += cycles;
        let state = std::mem::replace(&mut self.state, PhysicsProcessingUnitState::None);
        self.state = match state {
            ObjectAttributeMemory(os) => os.render(&mut self.gpu_data, cycles),
            PictureGeneration(pg) => pg.render(&mut self.gpu_data, cycles),
            HorizontalBlank(hb) => hb.render(&mut self.gpu_data, cycles),
            VerticalBlank(vb) => vb.render(&mut self.gpu_data, cycles),
            _ => panic!("Physic Processing Unit not cover this state"),
        };

        if self.gpu_data.stat_low_to_high {
            io.request_stat_interrupt();
            self.gpu_data.stat_low_to_high = false;
        }

        if self.gpu_data.vertical_blank_int {
            io.request_vertical_blank_interrupt();
            self.gpu_data.vertical_blank_int = false;
            self.frame_ready = true;
        }

        if let Some(val) = self.gpu_data.dot_matrix_game_stat_quirk {
            if !self.gpu_data.dot_matrix_game_stat_quirk_delay {
                self.gpu_data.write_physics_processing_unit_io(STAT_REG, val);
                self.gpu_data.dot_matrix_game_stat_quirk = None;
            } else {
                self.gpu_data.dot_matrix_game_stat_quirk_delay = false;
            }
        }
    }

    pub fn disable_ppu(&mut self) {
        self.state = physics_processing_unit::disable(&mut self.gpu_data);
        self.gpu_data.rgba32_pixels.iter_mut().for_each(|pix| *pix = 0);
        self.gpu_data.window_line_counter = 0;
        self.gpu_data.stat_low_to_high = false;
        self.gpu_data.ly = 0;
    }

    pub fn enable_ppu(&mut self) {
        self.state = physics_processing_unit::enable(&mut self.gpu_data);
        self.gpu_data.set_ly(0);
        self.gpu_data.sprite_list.clear();
        self.gpu_data.stat_low_to_high = false;
    }

    pub fn stat_quirk(&mut self, data: u8) -> bool {
        match (self.gpu_data.get_lcd_mode(), self.gpu_data.ly_compare()) {
            (_, true) | (2, _) | (1, _) | (0, _) => {
                self.gpu_data.dot_matrix_game_stat_quirk = Some(data);
                self.gpu_data.dot_matrix_game_stat_quirk_delay = true;
                true
            }
            _ => {
                self.gpu_data.dot_matrix_game_stat_quirk = None;
                self.gpu_data.dot_matrix_game_stat_quirk_delay = false;
                false
            }
        }
    }

    pub fn set_dma_transfer(&mut self, status: bool) {
        self.gpu_data.direct_memory_access_transfer = status;
    }

    pub fn update_display(&mut self, texture: &mut Texture) -> bool {
        if self.frame_ready {
            texture
                .update(None, &self.gpu_data.rgba32_pixels, NUM_PIXELS_X as usize * RBG24_BYTES_PER_PIXEL)
                .expect("updating texture didnt work");

            self.cycles = 0;
            self.frame_ready = false;
            self.previous_frame_time = Instant::now();
            return true;
        }
        false
    }
}
