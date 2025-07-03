#!/usr/bin/env bash
set -euo pipefail

source "../utils/echo_status.sh"
source "../utils/loop-pkgs.sh"

printf "\e[8;22;50t" 

echo "          Début du script de maintenance... " 

echo_status_sleep " Obtention des droits sur les fichiers vérouillés " 
echo_status_sleep "Veuillez entrer votre mot de passe administrateur "

sudo chown $USER -R /var/lib/dpkg/* && sudo chown $USER -R /var/cache/apt/* && echo_status_ok 
echo_status_sleep "            Réparation des paquets cassés "

sudo apt --fix-broken install  && echo_status_ok
echo_status_sleep "        Autocomplétion des fichiers manquants "

sudo apt --fix-missing install  && echo_status_ok
echo_status_sleep "           Chargement des nouveaux paquets "
 
sudo apt update && echo_status_ok
echo_status_sleep " Téléchargement et installation des nouveaux paquets "


install_or_remove_pkgs "install"

echo_status_ok
echo_status_sleep "              Mise à niveau du système "

sudo apt upgrade -y && sudo apt full-upgrade -y && echo_status_ok

echo_status_sleep " Appuyer sur les touches ctrl+c pour annuler la purge" 10.5

echo "             $(tput setaf 1)    !!! ATTENTION !!!  "
echo_status_sleep "              LA PURGE VA COMMENCER ! "

echo "" 
echo "                        $(tput setaf 1) ➎" &&
echo "                         ➍" &&
echo "                         ➌" &&
echo "                         ➋" &&
echo "                         ➊" &&

echo_status_sleep "          Nettoyage du système de fichiers " 
sudo apt autoclean -y && echo_status_ok
echo_status_sleep "          Suppression des fichiers inutiles " 
sudo apt autoremove -y && echo_status_ok
echo_status_sleep "              Vidage du répertoire /tmp "
sudo rm -r ~/tmp/* && echo_status_ok
echo_status_sleep "               Purge du cache système "
sudo rm -r /home/$USER/.cache/* && echo_status_ok
echo_status_sleep "   Vidage des fichiers contenus dans la corbeille "
sudo rm -r /home/$USER/.local/share/Trash/files/* && echo_status_ok
echo_status_sleep "    Vidage des informations de fichiers supprimés "
sudo rm -r /home/$USER/.local/share/Trash/info/* && echo_status_ok

echo ""
echo ""
echo_status_sleep "    $(tput setaf 1)$(tput setab 7) La maintenance a été effectuée avec succès "
echo_status_sleep "                       👍👍👍" 
echo ""
echo ""
