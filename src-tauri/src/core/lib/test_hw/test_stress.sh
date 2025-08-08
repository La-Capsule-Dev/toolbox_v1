#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/ui/stress_tui.sh"

# Validation des périphériques
validate_device() {
    local device="$1"
    [[ -e "$device" && -r "$device" ]]
}

#TODO: LE tester
usb_test() {
    local tmpdir before_file after_file
    tmpdir=$(mktemp -d) || return 1
    before_file="$tmpdir/usb_before.txt"
    after_file="$tmpdir/usb_after.txt"

    # Nettoyage automatique
    trap 'rm -rf "$tmpdir"' RETURN

    # Capture de l'état initial
    if ! lsusb > "$before_file" 2>/dev/null; then
        msg "Erreur: impossible de lister les périphériques USB"
        return 1
    fi

    msg "Insérez un périphérique USB puis appuyez sur Entrée."
    read -r

    # Capture après insertion
    if ! lsusb > "$after_file" 2>/dev/null; then
        msg "Erreur: impossible de relister les périphériques USB"
        return 1
    fi

    # Analyse des différences
    local diffout
    diffout=$(diff "$before_file" "$after_file" | awk '/^>/{print substr($0,3)}')

    if [[ -z "$diffout" ]]; then
        msg "Aucun nouveau périphérique détecté."
        return 1
    else
        msg "Nouveau périphérique détecté :"
        msg "$diffout"

        # Validation optionnelle du montage
        if mount | grep -q usb; then
            msg "Périphérique monté avec succès."
        fi
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

#TODO: Améliorer
# Test connexion réseau robuste
conn_test() {
    local tmpdir ping_file
    tmpdir=$(mktemp -d) || return 1
    ping_file="$tmpdir/ping.txt"

    trap 'rm -rf "$tmpdir"' RETURN

    msg "Test de connectivité réseau en cours..."

    # Test ping avec timeout
    if timeout 10 ping -c 3 -W 2 8.8.8.8 > "$ping_file" 2>&1; then
        # Test HTTP/HTTPS
        if curl -s -I --connect-timeout 5 --max-time 10 https://www.google.com | grep -q "HTTP.*200"; then
            msg "Connexion réseau : ✅ OK (ping et HTTPS)"

            # Test de résolution DNS
            if nslookup google.com >/dev/null 2>&1; then
                msg "Résolution DNS : ✅ OK"
            else
                msg "Résolution DNS : ⚠️ Problème détecté"
            fi
        else
            msg "Réseau IP OK, mais accès web limité"
            msg "Détails ping :"
            tail -3 "$ping_file"
        fi
    else
        msg "❌ Pas de connectivité réseau"
        if [[ -s "$ping_file" ]]; then
            msg "Détails :"
            tail -3 "$ping_file"
        fi
        return 1
    fi
}
