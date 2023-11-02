use crate::mods::emulator::PRINT_DEBUG;
use crate::mods::gpu_memory::{GpuMemory, OBJECT_ATTRIBUTE_MEMORY_END, OBJECT_ATTRIBUTE_MEMORY_START, UNUSED_END, UNUSED_START, VIDEO_RAM_END, VIDEO_RAM_START};
use crate::mods::physics_processing_unit::{MODE_PICTURE_GENERATION, PhysicsProcessingUnitState};
use crate::mods::picture_generation::PictureGeneration;
use crate::mods::sprite::Sprite;

pub struct ObjectAttributMemorySearch {
    cycles_counter: usize,
}

impl ObjectAttributMemorySearch {
    pub const MAX_CYCLES: usize = 80;
    const MAX_SPRITES: usize = 40;
    const MAX_SCANLINE_SPRITES: usize = 10;
    const OAM_LENGTH: usize = 160;

    // Each scanline does an OAM scan during which time we need to determine
    // which sprites should be displayed. (Max of 10 per scan line).
    pub fn new() -> PhysicsProcessingUnitState {
        return PhysicsProcessingUnitState::ObjectAttributeMemory(ObjectAttributMemorySearch { cycles_counter: 0 });
    }

    // oamsearch may return itself or picturegeneration
    fn next(self: Self, gpu_mem: &mut GpuMemory) -> PhysicsProcessingUnitState {
        if self.cycles_counter < ObjectAttributMemorySearch::MAX_CYCLES {
            return PhysicsProcessingUnitState::ObjectAttributeMemory(self);
        } else {
            gpu_mem.set_stat_mode(MODE_PICTURE_GENERATION);

            // https://gbdev.io/pandocs/pixel_fifo.html#mode-3-operation
            gpu_mem.background_pixel_fifo.clear();
            return PhysicsProcessingUnitState::PictureGeneration(PictureGeneration::new());
        }
    }

    pub fn render(mut self, gpu_mem: &mut GpuMemory, cycles: usize) -> PhysicsProcessingUnitState {
        let entries_todo = cycles / 2;
        let entries_done = self.cycles_counter / 2;

        self.find_sprites(gpu_mem, entries_todo, entries_done);

        self.cycles_counter += cycles;
        return self.next(gpu_mem); // For Now
    }

    pub fn read_byte(self: &Self, gpu_mem: &GpuMemory, addr: u16) -> u8 {
        return match addr {
            VIDEO_RAM_START..=VIDEO_RAM_END => gpu_mem.video_ram[usize::from(addr - VIDEO_RAM_START)],
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => 0xFF,
            UNUSED_START..=UNUSED_END => 0xFF,
            _ => panic!("PPU (O Search) doesnt read from address: {:04X}", addr),
        };
    }

    pub fn write_byte(self: &mut Self, gpu_mem: &mut GpuMemory, addr: u16, data: u8) {
        match addr {
            VIDEO_RAM_START..=VIDEO_RAM_END => {
                unsafe {
                    if data != 0x00 {
                        // PRINT_DEBUG.add_data(format!("WRITE_TO_VRAM OAM {:04X} {:02X}\n", addr, data));
                    }
                }
                gpu_mem.video_ram[usize::from(addr - VIDEO_RAM_START)] = data
            },
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => return,
            UNUSED_START..=UNUSED_END => return,
            _ => panic!("PPU (O Search) doesnt write to address: {:04X}", addr),
        }
    }

    /*
        Double Check with this: (https://hacktix.github.io/GBEDG/ppu/)
        A sprite is only added to the buffer if all of the following conditions apply: (I think +16 should be 0)

         - Sprite X-Position must be greater than 0
         - LY + 16 must be greater than or equal to Sprite Y-Position
         - LY + 16 must be less than Sprite Y-Position + Sprite Height (8 in Normal Mode, 16 in Tall-Sprite-Mode)
         - The amount of sprites already stored in the OAM Buffer must be less than 10
    */
    pub fn find_sprites(
        self: &mut Self,
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

            // DMA transfer overrides mode-2 access to OAM. (Reads to OAM return 0xFF)
            // During dma transfer the sprites wont appear on the screen since gpu_mem.ly + 16
            // can never be greater than or equal to 255.
            if gpu_mem.direct_memory_access_transfer {
                ypos = 0xFF;
                xpos = 0xFF
            } else {
                ypos = gpu_mem.object_attribute_memory[curr_entry];
                xpos = gpu_mem.object_attribute_memory[curr_entry + 1];
            }

            sprite_height = 8; // I think this is the only part that can change mid scanline
            if gpu_mem.is_big_sprite() {
                sprite_height = 16;
            }

            if ((gpu_mem.ly + 16) >= ypos) && ((gpu_mem.ly + 16) < ypos + sprite_height) {
                let mut idx = 0;
                for sprite in gpu_mem.sprite_list.iter() {
                    // https://gbdev.io/pandocs/OAM.html#drawing-priority
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