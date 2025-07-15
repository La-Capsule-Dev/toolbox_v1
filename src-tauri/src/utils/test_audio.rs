use std::process::Command;

// Test des sorties audio
pub fn play_audio_test() -> Result<(), String> {
    let exe_path = std::env::current_exe()
        .map_err(|e| format!("Impossible d'obtenir current_exe : {}", e))?;

    let resource_path = exe_path
        .parent()
        .ok_or("Pas de parent pour current_exe")?
        .join("resources")
        .join("frequency.wav");

    if !resource_path.exists() {
        return Err(format!("Fichier introuvable à : {:?}", resource_path));
    }

    Command::new("aplay")
        .arg(resource_path)
        .spawn()
        .map_err(|e| format!("Erreur lors de la lecture audio : {}", e))?;

    Ok(())
}

// Joue une musique pour patienter pendant le stress test. Parce qu'on est sympa.
pub fn play_during_stress() -> Result<(), String> {
    let exe_path = std::env::current_exe()
        .map_err(|e| format!("Impossible d'obtenir current_exe : {}", e))?;

    let resource_path = exe_path
        .parent()
        .ok_or("Pas de parent pour current_exe")?
        .join("resources")
        .join("emmtddmc.wav");

    if !resource_path.exists() {
        return Err(format!("Fichier introuvable à : {:?}", resource_path));
    }

    Command::new("aplay")
        .arg(resource_path)
        .spawn()
        .map_err(|e| format!("Erreur lors de la lecture audio : {}", e))?;

    Ok(())
}
