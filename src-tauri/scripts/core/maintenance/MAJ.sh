#!/usr/bin/env bash
set -euo pipefail

#HACK: Improve later
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils/echo_status.sh"
source "$SCRIPT_DIR/utils/loop-pkgs.sh"

launch_maj(){

    REQUIRED_PKGS=("dmidecode" "curl" "sed" "tr" "smartmontools" "skdump" "inxi" "acpi" "xrandr" "python3" "iconv" "enscrypt" "ps2pdf" "htop" "upower" "hardinfo" "arecord" "ffplay" "glxgears" "glmark2" "screentest" "libatasmart-bin" "smartctl" "nmon" "iptraf-ng" "s-tui" "stress")

    printf "\e[8;22;50t"

    echo "          Début du script de maintenance... "

    echo_status " Obtention des droits sur les fichiers vérouillés "
    echo_status "Veuillez entrer votre mot de passe administrateur "

    sudo chown $USER -R /var/lib/dpkg/* && sudo chown $USER -R /var/cache/apt/* && echo_status_ok
    echo_status "            Réparation des paquets cassés "

    sudo apt --fix-broken install  && echo_status_ok
    echo_status "        Autocomplétion des fichiers manquants "

    sudo apt --fix-missing install  && echo_status_ok
    echo_status "           Chargement des nouveaux paquets "

    sudo apt update && echo_status_ok
    echo_status " Téléchargement et installation des nouveaux paquets "


    # Utilisation de la Loop pour remove PKGS
    install_pkgs REQUIRED_PKGS

    echo_status_ok
    echo_status "              Mise à niveau du système "

    sudo apt upgrade -y && sudo apt full-upgrade -y && echo_status_ok
    echo_status " Appuyer sur les touches ctrl+c pour annuler la purge" 10.5
    echo "             $(tput setaf 1)    !!! ATTENTION !!!  "
    echo_status "              LA PURGE VA COMMENCER ! "
    echo ""
    echo "                        $(tput setaf 1) ➎" &&
    echo "                         ➍" &&
    echo "                         ➌" &&
    echo "                         ➋" &&
    echo "                         ➊" &&

    echo_status "          Nettoyage du système de fichiers "
    sudo apt autoclean -y && echo_status_ok
    echo_status "          Suppression des fichiers inutiles "
    sudo apt autoremove -y && echo_status_ok
    echo_status "              Vidage du répertoire /tmp "
    sudo rm -r ~/tmp/* && echo_status_ok
    echo_status "               Purge du cache système "
    sudo rm -r /home/$USER/.cache/* && echo_status_ok
    echo_status "   Vidage des fichiers contenus dans la corbeille "
    sudo rm -r /home/$USER/.local/share/Trash/files/* && echo_status_ok
    echo_status "    Vidage des informations de fichiers supprimés "
    sudo rm -r /home/$USER/.local/share/Trash/info/* && echo_status_ok

    echo ""
    echo ""
    echo_status "    $(tput setaf 1)$(tput setab 7) La maintenance a été effectuée avec succès "
    echo_status "                       👍👍👍"
    echo ""
    echo ""
}
launch_maj
