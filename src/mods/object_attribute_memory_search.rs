use crate::mods::gpu_memory::{GpuMemory, OBJECT_ATTRIBUTE_MEMORY_END, OBJECT_ATTRIBUTE_MEMORY_START, UNUSED_END, UNUSED_START, VIDEO_RAM_END, VIDEO_RAM_START};
use crate::mods::physics_processing_unit::{MODE_PICTURE_GENERATION, PhysicsProcessingUnitState};
use crate::mods::picture_generation::PictureGeneration;
use crate::mods::sprite::Sprite;

pub struct ObjectAttributMemorySearch {
    cycles_counter: usize,
}

impl ObjectAttributMemorySearch {
    pub const MAX_CYCLES: usize = 80;
    const MAX_SCANLINE_SPRITES: usize = 10;
    const OAM_LENGTH: usize = 160;
    pub fn create() -> PhysicsProcessingUnitState {
        PhysicsProcessingUnitState::ObjectAttributeMemory(ObjectAttributMemorySearch { cycles_counter: 0 })
    }
    fn next(self, gpu_mem: &mut GpuMemory) -> PhysicsProcessingUnitState {
        if self.cycles_counter < ObjectAttributMemorySearch::MAX_CYCLES {
            PhysicsProcessingUnitState::ObjectAttributeMemory(self)
        } else {
            gpu_mem.set_stat_mode(MODE_PICTURE_GENERATION);
            gpu_mem.background_pixel_fifo.clear();
            PhysicsProcessingUnitState::PictureGeneration(PictureGeneration::new())
        }
    }

    pub fn render(mut self, gpu_mem: &mut GpuMemory, cycles: usize) -> PhysicsProcessingUnitState {
        let entries_todo = cycles / 2;
        let entries_done = self.cycles_counter / 2;
        self.find_sprites(gpu_mem, entries_todo, entries_done);
        self.cycles_counter += cycles;
        self.next(gpu_mem)
    }

    pub fn read_byte(&self, gpu_mem: &GpuMemory, addr: u16) -> u8 {
        match addr {
            VIDEO_RAM_START..=VIDEO_RAM_END => gpu_mem.video_ram[usize::from(addr - VIDEO_RAM_START)],
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => 0xFF,
            UNUSED_START..=UNUSED_END => 0xFF,
            _ => panic!("PPU (O Search) doesnt read from address: {:04X}", addr),
        }
    }

    pub fn write_byte(&mut self, gpu_mem: &mut GpuMemory, addr: u16, data: u8) {
        match addr {
            VIDEO_RAM_START..=VIDEO_RAM_END => gpu_mem.video_ram[usize::from(addr - VIDEO_RAM_START)] = data,
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => (),
            UNUSED_START..=UNUSED_END => (),
            _ => panic!("PPU (O Search) doesnt write to address: {:04X}", addr),
        }
    }

    pub fn find_sprites(
        &mut self,
        gpu_mem: &mut GpuMemory,
        entries_todo: usize,
        entries_done: usize,
    ) {
        let mut ypos;
        let mut xpos;
        let mut sprite_height;

        for i in 0..entries_todo {
            let curr_entry = (entries_done + i) * 4;

            if gpu_mem.sprite_list.len() == ObjectAttributMemorySearch::MAX_SCANLINE_SPRITES
                || curr_entry >= ObjectAttributMemorySearch::OAM_LENGTH
            {
                break;
            }

            if gpu_mem.direct_memory_access_transfer {
                ypos = 0xFF;
                xpos = 0xFF
            } else {
                ypos = gpu_mem.object_attribute_memory[curr_entry];
                xpos = gpu_mem.object_attribute_memory[curr_entry + 1];
            }

            sprite_height = 8;
            if gpu_mem.is_big_sprite() {
                sprite_height = 16;
            }

            if ((gpu_mem.ly + 16) >= ypos) && ((gpu_mem.ly + 16) < ypos + sprite_height) {

                let mut idx = 0;
                for sprite in gpu_mem.sprite_list.iter() {
                    idx += 1;
                    if sprite.x_pos > xpos {
                        idx -= 1;
                        break;
                    }
                }
                gpu_mem.sprite_list.insert(
                    idx,
                    Sprite::new(&gpu_mem.object_attribute_memory[curr_entry..(curr_entry + 4)]),
                );
            }
        }
    }
}