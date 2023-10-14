pub struct PrintDebug {
    pub debug: bool,
    pub data: String,
    pub global_index: u64,
    pub index: u64,
}

impl PrintDebug {
    pub fn new() -> PrintDebug {
        PrintDebug {
            debug: false,
            data: String::new(),
            global_index: 0,
            index: 0,
        }
    }

    pub fn add_data(self: &mut Self, data: String) {
        self.data.push_str(&data);
    }

    pub fn save_data(self: &mut Self) {
        use std::fs::File;
        use std::io::Write;
        let mut file = File::create("output.txt").expect("Impossible de créer le fichier");
        self.index = 0;
        match file.write_all(self.data.as_bytes()) {
            Ok(_) => println!("La chaîne a été écrite avec succès dans le fichier."),
            Err(e) => eprintln!("Erreur lors de l'écriture dans le fichier : {}", e),
        }
    }

    pub fn save_last_lines(self: &mut Self) {
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

    pub fn increment_index(self: &mut Self) {
        self.index += 1;
        self.global_index += 1;
    }
}