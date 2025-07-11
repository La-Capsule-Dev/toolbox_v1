// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use std::fs;
mod utils;
use utils::print_shell::call_print_checklist;
use utils::start_session::start_sudo_session;
use utils::stress::launch_stress_test;

#[tauri::command]
fn get_cpu_temperature() -> Vec<(String, f32)> {
    let mut results = Vec::new();
    let zones = fs::read_dir("/sys/class/thermal").unwrap();

    for entry in zones.flatten() {
        let path = entry.path();
        if path.join("type").exists() && path.join("temp").exists() {
            let label = fs::read_to_string(path.join("type"))
                .unwrap_or_default()
                .trim()
                .to_string();

            let temp_str = fs::read_to_string(path.join("temp")).unwrap_or_default();
            if let Ok(temp_raw) = temp_str.trim().parse::<f32>() {
                results.push((label, temp_raw / 1000.0));
            }
        }
    }

    results
}

#[tauri::command]
fn print_checklist() -> Result<String, String> {
    call_print_checklist("src/core/bin").map_err(|e| e.to_string())
}

#[tauri::command]
fn start_session() -> Result<(), String>  {
    start_sudo_session()
}

#[tauri::command]
fn stress_test() -> Result<(), String> {
    launch_stress_test()
}



fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![print_checklist])
        .invoke_handler(tauri::generate_handler![start_session])
        .invoke_handler(tauri::generate_handler![stress_test])
        .invoke_handler(tauri::generate_handler![get_cpu_temperature])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
