use std::io;
use std::process::{Command, Stdio};

pub fn call_print_checklist(script_dir: &str) -> io::Result<String> {
    let script_path = format!("{}/PRINT.sh", script_dir);
    let output = Command::new("bash")
        .arg(&script_path)
        .stdout(Stdio::piped())
        .stderr(Stdio::inherit())
        .output()?;

    if !output.status.success() {
        return Err(io::Error::new(
            io::ErrorKind::Other,
            format!("Shell command failed (status {})", output.status),
        ));
    }
    Ok(String::from_utf8_lossy(&output.stdout).into_owned())
}
