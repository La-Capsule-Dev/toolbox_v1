// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

mod utils;
use std::fs;
use std::process::Command;
use base64::{engine::general_purpose, Engine as _};
use utils::{
    start_session::start_sudo_session,
    stress::launch_stress_test,
    test_audio::{play_audio_test, play_during_stress},
    port_test::test_usb_ports,
};
use std::env;

#[tauri::command]
fn get_cpu_temperature() -> Vec<(String, f32)> {
    let mut results = Vec::new();
    
    // Essayer d'abord avec sensors
    match Command::new("sensors").output() {
        Ok(output) => {
            let output_str = String::from_utf8_lossy(&output.stdout);
            
            for line in output_str.lines() {
                if line.contains("temp") && line.contains("°C") {
                    // Extraire le nom du capteur et la température
                    if let Some(temp_part) = line.split(':').nth(1) {
                        let temp_str = temp_part.trim();
                        if let Some(temp_value) = temp_str.split_whitespace().next() {
                            let clean_temp = temp_value.replace("°C", "").replace("+", "");
                            if let Ok(temp) = clean_temp.parse::<f32>() {
                                let sensor_name = line.split(':').next().unwrap_or("Unknown").trim();
                                results.push((sensor_name.to_string(), temp));
                            }
                        }
                    }
                }
            }
        }
        Err(e) => {
            println!("Erreur lors de l'exécution de sensors: {}", e);
        }
    }
    
    if results.is_empty() {
        println!("Aucun capteur trouvé avec sensors, essai avec /sys/class/thermal"); 
        match fs::read_dir("/sys/class/thermal") {
            Ok(zones) => {
                for entry in zones.flatten() {
                    let path = entry.path();
                    if path.join("type").exists() && path.join("temp").exists() {
                        let label = fs::read_to_string(path.join("type"))
    .unwrap_or_default()
    .trim()
    .to_string();

let temp_str = fs::read_to_string(path.join("temp")).unwrap_or_default();
if let Ok(temp_raw) = temp_str.trim().parse::<f32>() {
    let temp = temp_raw / 1000.0;
    results.push((label.clone(), temp)); 
    println!("Found thermal zone: {} = {}°C", label, temp);
}
                    }
                }
            }
            Err(e) => {
                println!("Erreur lors de la lecture de /sys/class/thermal: {}", e);
            }
        }
    }
    
    results
}

#[tauri::command]
fn print_checklist() -> Result<String, String> {
    let current_dir = env::current_dir().map_err(|e| e.to_string())?;
    let script_path = current_dir.join("src").join("core").join("main.sh");
    
    let output = std::process::Command::new("bash")
        .arg(&script_path)
        .arg("PRINT")
        .stdout(std::process::Stdio::piped())
        .stderr(std::process::Stdio::inherit())
        .output()
        .map_err(|e| e.to_string())?;

    if !output.status.success() {
        return Err(format!("Shell command failed (status {})", output.status));
    }
    Ok(String::from_utf8_lossy(&output.stdout).into_owned())
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

#[tauri::command]
fn play_audio() -> Result<(), String> {
    play_audio_test()
}

#[tauri::command]
fn play_stress_sound() -> Result<(), String> {
    play_during_stress()
}

#[tauri::command]
fn test_usb_ports_command() -> Result<Vec<String>, String> {
    test_usb_ports()
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            print_checklist,
            start_session,
            stress_test,
            get_cpu_temperature,
            get_pdf_base64,
            play_audio,
            play_stress_sound,
            test_usb_ports_command
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
