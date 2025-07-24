#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/ui/stress_tui.sh"


usb_test() {
    TMPDIR=$(mktemp -d)
    lsusb > "$TMPDIR/usb_before.txt"
    msg "Insérez un périphérique USB puis appuyez sur Entrée."
    read -r
    lsusb > "$TMPDIR/usb_after.txt"
    diffout=$(diff "$TMPDIR/usb_before.txt" "$TMPDIR/usb_after.txt" | awk '/^>/{print substr($0,3)}')
    if [[ -z "$diffout" ]]; then
        msg "Aucun périphérique détecté."
    else
        msg "Nouveau périphérique détecté :"
        msg "$diffout"
    fi
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
    TMPDIR=$(mktemp -d)
    # Test ping réseau (connectivité IP)
    if ping -c 2 -W 2 www.google.fr -q > "$TMPDIR/ping.txt"; then
        # Si ping OK, tester HTTP en clair
        if curl -s -I --max-time 4 www.google.fr | grep -q "HTTP/1.1 200 OK"; then
            msg "Connexion réseau : OK (ping et HTTP)."
        else
            msg "Réseau IP OK, mais HTTP NOK (curl ne voit pas HTTP 200)."
            msg "Détail curl :"
            curl -s -I --max-time 4 www.google.fr | head -5
        fi
    else
        msg "Pas de réseau IP (ping échoué)."
        msg "Détail ping :"
        cat "$TMPDIR/ping.txt"
    fi
}
