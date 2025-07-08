use std::process::{Command, Stdio};
// Learn more about Tauri commands at https://tauri.app/develop/calling-rust/
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}

#[tauri::command]
fn call_print_checklist(script_dir: &str) -> Result<String, String> {
    let script_path = format!("{}/PRINT.sh", script_dir);
    let output = Command::new("bash")
        .arg(&script_path)
        .stdout(Stdio::piped())
        .stderr(Stdio::inherit())
        .output()
        .map_err(|e| format!("Erreur à l'exécution du script : {}", e))?;

    if !output.status.success() {
        return Err(format!(
            "Le script a échoué (code {})",
            output.status
        ));
    }

    Ok(String::from_utf8_lossy(&output.stdout).into_owned())
}



#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_shell::init())
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![greet, call_print_checklist])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
