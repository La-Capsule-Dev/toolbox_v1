#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${BIN_DIR%%/core*}/core"
source "$DIR_ROOT/lib/hw/storage.sh"
source "$DIR_ROOT/utils/echo_status.sh"

#TODO: TODO LATER
cloning_disk(){

    disque=$(disque_parser)
    echo_status "Listing des disques présents "
    echo "$disque" && echo_status_ok
    echo_status " Veuillez choisir le disque ou la partition MASTER "
    echo -n "/dev/" && read -r premierChoix
    echo_status "  Veuillez choisir le disque ou la partition SLAVE "
    echo -n "/dev/" && read -r secondChoix

    (pv -n | sudo dd if=/dev/$premierChoix of=/dev/$secondChoix bs=512 status=progress conv=sync,noerror\
        && sync) 2>&1 | dialog --gauge "la commande dd est en cours d'exécution, merci de patienter..." 10 70 0

}

cloning_disk
