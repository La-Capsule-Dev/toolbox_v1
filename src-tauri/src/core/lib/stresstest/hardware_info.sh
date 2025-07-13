#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/stresstest/ui_stress_tui.sh"

ram_report()    { safe_cmd inxi sudo inxi -m > "$TMPDIR/ram.txt" && show_output "Relevé RAM" "$TMPDIR/ram.txt"; }
cpu_report()    { safe_cmd inxi sudo inxi -C > "$TMPDIR/cpu.txt" && show_output "Relevé CPU" "$TMPDIR/cpu.txt"; }
gpu_report()    { safe_cmd inxi sudo inxi -G > "$TMPDIR/gpu.txt" && show_output "Info GPU" "$TMPDIR/gpu.txt"; }
net_report()    { safe_cmd inxi sudo inxi -N > "$TMPDIR/net.txt" && show_output "Info réseau" "$TMPDIR/net.txt"; }
# TODO: VERIFY ON LAPTOP
battery_report(){ safe_cmd acpi sudo acpi -i > "$TMPDIR/batt.txt" && show_output "Batterie" "$TMPDIR/batt.txt"; }
