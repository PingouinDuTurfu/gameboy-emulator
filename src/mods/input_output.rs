pub const IO_START: u16 = 0xFF00; // Adresse de base pour les registres d'entrée/sortie.
pub const IF_REG: u16 = 0xFF0F; // Registre d'interruption (Interrupt Flag Register) pour suivre les interruptions matérielles.
pub const DIV_REG: u16 = 0xFF04; // Registre du diviseur du temporisateur (Divider Register) pour le suivi du temps.
pub const TIMA_REG: u16 = 0xFF05; // Registre du compteur du temporisateur (Timer Counter Register) pour la gestion du compteur.
pub const TMA_REG: u16 = 0xFF06; // Registre du modificateur du temporisateur (Timer Modulo Register) pour la gestion des valeurs de débordement.
pub const TAC_REG: u16 = 0xFF07; // Registre de contrôle du temporisateur (Timer Control Register) pour la configuration du fonctionnement du temporisateur.
pub struct InputOutput {
    io: [u8; 128],
    if_register_trigger: bool,
}

impl InputOutput {

    pub fn new() -> InputOutput {
        InputOutput {
            io: [0xFF; 128],
            if_register_trigger: false,
        }
    }

    pub fn init(self: &mut Self) {
        self.io[usize::from(IF_REG - IO_START)] = 0xE1;
        self.io[usize::from(0xFF03 - IO_START)] = 0xFF;
    }

    pub fn read_byte(self: &Self, addr: u16) -> u8 {
        return self.io[usize::from(addr - IO_START)];
    }

    pub fn write_byte(self: &mut Self, addr: u16, data: u8) {
        match addr {
            IF_REG => {
                self.io[usize::from(IF_REG  - IO_START)] = data | 0xE0;
                self.if_register_trigger = true;
            }
            _ => return,
        }
    }

    pub fn clean_if_register_trigger(self: &mut Self) {
        println!("Requestiong clean IF register");
        self.if_register_trigger = false;
    }

    pub fn request_keypad_interrupt(self: &mut Self) {
        println!("Requestiong keypad interrupt");
        let if_register_trigger = usize::from(IF_REG - IO_START);
        self.io[if_register_trigger] = self.io[if_register_trigger] | 0xF0;
    }

    pub fn request_serial_interrupt(self: &mut Self) {
        println!("Requesting serial interrupt");
        let if_register_trigger = usize::from(IF_REG - IO_START);
        self.io[if_register_trigger] = self.io[if_register_trigger] | 0xE8;
    }

    pub fn request_timer_interrupt(self: &mut Self) {
        println!("Requesting timer interrupt");
        if !self.if_register_trigger {
            let if_register_trigger = usize::from(IF_REG - IO_START);
            self.io[if_register_trigger] = self.io[if_register_trigger] | 0xE4;
        }
    }

    pub fn request_stat_interrupt(self: &mut Self) {
        println!("Requesting stat interrupt");
        let if_register_trigger = usize::from(IF_REG - IO_START);
        self.io[if_register_trigger] = self.io[if_register_trigger] | 0xE2;
    }

    pub fn request_vblank_interrupt(self: &mut Self) {
        println!("Requesting vblank interrupt");
        let if_register_trigger = usize::from(IF_REG - IO_START);
        self.io[if_register_trigger] = self.io[if_register_trigger] | 0xE1;
    }
}

/*
    IO_START (0xFF00) : Cette constante définit l'adresse de base pour les registres d'entrée/sortie
    (I/O registers) de la Game Boy. De nombreux registres d'E/S de la console se trouvent dans cette
    plage d'adresses mémoire, allant de 0xFF00 à 0xFF7F.

    IF_REG (0xFF0F) : Ce registre est le registre d'interruption (Interrupt Flag Register). Il est
    utilisé pour indiquer quelles interruptions matérielles ont été déclenchées. Chaque bit de ce
    registre correspond à une interruption spécifique (par exemple, interruption V-Blank,
    interruption LCD STAT, interruption timer, etc.). Si un bit est défini (1), cela signifie que
    l'interruption correspondante a été déclenchée. Les programmes peuvent lire ce registre pour
    déterminer quelles interruptions sont actives.

    DIV_REG (0xFF04) : Ce registre est le registre du diviseur du temporisateur (Divider Register).
    Lorsqu'une valeur est écrite dans ce registre (quelle que soit cette valeur), le compteur du
    diviseur est réinitialisé à 0. Le diviseur est utilisé pour générer des interruptions régulières
    à la fréquence de base de la Game Boy.

    TIMA_REG (0xFF05) : Ce registre est le registre du compteur du temporisateur (Timer Counter
    Register). Il stocke la valeur du compteur du temporisateur. Lorsque le compteur atteint une
    valeur spécifique (souvent appelée "valeur de débordement"), une interruption est déclenchée. Le
    programme peut écrire dans ce registre pour définir la valeur de départ du compteur.

    TMA_REG (0xFF06) : Ce registre est le registre du modificateur du temporisateur (Timer Modulo
    Register). Il stocke la valeur de débordement qui est comparée avec le compteur du temporisateur
    (TIMA_REG) pour déterminer quand déclencher une interruption. Le programme peut écrire dans ce
    registre pour définir la valeur de débordement.

    TAC_REG (0xFF07) : Ce registre est le registre de contrôle du temporisateur (Timer Control
    Register). Il permet de contrôler le fonctionnement du temporisateur, y compris la fréquence à
    laquelle il incrémente, en spécifiant un "sélecteur de fréquence." Le programme peut écrire dans
    ce registre pour configurer le fonctionnement du temporisateur.

    Ces registres sont essentiels pour la gestion des interruptions, la synchronisation avec le
    matériel et la mise en œuvre de minuteries et de compteurs dans les jeux Game Boy. Ils font
    partie intégrante de la programmation de jeux pour la console.
 */