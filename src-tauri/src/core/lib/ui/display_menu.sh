#!/usr/bin/env bash

# Affiche le menu principal, retourne le choix sur stdout (et code de retour 1 si annulation)
display_menu() {
    local input
    input=$(mktemp)
    dialog --clear --help-button --backtitle "Maintenance" \
        --title "Menu principal" \
        --menu "Choisissez la tâche :" 20 70 15 \
        Information_système_en_graphique "" \
        Test_du_moniteur "" \
        Relevé_RAM "" \
        Relevé_CPU "" \
        Relevé_batterie "" \
        Relevé_réseau "" \
        Santé_disque "" \
        Infos_disque "" \
        Infos_carte_graphique "" \
        Stress_test_du_CPU "" \
        Test_des_ports_USB "" \
        Test_son "" \
        Test_micro "" \
        Test_webCam "" \
        Test_Clavier "" \
        Test_Connexion_internet "" \
        Ré_installer_les_logiciels "" \
        MAJ_du_système "" \
        Quit "" 2>"$input"
    local code=$?
    local menuitem=""
    if [[ $code -eq 0 ]]; then
        menuitem=$(<"$input")
    fi
    rm -f "$input"
    [[ -n "$menuitem" ]] && echo "$menuitem" || return 1
}
