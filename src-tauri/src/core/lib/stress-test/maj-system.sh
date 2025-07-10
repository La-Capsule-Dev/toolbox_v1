#!/usr/bin/env bash
set -euo pipefail

maj_systeme() {
    local DIALOG=${DIALOG:=dialog}
    local -a steps=(
        "Mise à jour de la liste des paquets existants:sudo apt update -y"
        "Mise à jour des logiciels:sudo apt upgrade -y"
        "Suppression des logiciels non nécessaires:sudo apt autoremove -y"
        "Suppression du cache logiciel:sudo apt autoclean -y"
    )

    local step_count=${#steps[@]}
    local increment=$((100 / step_count))
    local current=0

    (
        for step in "${steps[@]}"; do
            local msg="${step%%:*}"
            local cmd="${step##*:}"

            cat <<EOF
XXX
$current
$msg
XXX
EOF
            eval "$cmd" >/dev/null 2>&1
            current=$((current + increment))
        done
    ) |
    $DIALOG --title "Mise à Jour du système" --gauge "Temps(s)" 20 70 0
}
