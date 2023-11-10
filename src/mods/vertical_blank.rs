use crate::mods::gpu_memory::{GpuMemory, OBJECT_ATTRIBUTE_MEMORY_END, OBJECT_ATTRIBUTE_MEMORY_START, UNUSED_END, UNUSED_START, VIDEO_RAM_END, VIDEO_RAM_START};
use crate::mods::object_attribute_memory_search::ObjectAttributMemorySearch;
use crate::mods::physics_processing_unit::{MODE_OBJECT_ATTRIBUTE_MEMORY_SEARCH, PhysicsProcessingUnitState};

pub struct VerticalBlank {
    cycles_counter: usize,
    line_counter: usize,
}

impl VerticalBlank {
    const MAX_LINE_CYCLES: usize = 456;
    const MAX_VERTICAL_BLANK_CYCLES: usize = 4560;

    pub fn create() -> PhysicsProcessingUnitState {
        PhysicsProcessingUnitState::VerticalBlank(VerticalBlank {
            cycles_counter: 0,
            line_counter: 0,
        })
    }
    pub fn init() -> PhysicsProcessingUnitState {
        PhysicsProcessingUnitState::VerticalBlank(VerticalBlank {
            cycles_counter: VerticalBlank::MAX_VERTICAL_BLANK_CYCLES - 53,
            line_counter: 0,
        })
    }
    fn next(mut self, gpu_mem: &mut GpuMemory) -> PhysicsProcessingUnitState {
        if self.cycles_counter >= VerticalBlank::MAX_VERTICAL_BLANK_CYCLES {
            gpu_mem.window_line_counter = 0;
            gpu_mem.set_stat_mode(MODE_OBJECT_ATTRIBUTE_MEMORY_SEARCH);
            gpu_mem.set_ly(0);
            gpu_mem.sprite_list.clear();
            return ObjectAttributMemorySearch::create();
        }

        if self.line_counter >= VerticalBlank::MAX_LINE_CYCLES {
            gpu_mem.set_ly(gpu_mem.ly + 1);
            self.line_counter = self.line_counter.wrapping_sub(VerticalBlank::MAX_LINE_CYCLES);
        }

        PhysicsProcessingUnitState::VerticalBlank(self)
    }

    pub fn render(mut self, gpu_mem: &mut GpuMemory, cycles: usize) -> PhysicsProcessingUnitState {
        self.cycles_counter += cycles;
        self.line_counter += cycles;
        self.next(gpu_mem)
    }

    pub fn read_byte(&self, gpu_mem: &GpuMemory, addr: u16) -> u8 {
        match addr {
            VIDEO_RAM_START..=VIDEO_RAM_END => gpu_mem.video_ram[usize::from(addr - VIDEO_RAM_START)],
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => gpu_mem.object_attribute_memory[usize::from(addr - OBJECT_ATTRIBUTE_MEMORY_START)],
            UNUSED_START..=UNUSED_END => 0x00,
            _ => panic!("PPU (VB) doesnt read from address: {:04X}", addr),
        }
    }

    pub fn write_byte(&mut self, gpu_mem: &mut GpuMemory, addr: u16, data: u8) {
        match addr {
            VIDEO_RAM_START..=VIDEO_RAM_END => gpu_mem.video_ram[usize::from(addr - VIDEO_RAM_START)] = data,
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => gpu_mem.object_attribute_memory[usize::from(addr - OBJECT_ATTRIBUTE_MEMORY_START)] = data,
            UNUSED_START..=UNUSED_END => (),
            _ => panic!("PPU (VB) doesnt write to address: {:04X}", addr),
        }
    }
}