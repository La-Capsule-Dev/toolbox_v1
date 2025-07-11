pub fn launch_stress_test() -> Result<(), String> {
    use std::process::{Command, Stdio};

    Command::new("sudo")
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
        .map_err(|e| e.to_string())?;

    Ok(())
}
