#!/usr/bin/env bash
set -euo pipefail

#HACK: Improve later

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/echo_status.sh"
source "$SCRIPT_DIR/utils/loop-pkgs.sh"

clean_up(){

    REQUIRED_PKGS=("dmidecode" "curl" "sed" "tr" "smartmontools" "skdump" "inxi" "acpi" "xrandr" "python3" "iconv" "enscrypt" "ps2pdf" "htop" "upower" "hardinfo" "arecord" "ffplay" "glxgears" "glmark2" "screentest" "libatasmart-bin" "smartctl" "nmon" "iptraf-ng" "s-tui" "stress")

    printf "\e[8;22;50t"

    echo_status "           Début du nettoyage intégral... "
    echo_status " Obtention des droits sur les fichiers vérouillés "
    echo_status "Veuillez entrer votre mot de passe administrateur "

    sudo chown $USER -R /var/lib/dpkg/* && sudo chown $USER -R /var/cache/apt/* && echo_status_ok

    echo_status "          Réparation des paquets cassés "

    sudo apt update && sudo apt --fix-broken install && sudo apt --fix-missing && sudo apt autoclean && sudo apt autoremove &&
    echo_status_ok
    echo_status "                     NETTOYAGE  "

    sync && sudo sysctl vm.drop_caches=3 && swapon -s && free -m

    # Utilisation de la Loop pour remove PKGS
    remove_pkgs REQUIRED_PKGS

    sudo dpkg -r "MULTITOOL/eggs_9.6.8_amd64.deb" && sudo apt remove boot-repair && echo_status_ok
    echo_status "              Vidage du répertoire /tmp "
    sudo rm -r ~/tmp/* && echo_status_ok
    echo_status "               Purge du cache système "
    sudo rm -r /home/$USER/.cache/* && echo_status_ok
    echo_status "   Vidage des fichiers contenus dans la corbeille "
    sudo rm -r /home/$USER/.local/share/Trash/files/* && echo_status_ok
    echo_status "    Vidage des informations de fichiers supprimés "
    sudo rm -r /home/$USER/.local/share/Trash/info/* && echo_status_ok
    echo_status "         Nettoyage effectué avec succès "
}

clean_up
