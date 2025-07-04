#!/usr/bin/env bash

set -euo pipefail

source "../utils/echo_status.sh"

printf "\e[8;22;50t" 

echo_status "             Vérification des prérequis "

sudo apt update && echo_status_ok

echo_status "        Installation du paquet Penguin's EGG " 

# TODO: Modifier le curl pour ne pas défendre de node ou le laisser ainsi
PKG_OK=$(dpkg -s eggs | grep "Eggs est bien présent")
if [ "" = "$PKG_OK" ]; then
  echo "Penguin's EGG n'est pas installé, installation en cours..."
  curl -fsSL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh
  sudo -E bash nodesource_setup.sh
  sudo dpkg -i penguins-eggs-10.0.5-1_amd64.deb
fi 


sudo apt install -f && echo_status_ok
echo_status "            Début de production de l'ISO " 

$EDITOR bash -c 'sudo eggs produce --clone'

echo_status "                      Ouverture..."

