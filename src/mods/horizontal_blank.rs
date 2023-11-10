use crate::mods::gpu_memory::{GpuMemory, OBJECT_ATTRIBUTE_MEMORY_END, OBJECT_ATTRIBUTE_MEMORY_START, UNUSED_END, UNUSED_START, VIDEO_RAM_END, VIDEO_RAM_START};
use crate::mods::object_attribute_memory_search::ObjectAttributMemorySearch;
use crate::mods::physics_processing_unit::{MODE_OBJECT_ATTRIBUTE_MEMORY_SEARCH, MODE_VERTICAL_BLANK, PhysicsProcessingUnitState};
use crate::mods::vertical_blank::VerticalBlank;

pub struct HorizontalBlank {
    cycles_counter: usize,
    cycles_to_run: usize,
}

impl HorizontalBlank {
    pub fn new(cycles_remaining: usize) -> PhysicsProcessingUnitState {
        PhysicsProcessingUnitState::HorizontalBlank(HorizontalBlank {
            cycles_counter: 0,
            cycles_to_run: cycles_remaining,
        })
    }
    fn next(self, gpu_mem: &mut GpuMemory) -> PhysicsProcessingUnitState {
        if self.cycles_counter < self.cycles_to_run {
            PhysicsProcessingUnitState::HorizontalBlank(self)
        } else {
            if gpu_mem.is_window_enabled() && gpu_mem.is_window_visible() {
                gpu_mem.window_line_counter += 1;
            }

            gpu_mem.set_ly(gpu_mem.ly + 1);
            gpu_mem.sprite_list.clear();

            if gpu_mem.ly < 144 {
                gpu_mem.set_stat_mode(MODE_OBJECT_ATTRIBUTE_MEMORY_SEARCH);
                ObjectAttributMemorySearch::new()
            } else {
                gpu_mem.set_stat_mode(MODE_VERTICAL_BLANK);
                VerticalBlank::new()
            }
        }
    }

    pub fn render(mut self, gpu_mem: &mut GpuMemory, cycles: usize) -> PhysicsProcessingUnitState {
        self.cycles_counter += cycles;
        self.next(gpu_mem)
    }

    pub fn read_byte(&self, gpu_mem: &GpuMemory, addr: u16) -> u8 {
        match addr {
            VIDEO_RAM_START..=VIDEO_RAM_END => gpu_mem.video_ram[usize::from(addr - VIDEO_RAM_START)],
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => gpu_mem.object_attribute_memory[usize::from(addr - OBJECT_ATTRIBUTE_MEMORY_START)],
            UNUSED_START..=UNUSED_END => 0x00,
            _ => panic!("PPU (HB) doesnt read from address: {:04X}", addr),
        }
    }

    pub fn write_byte(&mut self, gpu_mem: &mut GpuMemory, addr: u16, data: u8) {
        match addr {
            VIDEO_RAM_START..=VIDEO_RAM_END => gpu_mem.video_ram[usize::from(addr - VIDEO_RAM_START)] = data,
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => gpu_mem.object_attribute_memory[usize::from(addr - OBJECT_ATTRIBUTE_MEMORY_START)] = data,
            UNUSED_START..=UNUSED_END => (),
            _ => panic!("PPU (HB) doesnt write to address: {:04X}", addr),
        }
    }
}