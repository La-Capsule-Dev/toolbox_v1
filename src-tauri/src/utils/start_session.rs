use std::process::Command;
use std::{thread, time::Duration};

pub fn start_sudo_session() -> Result<(), String> {
    let status = Command::new("pkexec")
        .arg("bash")
        .arg("-c")
        .arg("sudo -v")
        .status()
        .map_err(|e| format!("Erreur pkexec : {}", e))?;

    if !status.success() {
        return Err("L'utilisateur a annulé ou refusé l'autorisation root.".to_string());
    }

    thread::spawn(|| {
        loop {
            let _ = Command::new("sudo").arg("-v").status();
            thread::sleep(Duration::from_secs(60));
        }
    });

    Ok(())
}
