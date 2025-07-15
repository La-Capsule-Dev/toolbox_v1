#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/ui/echo_status.sh"
source "$LIB_DIR/shred/core_disk.sh"

secure_erase_disk(){
    local disk="$1"
    local dev="/dev/$disk"

    [[ -b "$dev" ]] || { echo_status_error "$dev n'existe pas."; return 1; }

    echo_status_warn "Effacement sécurisé de $dev lancé..."
    if command -v nvme &>/dev/null && nvme list | grep -qw "$dev"; then
        echo -e "Référence des disques NVMe connectés :"
        nvme list || echo_status_warn "(Aucun NVMe détecté)"
        echo "-----------------------------------------------------------------"
        echo -e "Liste des disques connectés :"
        lsblk -x NAME | awk '{print " -", $1, "-->", $4, " "}'
        echo "-----------------------------------------------------------------"
        echo_status "Type NVMe SSD détecté, format secure erase."
        sudo nvme format -s1 "$dev"

    elif sudo hdparm -I "$dev" 2>/dev/null | grep -qi 'not frozen'; then
        echo_status "SATA SSD/HDD détecté, exécution de hdparm secure-erase."
        sudo hdparm --user-master u --security-set-pass p "$dev"
        sudo hdparm --user-master u --security-erase p "$dev"

    else
        echo -e "Liste des disques connectés :"
        lsblk -x NAME | awk '{print " -", $1, "-->", $4, " "}'
        echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
        echo_status "HDD détecté, utilisation de shred."
        sudo shred -v -n1 -z "$dev"
    fi

    verify_disk "$disk"
}
