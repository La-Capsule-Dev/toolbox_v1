#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/hw/storage.sh"
source "$LIB_DIR/ui/echo_status.sh"

# TODO: IMPROVE
cloning_disk() {
    echo_status "📋 Liste des disques/partitions disponibles (disque_parser) :"
    disque=$(disque_parser)
    echo "$disque"

    # Saisie sécurisée des périphériques
    read -rp "🔹 Disque SOURCE (/dev/...) : " src
    read -rp "🔹 Disque DESTINATION (/dev/...) : " dst

    # Vérifier que les deux sont des devices valides et différents
    if [[ "$src" == "$dst" ]]; then
        echo_status_error "❌ Source et destination identiques."
    fi
    for d in "$src" "$dst"; do
        if [[ ! -b "$d" ]]; then
            echo_status_error "❌ $d n’est pas un périphérique bloc valide."
        fi
    done

    echo_status "🔄 Clonage en cours de $src vers $dst..."

    # Bande passante ajustable
    local bs="4M"

    # Utilisation de dd avec status=progress si disponible, sinon fallback pv
    if dd --help | grep -q 'status=progress'; then
        # dd moderne
        sudo dd if="$src" of="$dst" bs="$bs" conv=sync,noerror,status=progress
    else
        # Utiliser pv si présent
        if command -v pv > /dev/null; then
            sudo dd if="$src" conv=sync,noerror bs="$bs" | pv -n -s "$(block_size "$src")" | sudo dd of="$dst" bs="$bs" conv=sync,noerror
        else
            echo_status_warn "⚠️ ni dd avec progrès ni pv disponibles ; clonage en cours sans feedback"
            sudo dd if="$src" of="$dst" bs="$bs" conv=sync,noerror
        fi
    fi
    sync

    echo_status_ok "✅ Clonage terminé."
}

# Fonction utilitaire : récupérer taille en bytes pour pv
block_size() {
    local dev="$1"
    awk '/Size:/{print $3 * ( $4=="GiB"?1024^3:($4=="MiB"?1024^2:1) )}' < <(lsblk -b -o NAME,TYPE,SIZE "/dev/${dev##*/}")
}

cloning_disk

# cloning_disk(){
#
#     disque=$(disque_parser)
#     echo_status "Listing des disques présents "
#     echo "$disque" && echo_status_ok
#     echo_status " Veuillez choisir le disque ou la partition MASTER "
#     echo -n "/dev/" && read -r premierChoix
#     echo_status "  Veuillez choisir le disque ou la partition SLAVE "
#     echo -n "/dev/" && read -r secondChoix
#
#     (pv -n | sudo dd if=/dev/$premierChoix of=/dev/$secondChoix bs=512 status=progress conv=sync,noerror\
    #         && sync) 2>&1 | dialog --gauge "la commande dd est en cours d'exécution, merci de patienter..." 10 70 0
#
# }
#
# cloning_disk
