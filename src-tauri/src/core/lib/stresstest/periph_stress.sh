#!/usr/bin/env bash
set -euo pipefail


source "$LIB_DIR/stresstest/ui_stress_tui.sh"

usb_test() {
    safe_cmd lsusb lsusb > "$TMPDIR/usb_before.txt"
    msg "Insérez un périphérique USB et validez."
    safe_cmd lsusb lsusb > "$TMPDIR/usb_after.txt"
    diffout=$(diff "$TMPDIR/usb_before.txt" "$TMPDIR/usb_after.txt" | grep "ID" || true)
    [[ -z "$diffout" ]] && msg "Aucun périphérique détecté." || msg "Nouveau périphérique : $diffout"
}

mic_test() {
    safe_cmd arecord arecord -l | grep "^  card" > "$TMPDIR/cards.txt" || { msg "Aucune carte son."; return; }
    card=$(awk '{print $2}' "$TMPDIR/cards.txt" | head -n1)
    dev=$(awk '{print $6}' "$TMPDIR/cards.txt" | head -n1)
    [ -z "$card" ] && msg "Pas de carte son." && return
    devstr="hw:${card},${dev}"
    msg "Appuyez pour enregistrer 3s au micro."
    safe_cmd arecord arecord -f S16_LE -d 3 -c 1 --device="$devstr" "$TMPDIR/testmic.wav" >/dev/null 2>&1
    safe_cmd mplayer mplayer "$TMPDIR/testmic.wav" >/dev/null 2>&1 &
    msg "Lecture de l'enregistrement micro."
}

webcam_test() {
    shopt -s nullglob
    local cams=(/dev/video*)
    shopt -u nullglob
    if [[ ${#cams[@]} -eq 0 ]]; then
        msg "Aucune webcam détectée."
        return
    fi
    safe_cmd cheese sudo cheese "${cams[0]}"
}

sound_test() {
    safe_cmd mplayer mplayer $HOME/Developer/capsule/toolbox_v1/src-tauri/src/core/test/test.wav >/dev/null 2>&1 &
    msg "Test du son lancé."
}

keyboard_test() {
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "https://www.test-clavier.fr/"
    else
        msg "Aucun outil pour ouvrir un navigateur trouvé (xdg-open absent)."
    fi
}

conn_test() {
    safe_cmd ping ping -c 2 www.google.fr -q > "$TMPDIR/ping.txt" || { msg "Pas de réseau."; return; }
    safe_cmd curl curl -s -I www.google.fr | grep -q OK && msg "Connexion OK." || msg "Curl NOK."
}
