use std::process::{Command, Stdio};

pub fn launch_stress_test() -> Result<(), String> {
    println!("🚀 Lancement du stress test (en tâche de fond)");

    Command::new("pkexec")
        .arg("stress-ng")
        .args([
            "--matrix", "0",
            "--ignite-cpu",
            "--log-brief",
            "--metrics-brief",
            "--times",
            "--tz",
            "--verify",
            "--timeout", "190",
            "-q",
        ])
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .spawn() 
        .map_err(|e| format!("Erreur lors du lancement du stress test : {}", e))?;

    Ok(())
}
