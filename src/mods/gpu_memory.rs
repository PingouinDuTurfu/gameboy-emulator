use std::collections::VecDeque;
use crate::mods::emulator::{PRINT_DEBUG, TOTAL_PIXELS};
use crate::mods::sprite::Sprite;

pub const VIDEO_RAM_START: u16 = 0x8000;
pub const VIDEO_RAM_END: u16 = 0x9FFF;
pub const LCD_CONTROL_REG: u16 = 0xFF40;
pub const STAT_REG: u16 = 0xFF41;
pub const SCROLL_Y_REG: u16 = 0xFF42;
pub const SCROLL_X_REG: u16 = 0xFF43;
pub const LY_REG: u16 = 0xFF44;
pub const LYC_REG: u16 = 0xFF45;
pub const BACKGROUND_PALETTE_REG: u16 = 0xFF47;
pub const OBJECT_PALETTE_0_REG: u16 = 0xFF48;
pub const OBJECT_PALETTE_1_REG: u16 = 0xFF49;
pub const WINDOW_Y_REG: u16 = 0xFF4A;
pub const WINDOW_X_REG: u16 = 0xFF4B;
pub const OBJECT_ATTRIBUTE_MEMORY_START: u16 = 0xFE00;
pub const OBJECT_ATTRIBUTE_MEMORY_END: u16 = 0xFE9F;
pub const PHYSICS_PROCESSING_UNIT_IO_START: u16 = 0xFF40;
pub const PHYSICS_PROCESSING_UNIT_IO_END: u16 = 0xFF4B;
pub const UNUSED_START: u16 = 0xFEA0;
pub const UNUSED_END: u16 = 0xFEFF;
pub const COLORS_AS_SDL_PIXEL_FORMAT_INDEX4MSB: [u8; 4] = [0x0F, 0x0A, 0x05, 0x00];
pub const RBG24_BYTES_PER_PIXEL: usize = 3;

pub struct GpuMemory {
    pub rgb24_pixels: [u8; TOTAL_PIXELS as usize * RBG24_BYTES_PER_PIXEL],
    pub video_ram: [u8; (VIDEO_RAM_END - VIDEO_RAM_START) as usize + 1], // 0x8000 - 0x9FFF
    pub object_attribute_memory: [u8; (OBJECT_ATTRIBUTE_MEMORY_END - OBJECT_ATTRIBUTE_MEMORY_START) as usize + 1], // OAM 0xFE00 - 0xFE9F  40 sprites, each takes 4 bytes
    pub lcd_control: u8, // 0xFF40
    pub stat: u8, // 0xFF41
    pub scroll_y: u8, // 0xFF42 scrolling background y
    pub scroll_x: u8, // 0xFF43 scrolling background x
    pub ly: u8, // 0xFF44 current y scanline
    pub lyc: u8, // 0xFF45 y scanline compare
    pub background_palette: u8, // 0xFF47 (0: white, 1: light gray, 2: dark gray, 3: black)
    pub object_palette_0: u8, // 0xFF48
    pub object_palette_1: u8, // 0xFF49
    pub window_y: u8, // 0xFF4A
    pub window_x: u8, // 0xFF4B

    pub window_line_counter: u8,
    pub direct_memory_access_transfer: bool,
    pub stat_int: bool,
    pub stat_low_to_high: bool,
    pub vertical_blank_int: bool,
    pub dot_matrix_game_stat_quirk: Option<u8>,
    pub dot_matrix_game_stat_quirk_delay: bool,
    pub sprite_list: Vec<Sprite>,
    pub background_pixel_fifo: VecDeque<u8>,

    pub background_colors_as_sdl_pixel_format_index4msb: [u8; 4]
}

impl GpuMemory {
    pub fn new() -> GpuMemory {
        return GpuMemory {
            rgb24_pixels: [0; TOTAL_PIXELS as usize * RBG24_BYTES_PER_PIXEL],
            video_ram: [0; (VIDEO_RAM_END - VIDEO_RAM_START) as usize + 1],
            object_attribute_memory: [0; (OBJECT_ATTRIBUTE_MEMORY_END - OBJECT_ATTRIBUTE_MEMORY_START) as usize + 1],
            lcd_control: 0,
            stat: 0,
            scroll_y: 0,
            scroll_x: 0,
            ly: 0,
            lyc: 0,
            background_palette: 0,
            object_palette_0: 0,
            object_palette_1: 0,
            window_y: 0,
            window_x: 0,

            window_line_counter: 0,
            direct_memory_access_transfer: false,
            stat_int: false,
            stat_low_to_high: false,
            vertical_blank_int: false,
            dot_matrix_game_stat_quirk: None,
            dot_matrix_game_stat_quirk_delay: false,
            sprite_list: Vec::<Sprite>::new(),
            background_pixel_fifo: VecDeque::new(),

            background_colors_as_sdl_pixel_format_index4msb: COLORS_AS_SDL_PIXEL_FORMAT_INDEX4MSB
        };
    }

