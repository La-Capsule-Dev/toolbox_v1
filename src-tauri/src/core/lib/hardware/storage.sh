#!/usr/bin/env bash

set -euo pipefail

source "$DIR_ROOT/lib/utils/logging.sh"
# Stockage de masse

cible_parser() {
    dev=$(lsblk -ndo NAME,TYPE | awk '$2=="disk"{print "/dev/"$1; exit}')
    log_info "Analyse SMART sur $dev"
    output=$(sudo skdump --overall "$dev" 2>&1)
    status=$?
    if echo "$output" | grep -q "Failed to read SMART data"; then
        log_warn "SMART non supporté sur $dev"
    fi
    if [ $status -ne 0 ]; then
        log_error "Erreur d'exécution skdump ($dev): $output"
    fi
    echo "$output" | grep -v "Failed to read SMART data" | sed \
        -e "s/GOOD/BON/" \
        -e "s/BAD/MAUVAIS/"
}

type_parser(){
    sudo lsblk -o name,rota | tail | sed \
        -e "s/loop.*$//" \
        -e "s/sr0.*$//" \
        -e "/^[[:space:]]*$/d" \
        -e "1,8d" \
        -e "s/sda       1/HDD/" \
        -e "s/NAME//" \
        -e "s/ROTA//" \
        -e "s/nvme*/SSD/"
}


disque_parser(){

    type=$(type_parser)
    cible=$(cible_parser)

    sudo inxi -D | tr -d " " | sed \
        -e '1,2d' \
        -e "s/ID-1:/Disque interne  :/" \
        -e "s/ID-2:/Disque interne  :/" \
        -e "s/\/dev/ $type/" \
        -e "s/type/\ntype            : /" \
        -e "s/vendor:/\nMarque          : /" \
        -e "s/model:/\nModèle          : /" \
        -e "s/size:/\nTaille          : /" \
        -e "s/used:/Utilisé         : /" \
        -e "s/GiB/ GiB\nétat            : $cible/" \
        -e "/^[[:space:]]*$/d"
}
