#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${BIN_DIR%%/core*}/core"
source "$DIR_ROOT/lib/stress-test/init.sh"
source "$DIR_ROOT/lib/utils/init.sh"
source "$DIR_ROOT/etc/config/stress-pkgs.sh"

function stress_test {
    # Store menu options selected by the user
    INPUT=/tmp/menu.sh.$$

    # Storage file for displaying cal and date command output
    OUTPUT=/tmp/output.sh.$$

    # trap and delete temp files
    trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

    #
    # Purpose - display output using msgbox
    #  $1 -> set msgbox height
    #  $2 -> set msgbox width
    #  $3 -> set msgbox title
    #

    # mettre le clavier en français
    setxkbmap fr

    # activation des droits administrateur
    sudo_activate

    # set infinite loop
    while true
    do
        ### display main menu ###
        display_menu

        # make decsion
        case $menuitem in
            Information_système_en_graphique ) infoSysteme ;;
            Test_du_moniteur ) testMoniteur ;;
            Relevé_RAM ) releveRAM ;;
            Relevé_CPU ) releveCPU ;;
            Relevé_batterie ) releveBatterie ;;
            Relevé_réseau ) releveReseau ;;
            Santé_disque ) santeDisque ;;
            Infos_disque ) infoDisque ;;
            Infos_carte_graphique ) infoGPU ;;
            Stress_test_du_CPU ) stressCPU ;;
            Test_des_ports_USB) test_usb ;;
            Test_son ) testSon ;;
            Test_micro ) test_micro ;;
            Test_webCam ) test_webcam ;;
            Test_Clavier ) testClavier ;;
            Test_Connexion_internet) testConnexionInternet ;;
            Ré_installer_les_logiciels ) install_pkgs "${STRESS_PKGS[@]}" ;;
            MAJ_du_système ) maj_system ;;
            Quit) echo "Bye"; break ;;
        esac

    done

    # if temp files found, delete em
    [ -f $OUTPUT ] && rm $OUTPUT
    [ -f $INPUT ] && rm $INPUT
}

display_menu(){

    dialog --clear  --help-button --backtitle "Maintenance" \
        --title "Menu principal" \
        --menu "Vous pouvez utiliser les touches Haut ou Bas, la première \n\
	afficher en subrillance , ou les \n\
	nombre du clavier pour faire votre choix.\n\
        Choose the TASK" 80 80 80 \
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
        Quit "" 2>"${INPUT}"

    menuitem=$(<"${INPUT}")

}

stress_test
