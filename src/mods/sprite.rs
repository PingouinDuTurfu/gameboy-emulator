pub struct Sprite {
    pub y_pos: u8,
    pub x_pos: u8,
    pub tile_index: u8,
    pub priority: bool,
    pub flip_y: bool,
    pub flip_x: bool,
    pub dot_matrix_game_palette: bool,
}

impl Sprite {
    pub fn new(sprite_bytes: &[u8]) -> Sprite {
        Sprite {
            y_pos: sprite_bytes[0],
            x_pos: sprite_bytes[1],
            tile_index: sprite_bytes[2],
            priority: (sprite_bytes[3] >> 7) & 0x01 == 0x01,
            flip_y: (sprite_bytes[3] >> 6) & 0x01 == 0x01,
            flip_x: (sprite_bytes[3] >> 5) & 0x01 == 0x01,
            dot_matrix_game_palette: (sprite_bytes[3] >> 4) & 0x01 == 0x01,
        }
    }
}