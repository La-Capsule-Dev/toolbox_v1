#!/usr/bin/env bash

set -euo pipefail

# HACK: Refactor
source "$LIB_DIR/utils/logging.sh"
# Stockage de masse

cible_parser() {
    local dev="$1"
    if [[ -z "$dev" ]]; then
        log_error "Aucun périphérique spécifié pour analyse SMART"
        return 1
    fi

    log_info "Analyse SMART sur $dev"
    local output
    output=$(sudo skdump --overall "$dev" 2>&1)
    local status=$?
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
type_parser() {
    sudo lsblk -ndo NAME,ROTA | awk '
    $1 ~ /^loop/ || $1 ~ /^sr0/ { next }
    $2 == 1 { print "HDD" }
    $2 == 0 { print "SSD" }
    ' | sort -u
}


disque_parser() {
    local types
    types=$(type_parser)
    if [[ -z "$types" ]]; then
        echo "Type de disque : N/A"
        return
    fi

    # Prendre le premier disque physique (nom) pour SMART (ex: /dev/sda ou /dev/nvme0n1)
    local dev
    dev=$(sudo lsblk -ndo NAME,TYPE | awk '$2=="disk"{print "/dev/"$1; exit}')

    # Appel SMART avec disque choisi
    # TODO: ADD SMART pour NVMe
    local smart_status
    smart_status=$(cible_parser "$dev")

    # Infos inxi formatées
    local inxi_info
    inxi_info=$(sudo inxi -D 2>/dev/null | sed \
            -e '1,2d' \
            -e 's/ID-1:/Disque interne : /' \
            -e 's/ID-2:/Disque interne : /' \
            -e 's/\/dev.*/Type disque : '"$types"'/' \
            -e 's/type/\nType            : /' \
            -e 's/vendor:/\nMarque          : /' \
            -e 's/model:/\nModèle          : /' \
            -e 's/size:/\nTaille          : /' \
            -e 's/used:/Utilisé         : /' \
            -e 's/GiB/ GiB/' \
        -e '/^[[:space:]]*$/d')

    # Sortie claire
    echo -e "${inxi_info}\nÉtat SMART :\n${smart_status}"
}