    pub fn init(self: &mut Self) {
        self.lcd_control = 0x91;
        self.stat = 0x85;
        self.scroll_y = 0x00;
        self.scroll_x = 0x00;
        self.ly = 0x00;
        self.lyc = 0x00;
        self.background_palette = 0x00; // Will be set to 0xE4 by the boot rom
        self.object_palette_0 = 0x00;
        self.object_palette_1 = 0x00;
        self.window_y = 0x00;
        self.window_x = 0x00;
    }

    pub fn read_physics_processing_unit_io(self: &Self, addr: u16) -> u8 {
        return match addr {
            LCD_CONTROL_REG => self.lcd_control,
            STAT_REG => self.stat,
            SCROLL_Y_REG => self.scroll_y,
            SCROLL_X_REG => self.scroll_x,
            LY_REG => self.ly,
            LYC_REG => self.lyc,
            BACKGROUND_PALETTE_REG => self.background_palette,
            OBJECT_PALETTE_0_REG => self.object_palette_0,
            OBJECT_PALETTE_1_REG => self.object_palette_1,
            WINDOW_Y_REG => self.window_y,
            WINDOW_X_REG => self.window_x,
            _ => panic!("Physics processing unit IO does not handle reads from: {:04X}", addr),
        };
    }

    pub fn write_physics_processing_unit_io(self: &mut Self, addr: u16, data: u8) {
        match addr {
            LCD_CONTROL_REG => self.lcd_control = data,
            STAT_REG => {
                self.stat = 0x80 | (data & 0xE8) | (self.stat & 0x07);
                self.check_interrupt_sources();
            }
            SCROLL_Y_REG => self.scroll_y = data,
            SCROLL_X_REG => self.scroll_x = data,
            LY_REG => return, // read only
            LYC_REG => {
                self.lyc = data;
                if self.is_physics_processing_unit_enabled() {
                    self.update_stat_ly(self.ly_compare());
                }
            }
            BACKGROUND_PALETTE_REG => self.set_background_palette(data),
            OBJECT_PALETTE_0_REG => self.set_object_palette_0_palette(data),
            OBJECT_PALETTE_1_REG => self.set_object_palette_1_palette(data),
            WINDOW_Y_REG => self.window_y = data,
            WINDOW_X_REG => self.window_x = data,
            _ => panic!("Physics processing unit IO does not handle writes to: {:04X}", addr),
        }
    }

    pub fn set_ly(self: &mut Self, val: u8) {
        // unsafe {
        //     PRINT_DEBUG.add_data(format!("SET LY: {:02X}\n", val));
        // }
        self.ly = val;
        self.update_stat_ly(self.ly_compare());
    }

    // Check should also occur when LCD is shut down and enabled again
    // When the above occurs should also call update_stat_ly
    pub fn ly_compare(self: &Self) -> bool {
        return self.lyc == self.ly;
    }

    pub fn update_stat_ly(self: &mut Self, equal: bool) {
        if equal {
            self.stat = self.stat | 0x04;
        } else {
            self.stat = self.stat & 0xFB;
        }
        self.check_interrupt_sources();
    }

    // Dont call this except on state transitions
    pub fn set_stat_mode(self: &mut Self, mode: u8) {
        if mode == 0x01 && self.ly == 0x90 {
            self.vertical_blank_int = true;
        } else {
            self.vertical_blank_int = false;
        }
        self.stat = (self.stat & 0xFC) | mode; // Set the mode flag
        self.check_interrupt_sources();
    }

    // Only request interrupts on low to high
    pub fn check_interrupt_sources(self: &mut Self) {
        let mut new_stat_int = false;

        if self.lyc_int_match()
            || self.object_attribute_memory_int_match()
            || self.horizontal_blank_int_match()
            || self.vertical_blank_int_match()
        {
            new_stat_int = true;
        }
        if !self.stat_int && new_stat_int {
            self.stat_low_to_high = true;
        }
        self.stat_int = new_stat_int;
    }

    pub fn lyc_int_match(self: &mut Self) -> bool {
        let source = (self.stat & 0x40) == 0x40;
        let flag = (self.stat & 0x04) == 0x04;
        return source && flag;
    }

