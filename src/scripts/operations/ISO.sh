#!/usr/bin/env bash

set -euo pipefail

source "../utils/echo_status.sh"

printf "\e[8;22;50t" 

echo_status_sleep "             Vérification des prérequis "

sudo apt update && echo_status_ok

echo_status_sleep "        Installation du paquet Penguin's EGG " 

PKG_OK=$(dpkg -s eggs | grep "Eggs est bien présent")
if [ "" = "$PKG_OK" ]; then
  echo "Penguin's EGG n'est pas installé, installation en cours..."
  sudo dpkg -i "/usr/share/LACAPSULE/MULTITOOL/Operations/eggs_9.6.8_amd64.deb"
fi 

echo_status_ok

sudo apt install -f
echo_status_sleep "            Début de production de l'ISO " 

$EDITOR bash -c 'sudo eggs produce --clone'

echo_status_sleep "                      Ouverture..."

