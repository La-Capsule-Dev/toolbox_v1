#!/usr/bin/env bash

set -euo pipefail

source "../utils/echo_status.sh"
printf "\e[8;22;50t"

cloning_disk(){

    # TODO: Add function disque dry avoid
    disque=$(sudo inxi -D |
        tr -d " " |
        sed '1,2d' |
        sed "s/ID-1:/Disque interne  :/" |
        sed "s/ID-2:/Disque interne  :/" |
        sed "s/\/dev/ $type/" |
        sed "s/type/\ntype            : /" |
        sed "s/vendor:/\nMarque          : /" |
        sed "s/model:/\nModèle          : /" |
        sed "s/size:/\nTaille          : /" |
        sed "s/used:/Utilisé         : /" |
        sed "s/GiB/ GiB\nétat            : $cible/" |
    sed "/^[[:space:]]*$/d")

    echo_status "            Listing des disques présents "
    echo "$disque" && echo_status_ok
    echo_status " Veuillez choisir le disque ou la partition MASTER "
    echo -n "/dev/" && read -r premierChoix
    echo_status "  Veuillez choisir le disque ou la partition SLAVE "

    echo -n "/dev/" && read -r secondChoix

    (pv -n | sudo dd if=/dev/$premierChoix of=/dev/$secondChoix bs=512 status=progress conv=sync,noerror && sync) 2>&1 | dialog --gauge "la commande dd est en cours d'exécution, merci de patienter..." 10 70 0

}

cloning_disk
