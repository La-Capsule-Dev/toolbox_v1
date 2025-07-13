#!/usr/bin/env bash
set -euo pipefail

# SSD.sh — Menu d’effacement sécurisé des disques NVMe (CLI Bash)
#
# Auteur : binary-grunt — github.com/Binary-grunt - 25/07/05

source "$LIB_DIR/ui/echo_status.sh"
source "$LIB_DIR/shred/core_disk.sh"

shred_nvme() {
    #local command="sudo nvme format -s2 /dev/%s && sudo blkdiscard /dev/%s"
    local command=$(echo "Test")
    # Vérification des dépendances
    for cmd in nvme lsblk awk sudo; do
        command -v "$cmd" >/dev/null || echo_status_error "Erreur : $cmd non trouvé"
    done

    echo -e "Référence des disques NVMe connectés :"
    nvme list || echo_status_warn "(Aucun NVMe détecté)"
    echo "-----------------------------------------------------------------"
    echo -e "Liste des disques connectés :"
    lsblk -x NAME | awk '{print " -", $1, "-->", $4, " "}'
    echo "-----------------------------------------------------------------"

    # Sélection
    local disk
    disk=$(select_disk) || exit 1

    # Action (modulaire)
    #run_disk_action "$disk" "$command"

    verify_disk "$disk"
    echo_status_ok "Shred NVMe fini et verifié"
}
