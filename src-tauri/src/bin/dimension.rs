use regex::Regex;
use std::process::Command;

fn dimension() {
    let output = Command::new("xrandr")
        .output()
        .expect("failed to execute xrandr");
    let out = String::from_utf8_lossy(&output.stdout);

    let re = Regex::new(r"([0-9]+)mm x ([0-9]+)mm").unwrap();
    for cap in re.captures_iter(&out) {
        let w: f64 = cap[1].parse().unwrap();
        let h: f64 = cap[2].parse().unwrap();
        let diag = ((w.powi(2) + h.powi(2)).sqrt()) / 25.4;
        println!("Taille en pouces: {:.1}", diag);
    }
}
