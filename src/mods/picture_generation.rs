use crate::mods::emulator::{BYTES_PER_TILE_SIGNED, convert_index4msb_to_rgba32, NUM_PIXELS_X};
use crate::mods::gpu_memory::{GpuMemory, OBJECT_ATTRIBUTE_MEMORY_END, OBJECT_ATTRIBUTE_MEMORY_START, RBG24_BYTES_PER_PIXEL, UNUSED_END, UNUSED_START, VIDEO_RAM_END, VIDEO_RAM_START};
use crate::mods::object_attribute_memory_search::ObjectAttributMemorySearch;
use crate::mods::physics_processing_unit::{MODE_HORIZONTAL_BLANK, PhysicsProcessingUnitState};

use super::horizontal_blank::HorizontalBlank;

pub struct PictureGeneration {
    cycles_counter: usize,
    fifo_state: FifoState,
    fetch_x: usize,             // x tile position in map
    byte_index: u8,             // Index with the tile we want
    bgw_lo: u8,                 // Lower byte of the background/window tile data
    bgw_hi: u8,                 // Upper byte of the background/window tile data
    scanline_pos: u8,           // Where in the scanline we are
    push_x: u8,                 // What pixel is to be pushed to the screen
    discard_pixels: u8,         // Number of pixels that have been discarded so far
    spr_indicies: Vec<usize>,   // Which sprites are to be displayed
    spr_data_lo: Vec<u8>,       // Lower byte of the sprite tile data
    spr_data_hi: Vec<u8>,       // Upper byte of the sprite tile data
    scx_lo: u8,                 // calculated at beggining of scanline and decides the number of pixels to discard
    scx_fifo: usize,            // calculated at beggining of fetch
    scy_fifo: usize,            // calculated at beggining of fetch
    map_addr: u16,              // calculated at beggining of fetch
    big_spr: bool,              // calculated at beggining of fetch
    bgw_enable: bool,           // calculated at beggining of fetch
    spr_enable: bool,           // Are sprites being rendered?
    window_y_trigger: bool,     // Window is both enabled and visible
}

pub enum FifoState {
    GetTile,
    GetTileDataLow,
    GetTileDataHigh,
    Sleep,
    Push
}

impl PictureGeneration {
    const SCANLINE_CYCLES: usize = 456;
    const FIFO_MIN_PIXELS: usize = 8;

    pub fn new() -> PictureGeneration {
        PictureGeneration {
            cycles_counter: 0,
            fifo_state: FifoState::GetTile,
            fetch_x: 0,
            byte_index: 0,
            bgw_lo: 0,
            bgw_hi: 0,
            scanline_pos: 0,
            push_x: 0,
            discard_pixels: 0,
            spr_indicies: Vec::new(),
            spr_data_lo: Vec::new(),
            spr_data_hi: Vec::new(),
            scx_lo: 0,
            scx_fifo: 0,
            scy_fifo: 0,
            map_addr: 0,
            big_spr: false,
            bgw_enable: false,
            spr_enable: false,
            window_y_trigger: false,
        }
    }

    fn next(self, gpu_mem: &mut GpuMemory) -> PhysicsProcessingUnitState {
        if (self.push_x) < NUM_PIXELS_X as u8 {
            PhysicsProcessingUnitState::PictureGeneration(self)
        } else {
            gpu_mem.set_stat_mode(MODE_HORIZONTAL_BLANK);
            HorizontalBlank::create(PictureGeneration::SCANLINE_CYCLES - ObjectAttributMemorySearch::MAX_CYCLES - self.cycles_counter)
        }
    }

    pub fn render(mut self, gpu_mem: &mut GpuMemory, cycles: usize) -> PhysicsProcessingUnitState {
        if self.cycles_counter == 0 {
            self.scx_lo = gpu_mem.scroll_x % 8;
            self.window_y_trigger = gpu_mem.is_window_enabled() && gpu_mem.is_window_visible();
        }
        for _ in 0..cycles {
            self.cycles_counter += 1;
            self.do_work(gpu_mem);

            if (self.push_x) >= NUM_PIXELS_X as u8 {
                break;
            }
        }
        self.next(gpu_mem)
    }

    pub fn do_work(&mut self, gpu_mem: &mut GpuMemory) {
        // Attempt every other dot
        if (self.cycles_counter % 2) == 0 {
            self.fifo_state = match self.fifo_state {
                FifoState::GetTile => self.get_tile_num(gpu_mem),
                FifoState::GetTileDataLow => self.get_tile_data_low(gpu_mem),
                FifoState::GetTileDataHigh => self.get_tile_data_high(gpu_mem),
                FifoState::Sleep => self.sleep(gpu_mem),
                FifoState::Push => self.push(gpu_mem)
            };
        } else if let FifoState::Push = self.fifo_state {
            self.fifo_state = self.push(gpu_mem);
        }
        self.pop_fifo(gpu_mem);
    }


