#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/stresstest/init.sh"

# ---- INIT ----
TMPDIR=$(mktemp -d /tmp/toolbox.XXXXXXXX) || exit 1
trap 'rm -rf "$TMPDIR"' EXIT

# TODO: Modifier stress et template
# Test machine : heure -> A voir pour vérifier la pile
# Nettoyage intérieur à la fin

# Descriptions et fonctions associées
declare -A ACTION_DESC=(
    [1]="Test du processeur"
    [2]="Test port USB (plug)"
    [3]="Tester micro"
    [4]="Tester la webcam"
    [5]="Tester la sortie audio"
    [6]="Tester le clavier (web)"
    [7]="Test de connexion Internet"
    [8]="Quitter la Toolbox"
)

declare -A ACTION_FUNC=(
    [1]=stress_cpu
    [2]=usb_test
    [3]=mic_test
    [4]=webcam_test
    [5]=sound_test
    [6]=keyboard_test
    [7]=conn_test
    [8]=break
)

main_menu() {
    local menu_items=()
    for i in {1..15}; do
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
