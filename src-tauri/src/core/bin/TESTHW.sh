#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/test_hw/init.sh"

# ---- INIT ----
TMPDIR=$(mktemp -d /tmp/toolbox.XXXXXXXX) || exit 1
trap 'rm -rf "$TMPDIR"' EXIT


# Descriptions et fonctions associées
declare -A ACTION_DESC=(
    [1]="Test du processeur"
    [2]="Test disque dur"
    [3]="Test port USB (plug)"
    [4]="Tester micro"
    [5]="Tester la webcam"
    [6]="Tester la sortie audio"
    [7]="Tester le clavier (web)"
    [8]="Test de connexion Internet"
    [9]="Vérifier la pile RTC/CMOS"
    [10]="Quitter la Toolbox"
)

declare -A ACTION_FUNC=(
    [1]=cpu_report
    [2]=stress_disk
    [3]=usb_test
    [4]=mic_test
    [5]=webcam_test
    [6]=sound_test
    [7]=keyboard_test
    [8]=conn_test
    [9]="check_cmos_battery"
    [10]=break
)

main_menu() {
    local menu_items=()
    for i in {1..10}; do
        menu_items+=("$i" "${ACTION_DESC[$i]}")
    done

    while :; do
        CHOICE=$(whiptail --clear \
                --title "🔧 Maintenance Toolbox" \
                --menu "Sélectionnez une action :" 22 70 15 \
                "${menu_items[@]}" \
            3>&1 1>&2 2>&3) || break

        if [[ "${ACTION_FUNC[$CHOICE]}" == "break" ]]; then
            break
        else
            "${ACTION_FUNC[$CHOICE]}"
            whiptail --title "✔️ Action terminée" \
                --msgbox "Action $CHOICE : ${ACTION_DESC[$CHOICE]} terminée." 6 60
        fi
    done
}

sudo_activate
main_menu
