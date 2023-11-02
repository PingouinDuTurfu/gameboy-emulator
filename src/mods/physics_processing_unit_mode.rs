// pub enum PhysicsProcessingUnitMode {
//     HorizontalBlank, // 00 -> CPU can access to display RAM (0x8000-0x9FFF)
//     VerticalBlank, // 01 -> CPU can access to display RAM (0x8000-0x9FFF)
//     ObjectAttributeMemory, // 10 -> CPU can't access to OAM (0xFE00-0xFE90)
//     PictureGeneration, // 11 -> CPU can't access to both display RAM and OAM (0x8000-0x9FFF, 0xFE00-0xFE90)
// }
//
// fn init() -> PhysicsProcessingUnitMode {
//     return PhysicsProcessingUnitMode::VerticalBlank;
// }
//
// fn enable() -> PhysicsProcessingUnitMode {
//     return PhysicsProcessingUnitMode::PictureGeneration;
// }
//
// fn disable() -> PhysicsProcessingUnitMode {
//     return PhysicsProcessingUnitMode::HorizontalBlank;
// }
//
