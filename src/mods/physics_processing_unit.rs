use crate::mods::gpu_memory::GpuMemory;
use crate::mods::horizontal_blank::HorizontalBlank;
use crate::mods::object_attribute_memory_search::ObjectAttributMemorySearch;
use crate::mods::picture_generation::PictureGeneration;
use crate::mods::vertical_blank::VerticalBlank;

pub const MODE_HORIZONTAL_BLANK: u8 = 0;
pub const MODE_VERTICAL_BLANK: u8 = 1;
pub const MODE_OBJECT_ATTRIBUTE_MEMORY_SEARCH: u8 = 2;
pub const MODE_PICTURE_GENERATION: u8 = 3;


pub enum PhysicsProcessingUnitState {
    HorizontalBlank(HorizontalBlank), // 00 -> CPU can access to display RAM (0x8000-0x9FFF)
    VerticalBlank(VerticalBlank), // 01 -> CPU can access to display RAM (0x8000-0x9FFF)
    ObjectAttributeMemory(ObjectAttributMemorySearch), // 10 -> CPU can't access to OAM (0xFE00-0xFE90)
    PictureGeneration(PictureGeneration), // 11 -> CPU can't access to both display RAM and OAM (0x8000-0x9FFF, 0xFE00-0xFE90)
    None
}

pub fn init(_gpu_mem: &mut GpuMemory) -> PhysicsProcessingUnitState {
    return VerticalBlank::init();
}

pub fn enable(gpu_mem: &mut GpuMemory) -> PhysicsProcessingUnitState {
    gpu_mem.set_stat_mode(MODE_PICTURE_GENERATION);
    return PhysicsProcessingUnitState::PictureGeneration(PictureGeneration::new());
}

pub fn disable(gpu_mem: &mut GpuMemory) -> PhysicsProcessingUnitState {
    gpu_mem.set_stat_mode(MODE_HORIZONTAL_BLANK);
    return HorizontalBlank::new(0);
}


// use crate::mods::physics_processing_unit::PhysicsProcessingUnit::HorizontalBlank;
// use crate::mods::physics_processing_unit_mode::PhysicsProcessingUnitMode;
// use crate::mods::vertical_blank::VerticalBlank;
//
// pub struct PhysicsProcessingUnit {
//     physics_processing_unit_mode: PhysicsProcessingUnitMode,
//     horizontal_blank: HorizontalBlank,
//     vertical_blank: VerticalBlank,
//     object_attribute_memory: ObjectAttributeMemory,
//     picture_generation: PictureGeneration
// }
//
//
// impl PhysicsProcessingUnit {
//     fn init(self: &mut Self) -> PhysicsProcessingUnit {
//         self.physics_processing_unit_mode = PhysicsProcessingUnitMode::VerticalBlank;
//         self.vertical_blank = VerticalBlank::new();
//         return self;
//     }
//
//     fn enable() -> PhysicsProcessingUnit {
//         return PhysicsProcessingUnit::PictureGeneration;
//     }
//
//     fn disable() -> PhysicsProcessingUnit {
//         return PhysicsProcessingUnit::HorizontalBlank;
//     }
//
//     fn get_mode(self: &Self) -> u8 {
//         return match self.physics_processing_unit_mode {
//             PhysicsProcessingUnitMode::HorizontalBlank => 0x00,
//             PhysicsProcessingUnitMode::VerticalBlank => 0x01,
//             PhysicsProcessingUnitMode::ObjectAttributeMemory => 0x02,
//             PhysicsProcessingUnitMode::PictureGeneration => 0x03,
//         };
//     }
// }