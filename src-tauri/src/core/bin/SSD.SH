#!/usr/bin/env bash
set -euo pipefail

# SSD.sh — Menu d’effacement sécurisé des disques NVMe (CLI Bash)
#
# Auteur : binary-grunt — github.com/Binary-grunt - 25/07/05

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/ui/echo_status.sh"

shred_nvme(){
    # -- Vérification des dépendances --
    for cmd in nvme lsblk awk sudo; do
        command -v "$cmd" >/dev/null ||  echo_status_error "Erreur : $cmd non trouvé"
    done
    # -- Affichage du contexte matériel --
    echo -e "Référence des disques NVMe connectés :"
    nvme list || echo "(Aucun NVMe détecté)"
    echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
    echo -e "Liste des disques connectés :"
    lsblk -x NAME | awk '{print " -", $1, "-->", $4, " "}'
    echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

    # -- Menu interactif d’effacement sécurisé --
    source "$DIR_ROOT/lib/shred/shred_disk.sh"

    # Commande d’effacement adaptée aux NVMe : (simulation, à activer explicitement)
    shred_disk "sudo nvme format -s2 /dev/%s && sudo blkdiscard /dev/%s" || echo_status_error "Échec du shred_disk HDD"
    echo_status_ok "Shred du HDD fini et réussi"
}

shred_nvme

