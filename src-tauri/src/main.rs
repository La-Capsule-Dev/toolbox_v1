// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod utils;
use utils::print_shell::call_print_checklist;

fn main() {
    let script_dir = "src/core/gathering"; // à adapter selon le layout réel
    match call_print_checklist(script_dir) {
        Ok(res) => println!("Checklist sortie:\n{}", res),
        Err(e) => eprintln!("Erreur checklist: {}", e),
    }
    // Ajoute un return explicite si toolbox_lib::run() retourne Result
    // toolbox_lib::run()
}
