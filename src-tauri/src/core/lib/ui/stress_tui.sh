#!/usr/bin/env bash
set -euo pipefail

msg() {
    dialog --msgbox "$1" 12 60;
}
show_output() {
    dialog --title "$1" --msgbox "$(<"$2")" 20 60;
}