    pub fn get_tile_num(&mut self, gpu_mem: &GpuMemory) -> FifoState {
        let curr_tile;
        let map_start;

        self.bgw_enable = gpu_mem.is_bgw_enabled();
        self.big_spr = gpu_mem.is_big_sprite();
        self.scx_fifo = gpu_mem.scroll_x();
        self.scy_fifo = gpu_mem.scroll_y();
        self.spr_enable = gpu_mem.is_spr_enabled();

        self.spr_indicies.clear();

        if self.bgw_enable {
            curr_tile = ((self.fetch_x + (self.scx_fifo / 8)) & 0x1F)
                + (32 * (((gpu_mem.ly() + self.scy_fifo) & 0xFF) / 8));
            map_start = (gpu_mem.get_background_tile_map().0 - VIDEO_RAM_START) as usize;

            self.byte_index = gpu_mem.video_ram[map_start + curr_tile];
        }

        if self.bgw_enable && self.window_y_trigger {
            self.find_window_tile_num(gpu_mem);
        }

        if self.spr_enable && !gpu_mem.sprite_list.is_empty() {
            self.search_spr_list(gpu_mem);
        }

        self.map_addr = PictureGeneration::calculate_addr(self.byte_index, gpu_mem);
        self.fetch_x += 1;
        FifoState::GetTileDataLow
    }

    fn find_window_tile_num(&mut self, gpu_mem: &GpuMemory) {
        let fetcher_pos = (self.fetch_x * 8) + 7;
        if fetcher_pos >= gpu_mem.window_x() {
            let index = (32 * (gpu_mem.window_line_counter as usize / 8))
                + (self.fetch_x - (gpu_mem.window_x() / 8))
                + usize::from(gpu_mem.get_window_tile_map().0);

            self.byte_index = gpu_mem.video_ram[index - usize::from(VIDEO_RAM_START)];
        }
    }

    fn search_spr_list(&mut self, gpu_mem: &GpuMemory) {
        for (i, sprite) in gpu_mem.sprite_list.iter().enumerate() {
            if sprite.x_pos < 168 && sprite.x_pos > 0 {
                // Sprite with xpos >= 168 or x == 0 should be hidden
                let sprx = usize::from(sprite.x_pos + (self.scx_lo));
                if ((sprx >= (self.fetch_x * 8) + 8) && (sprx < ((self.fetch_x * 8) + 16)))
                    || ((sprx + 8 >= (self.fetch_x * 8) + 8)
                        && (sprx + 8 < ((self.fetch_x * 8) + 16)))
                {
                    self.spr_indicies.push(i);
                }
            }
        }
    }

    pub fn get_tile_data_low(&mut self, gpu_mem: &GpuMemory) -> FifoState {
        let mut offset = 0;
        self.spr_data_lo.clear();

        if self.bgw_enable {
            offset = 2 * ((gpu_mem.ly() + self.scy_fifo) % 8) as u16;
        }

        if self.bgw_enable && self.window_y_trigger {
            offset = 2 * (gpu_mem.window_line_counter % 8) as u16;
        }

        if self.spr_enable && !self.spr_indicies.is_empty() {
            self.get_spr_tile_data(gpu_mem, 0);
        }

        self.bgw_lo = gpu_mem.video_ram[usize::from(self.map_addr + offset - VIDEO_RAM_START)];
        FifoState::GetTileDataHigh
    }

    pub fn get_tile_data_high(&mut self, gpu_mem: &GpuMemory) -> FifoState {
        let mut offset = 0;
        self.spr_data_hi.clear();

        if self.bgw_enable {
            offset = (2 * ((gpu_mem.ly() + self.scy_fifo) % 8) as u16) + 1;
        }

        if self.bgw_enable && self.window_y_trigger {
            offset = (2 * (gpu_mem.window_line_counter % 8) as u16) + 1;
        }

        if self.spr_enable && !self.spr_indicies.is_empty() {
            self.get_spr_tile_data(gpu_mem, 1);
        }

        self.bgw_hi = gpu_mem.video_ram[usize::from(self.map_addr + offset - VIDEO_RAM_START)];
        FifoState::Sleep
    }

    fn get_spr_tile_data(&mut self, gpu_mem: &GpuMemory, offset: usize) {
        let ly = gpu_mem.ly as i32;
        let spr_height = if self.big_spr { 16 } else { 8 };
        let mut tile_index;

        for i in &self.spr_indicies {
            let spr = &gpu_mem.sprite_list[*i];
            let mut y_offset = (ly + 16) - (spr.y_pos as i32);
            if spr.flip_y {
                y_offset = (spr_height - 1) - y_offset;
            }

            tile_index = if spr_height == 16 {
                spr.tile_index & 0xFE
            } else {
                spr.tile_index
            };

            let index = ((tile_index as i32) * 16) + (y_offset * 2);
            if offset == 0 {
                self.spr_data_lo.push(gpu_mem.video_ram[index as usize]);
            } else {
                self.spr_data_hi.push(gpu_mem.video_ram[index as usize + offset]);
            }
        }
    }

