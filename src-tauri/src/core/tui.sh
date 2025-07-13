#!/usr/bin/env bash
set -euo pipefail

export CORE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$CORE_DIR/etc/config/find_project_root.sh"
source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/ui/echo_status.sh"

BIN_DIR="${BIN_DIR:-$CORE_DIR/bin}"

main_menu() {
    local choices=()
    local i=1
    for action in "$BIN_DIR"/*.sh; do
        local name="$(basename "$action" .sh)"
        choices+=("$i" "$name")
        ((i++))
    done

    CHOICE=$(whiptail \
            --title "Sélectionnez une action" \
            --menu "Usage: choisissez et ENTER" 20 60 10 \
            "${choices[@]}" \
        3>&1 1>&2 2>&3)

    exit_status=$?
    if (( exit_status != 0 )); then
        echo "Annulé ou échoué (code $exit_status), sortie."
        exit 1
    fi

    # mapping de l’index choisi vers l’action
    local idx=$((CHOICE - 1))
    ACTION="${choices[$((idx*2+1))]}"
}

while true; do
    main_menu
    SCRIPT="$BIN_DIR/${ACTION}.sh"
    if [[ -f "$SCRIPT" && -x "$SCRIPT" ]]; then
        "$SCRIPT"
    elif [[ -f "$SCRIPT" ]]; then
        bash "$SCRIPT"
    else
        echo_status_error "Action inconnue ou script absent: $ACTION"
    fi
    echo "Appuyez sur ENTER pour revenir au menu principal."
    read -r
done
