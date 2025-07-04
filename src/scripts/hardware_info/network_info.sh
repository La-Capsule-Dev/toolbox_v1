#!/usr/bin/env bash

set -euo pipefail

# Cartes Réseaux 
reseau_parser(){
  sudo inxi -N | sed \
    -e "s/Network://" \
    -e "s/  Device-1/Carte numéro 1  /" \
    -e "s/  Device-2/Carte numéro 2  /" \
    -e "s/  Device-3/Carte numéro 3  /" \
    -e "s/ 802.11.*$/ Carte WIFI/" \
    -e "s/ Gigabit Ethernet/ Carte ETHERNET/" \
    -e "s/ Ethernet Adapter/ Carte ETHERNET/" \
    -e "s/type: .*$//" \
    -e "s/driver: .*$//" \
    -e "/^[[:space:]]*$/d" 
}