    pub fn object_attribute_memory_int_match(self: &mut Self) -> bool {
        let source = (self.stat & 0x20) == 0x20;
        let flag = (self.stat & 0x03) == 0x02;
        return source && flag;
    }

    pub fn horizontal_blank_int_match(self: &mut Self) -> bool {
        let source = (self.stat & 0x08) == 0x08;
        let flag = (self.stat & 0x03) == 0x00;
        return source && flag;
    }

    pub fn vertical_blank_int_match(self: &mut Self) -> bool {
        let source = (self.stat & 0x10) == 0x10;
        let flag = (self.stat & 0x03) == 0x01;
        return source && flag;
    }

    pub fn get_lcd_mode(self: &Self) -> u8 {
        return self.stat & 0x03;
    }

    // Im guessing the reason to assign a color to each index
    // and not have them be static is to allow for stuff like
    // inverting colors or making everything the same color
    // to make something like a silohoette appear.
    fn set_background_palette(self: &mut Self, data: u8) {
        self.background_palette = data;
    }

    fn set_object_palette_0_palette(self: &mut Self, mut data: u8) {
        self.object_palette_0 = data;
        data = data & 0x0FC; // For sprites color index 0 should be transparent
    }

    fn set_object_palette_1_palette(self: &mut Self, mut data: u8) {
        self.object_palette_1 = data;
        data = data & 0x0FC; // For sprites color index 0 should be transparent
    }

    // When bit 0 is cleared, the background and window become white (disabled) and
    // and the window display bit is ignored.
    pub fn is_bgw_enabled(self: &Self) -> bool {
        return (self.lcd_control & 0x01) == 0x01;
    }

    // Are sprites enabled or not (bit 1 of lcdc)
    pub fn is_spr_enabled(self: &Self) -> bool {
        return (self.lcd_control & 0x02) == 0x02;
    }

    // Are sprites a single tile or 2 stacked vertically (bit 2 of lcdc)
    pub fn is_big_sprite(self: &Self) -> bool {
        return (self.lcd_control & 0x04) == 0x04;
    }

    // Bit 3 controls what area to look for the bg tile map area
    // Returns the start and end address of video ram containing the 32x32 tile map
    pub fn get_background_tile_map(self: &Self) -> (u16, u16) {
        return match (self.lcd_control & 0x08) == 0x08 {
            false => (0x9800, 0x9BFF),
            true => (0x9C00, 0x9FFF),
        };
    }

    // Bit4 of lcd control gives Background and Window Tile data area
    // 1 will mean indexing from 0x8000, and 0 will mean addressing from 0x8800
    // However 8800 addressing actually means indexing from 0x9000
    pub fn get_addr_mode_start(self: &Self) -> u16 {
        return match (self.lcd_control & 0x10) == 0x10 {
            true => 0x8000,
            false => 0x9000,
        };
    }

    // Bit 5 controls whether the window is displayed or not.
    // Can be overriden by bit 0 hence the call to is_bgw_enabled
    pub fn is_window_enabled(self: &Self) -> bool {
        return (self.lcd_control & 0x20) == 0x20;
    }

    // Bit 6 controls what area to look for the window tile map area
    // Returns the start and end address of vram containing the 32x32 tile map
    pub fn get_window_tile_map(self: &Self) -> (u16, u16) {
        return match (self.lcd_control & 0x40) == 0x40 {
            false => (0x9800, 0x9BFF),
            true => (0x9C00, 0x9FFF),
        };
    }

    // LCD and PPU enabled when bit 7 of lcdc register is 1
    pub fn is_physics_processing_unit_enabled(self: &Self) -> bool {
        return (self.lcd_control & 0x80) == 0x80;
    }

    pub fn is_window_visible(self: &Self) -> bool {
        return (self.ly >= self.window_y)
            && ((self.ly as u16) < (self.window_y as u16) + 0x90)
            && (self.window_x <= 0xA6)
            && (self.window_y <= 0x8F);
    }

    /* Just to make some things cleaner elsewhere */
    pub fn ly(self: &Self) -> usize {
        return self.ly as usize;
    }

    pub fn scroll_x(self: &Self) -> usize {
        return self.scroll_x as usize;
    }

    pub fn scroll_y(self: &Self) -> usize {
        return self.scroll_y as usize;
    }

    pub fn window_x(self: &Self) -> usize {
        return self.window_x as usize;
    }

    pub fn window_y(self: &Self) -> usize {
        return self.window_y as usize;
    }
}