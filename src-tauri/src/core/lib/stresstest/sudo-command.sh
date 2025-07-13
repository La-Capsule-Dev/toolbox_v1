#!/usr/bin/env bash
set -euo pipefail

command_exists() { command -v "$1" >/dev/null 2>&1; }

sudo_activate() {
    local data
    data=$(mktemp)

    dialog --title "Demande mot de passe root" \
        --clear \
        --insecure \
        --passwordbox "Saisissez votre mot de passe" 10 30 2> "$data"
    local ret=$?

    case $ret in
        0)
            local pwd
            pwd=$(cat "$data")
            [ -z "$pwd" ] && { rm -f "$data"; echo "Aucun mot de passe fourni."; return 1; }
            echo "$pwd" | sudo -S -v 2>/dev/null || { rm -f "$data"; echo "Mauvais mot de passe ou accès refusé."; return 1; }
            rm -f "$data"
            ;;
        1)  rm -f "$data"; echo "Annulé par l'utilisateur." ;;
        255) rm -f "$data"; echo "Touche ESC appuyée." ;;
    esac
}

safe_cmd() {
    # wrapper : exécute et fallback si binaire absent
    command_exists "$1" || { msg "Commande $1 non trouvée."; return 1; }
    shift; "$@"
}
