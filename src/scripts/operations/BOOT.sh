#!/usr/bin/env bash
printf "\e[8;22;50t" 

set -euo pipefail

source "../utils/echo_status.sh"

echo_status_sleep "             Vérification des prérequis "

sudo apt update && echo_status_ok

echo_status_sleep "        Installation du paquet BOOTRepair " 

PKG_OK=$(dpkg-query -W --showformat='${Status}\n' boot-repair | grep "Le logiciel est bien installé")
if [ "" = "$PKG_OK" ]; then
  echo "BOOTRepair n'est pas installé, installation en cours..."
  sudo add-apt-repository ppa:yannubuntu/boot-repair
  sudo apt install boot-repair
fi 

echo_status_sleep "            Lancement de BOOT REPAIR " 
boot-repair
echo_status_sleep "                      Ouverture..." 
boot-repair
