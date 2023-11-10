pub struct PrintDebug {
    pub debug: bool,
    pub data: String,
    pub global_index: u64,
    pub index: u64,
    pub already_printed_video_ram: bool,
}

impl PrintDebug {

    pub fn add_data(&mut self, data: String) {
        self.data.push_str(&data);
    }

    pub fn add_video_ram_table_data(&mut self, data: [u8; (0x9FFF - 0x8000) as usize + 1]) {
        if self.already_printed_video_ram {
            return;
        }
        self.already_printed_video_ram = true;
        for i in 0..data.len() {
            self.data.push_str(&format!("{:02X} ", data[i]));
            if i % 16 == 15 {
                self.data.push_str("\n");
            }
        }
    }

    pub fn save_data(&mut self) {
        use std::fs::File;
        use std::io::Write;
        let mut file = File::create("output.txt").expect("Impossible de créer le fichier");
        self.index = 0;
        match file.write_all(self.data.as_bytes()) {
            Ok(_) => (),
            Err(e) => eprintln!("Erreur lors de l'écriture dans le fichier : {}", e),
        }
    }

    pub fn save_last_lines(&mut self) {
        use std::fs::File;
        use std::io::Write;
        let mut file = File::create("output_partial.txt").expect("Impossible de créer le fichier");
        let mut lines = self.data.lines();
        let mut last_lines = String::new();
        for _ in 0..1000 {
            if let Some(line) = lines.next_back() {
                last_lines.push_str(line);
                last_lines.push_str("\n");
            }
        }
        match file.write_all(last_lines.as_bytes()) {
            Ok(_) => println!("La chaîne a été écrite avec succès dans le fichier."),
            Err(e) => eprintln!("Erreur lors de l'écriture dans le fichier : {}", e),
        }
    }

    pub fn increment_index(&mut self) {
        self.index += 1;
        self.global_index += 1;
    }
}