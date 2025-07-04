#!/usr/bin/env bash
set -euo pipefail

#HACK: Improve later
source "../utils/echo_status.sh"
source "../utils/loop-pkgs.sh"

printf "\e[8;22;50t" 

echo_status_sleep "           Début du nettoyage intégral... " 
echo_status_sleep " Obtention des droits sur les fichiers vérouillés " 
echo_status_sleep "Veuillez entrer votre mot de passe administrateur " 

sudo chown $USER -R /var/lib/dpkg/* && sudo chown $USER -R /var/cache/apt/* && echo_status_ok

echo_status_sleep "          Réparation des paquets cassés "

sudo apt update && sudo apt --fix-broken install && sudo apt --fix-missing && sudo apt autoclean && sudo apt autoremove &&
echo_status_ok
echo_status_sleep "                     NETTOYAGE  "

sync && sudo sysctl vm.drop_caches=3 && swapon -s && free -m

# Utilisation de la Loop pour remove PKGS 
install_or_remove_pkgs "remove"

sudo dpkg -r "MULTITOOL/eggs_9.6.8_amd64.deb" && sudo apt remove boot-repair && echo_status_ok
echo_status_sleep "              Vidage du répertoire /tmp "
sudo rm -r ~/tmp/* && echo_status_ok
echo_status_sleep "               Purge du cache système "
sudo rm -r /home/$USER/.cache/* && echo_status_ok
echo_status_sleep "   Vidage des fichiers contenus dans la corbeille "
sudo rm -r /home/$USER/.local/share/Trash/files/* && echo_status_ok
echo_status_sleep "    Vidage des informations de fichiers supprimés "
sudo rm -r /home/$USER/.local/share/Trash/info/* && echo_status_ok
echo_status_sleep "         Nettoyage effectué avec succès "