    pub fn sleep(&mut self, _gpu_mem: &mut GpuMemory) -> FifoState {
        FifoState::Push
    }

    pub fn push(&mut self, gpu_mem: &mut GpuMemory) -> FifoState {
        if gpu_mem.background_pixel_fifo.len() > 8 {
            return FifoState::Push;
        }
        self.get_color_and_push(gpu_mem);

        FifoState::GetTile
    }

    fn get_color_and_push(&mut self, gpu_mem: &mut GpuMemory) {
        for shift in 0..=7 {
            let p1 = (self.bgw_hi >> (7 - shift)) & 0x01;
            let p0 = (self.bgw_lo >> (7 - shift)) & 0x01;
            let bit_col = (p1 << 1 | p0) as usize;

            let bg_color = if self.bgw_enable { bit_col } else { 0 };
            let mut color = gpu_mem.background_colors_as_sdl_pixel_format_index4msb[bg_color];

            if !self.spr_indicies.is_empty() {
                color = self.fetch_and_merge(gpu_mem, bg_color)
            }

            gpu_mem.background_pixel_fifo.push_back(color);
            self.scanline_pos += 1;
        }
    }

    fn fetch_and_merge(&mut self, gpu_mem: &GpuMemory, bg_col: usize) -> u8 {
        let mut spr_scr_xpos;
        let mut spr;
        for (list_idx, orig_idx) in self.spr_indicies.iter().enumerate() {
            spr = &gpu_mem.sprite_list[*orig_idx];
            spr_scr_xpos = (spr.x_pos as i32) - 8 + (self.scx_lo) as i32;

            let mut offset = self.scanline_pos as i32 - spr_scr_xpos;
            if !(0..=7).contains(&offset) {
                continue;
            }

            if spr.flip_x {
                offset = 7 - offset;
            }

            let p1 = (self.spr_data_hi[list_idx] >> (7 - offset)) & 0x01;
            let p0 = (self.spr_data_lo[list_idx] >> (7 - offset)) & 0x01;
            let bit_col = (p1 << 1 | p0) as usize;

            if (!spr.priority || bg_col == 0) && (bit_col != 0) {

                return if spr.dot_matrix_game_palette {
                    gpu_mem.object_colors_1_as_sdl_pixel_format_index4msb[bit_col]
                } else {
                    gpu_mem.object_colors_2_as_sdl_pixel_format_index4msb[bit_col]
                };
            }
        }

        gpu_mem.background_colors_as_sdl_pixel_format_index4msb[bg_col]
    }

    fn pop_fifo(&mut self, gpu_mem: &mut GpuMemory) {
        if gpu_mem.background_pixel_fifo.len() > PictureGeneration::FIFO_MIN_PIXELS {
            let pixel: Option<u8> = gpu_mem.background_pixel_fifo.pop_front();
            if let Some(val) = pixel {
                if ((self.scx_lo) <= self.discard_pixels) | self.window_y_trigger {
                    let index = usize::from(gpu_mem.ly) * NUM_PIXELS_X as usize * RBG24_BYTES_PER_PIXEL + usize::from(self.push_x) * RBG24_BYTES_PER_PIXEL;
                    let rgba32 = convert_index4msb_to_rgba32(val);
                    gpu_mem.rgba32_pixels[index..(2 + index + 1)].copy_from_slice(&rgba32[..(2 + 1)]);
                    self.push_x += 1;
                } else {
                    self.discard_pixels += 1;
                }
            }
        }
    }

    pub fn read_byte(&self, _gpu_mem: &GpuMemory, addr: u16) -> u8 {
        match addr {
            VIDEO_RAM_START..=VIDEO_RAM_END => 0xFF,
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => 0xFF,
            UNUSED_START..=UNUSED_END => 0x00, // Try returning 0xFF here
            _ => panic!("PPU (Pict Gen) doesnt read from address: {:04X}", addr),
        }
    }

    pub fn write_byte(&mut self, _gpu_mem: &mut GpuMemory, addr: u16, _data: u8) {
        match addr {
            VIDEO_RAM_START..=VIDEO_RAM_END => (),
            OBJECT_ATTRIBUTE_MEMORY_START..=OBJECT_ATTRIBUTE_MEMORY_END => (),
            UNUSED_START..=UNUSED_END => (),
            _ => panic!("PPU (Pict Gen) doesnt write to address: {:04X}", addr),
        }
    }

    fn calculate_addr(tile_index: u8, gpu_mem: &GpuMemory) -> u16 {
        match gpu_mem.get_addr_mode_start() {
            0x8000 => 0x8000 + (u16::from(tile_index) * 16),
            0x9000 => (0x9000 + (isize::from(tile_index as i8) * BYTES_PER_TILE_SIGNED)) as u16,
            _ => panic!("get_addr_mode only returns 0x9000 or 0x8000"),
        }
    }
}
