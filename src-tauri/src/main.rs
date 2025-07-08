// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod utils;
use utils::print_shell::call_print_checklist;

#[tauri::command]
fn print_checklist() -> Result<String, String> {
    call_print_checklist("src/core/gathering").map_err(|e| e.to_string())
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![print_checklist])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
