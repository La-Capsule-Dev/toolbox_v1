// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod utils;
use std::fs;
use utils::print_shell::call_print_checklist;
use utils::start_session::start_sudo_session;
use utils::stress::launch_stress_test;
use base64::{engine::general_purpose, Engine as _};

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
    launch_stress_test().map_err(|e| e.to_string())
}

#[tauri::command]
fn get_pdf_base64() -> Result<String, String> {
    let home = dirs::home_dir().ok_or("Pas de home")?;
    let path = home.join("resultat.pdf");
    let bytes = fs::read(&path).map_err(|e| e.to_string())?;
    let b64 = general_purpose::STANDARD.encode(&bytes);

    Ok(format!("data:application/pdf;base64,{}", b64))
}



fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            print_checklist,
            start_session,
            stress_test,
            get_cpu_temperature,
            get_pdf_base64
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
