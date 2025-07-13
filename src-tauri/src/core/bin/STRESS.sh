#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/stresstest/init.sh"

# ---- INIT ----
TMPDIR=$(mktemp -d /tmp/toolbox.XXXXXXXX) || exit 1
trap 'rm -rf "$TMPDIR"' EXIT

declare -A ACTION_DESC=(
    [1]="Afficher l’état de la RAM"
    [2]="Afficher infos détaillées CPU"
    [3]="État et charge de la batterie"
    [4]="Afficher infos carte graphique"
    [5]="Afficher interfaces réseau"
    [6]="Diagnostic santé du disque"
    [7]="État SMART du disque"
    [8]="Stress-test du processeur"
    [9]="Détecter port USB (plug)"
    [10]="Tester micro"
    [11]="Tester la webcam"
    [12]="Tester la sortie audio"
    [13]="Tester le clavier (web)"
    [14]="Test de connexion Internet"
    [15]="Quitter la Toolbox"
)

declare -A ACTION_FUNC=(
    [1]=ram_report
    [2]=cpu_report
    [3]=battery_report
    [4]=gpu_report
    [5]=net_report
    [6]=disk_health
    [7]=disk_smart
    [8]=stress_cpu
    [9]=usb_test
    [10]=mic_test
    [11]=webcam_test
    [12]=sound_test
    [13]=keyboard_test
    [14]=conn_test
    [15]=break
)

main_menu() {
    local menu_items=()
    for i in {1..15}; do
        menu_items+=("$i" "${ACTION_DESC[$i]}")
    done

    local choice
    while true; do
        choice=$(dialog --clear --title "Maintenance" \
                --menu "Sélectionnez une action" 22 70 18 \
            "${menu_items[@]}" 3>&1 1>&2 2>&3) || break

        if [[ "${ACTION_FUNC[$choice]}" == "break" ]]; then
            break
        else
            ${ACTION_FUNC[$choice]}
        fi
    done
}

sudo_activate
main_menu
