#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/ui/stress_tui.sh"

# TODO: Voir nvme cli + datasata pour HDD
# REFACTORISE EN UNE SEULE FONCTION
disk_smart() {
    local DISK
    DISK=$(lsblk -dn -o NAME | grep -E '^sd|^nvme' | head -n1)
    [[ -z "$DISK" ]] && { msg "Aucun disque trouvé."; return; }
    safe_cmd smartctl sudo smartctl -H "/dev/$DISK" > "$TMPDIR/smart.txt" 2>&1 || true
    # Détection explicite des erreurs connues (ex : not supported)
    if grep -Eqi "not supported|error|failed|SMART Disabled" "$TMPDIR/smart.txt"; then
        msg "Le disque /dev/$DISK ne supporte pas SMART, ou SMART désactivé."
        return
    fi
    show_output "SMART $DISK" "$TMPDIR/smart.txt"
}

disk_health() {
    local -a disks=()
    while read -r name; do
        desc=$(lsblk -dn -o MODEL,SIZE "/dev/$name" 2>/dev/null | awk '{$1=$1;print}' | head -n1)
        disks+=("$name" "$desc")
    done < <(lsblk -dn -o NAME | grep -E '^sd|^nvme')

    if [[ ${#disks[@]} -eq 0 ]]; then
        msg "Aucun disque détecté."
        return
    fi

    local DISK
    DISK=$(whiptail --clear --title "Disque" --menu "Choisissez le disque" 20 60 10 "${disks[@]}" 3>&1 1>&2 2>&3) || return

    local devtype
    if [[ "$DISK" =~ ^nvme ]]; then
        devtype="nvme"
        sudo smartctl -a -d nvme "/dev/$DISK" > "$TMPDIR/disk.txt" 2>&1 || true
    else
        devtype="scsi"
        safe_cmd skdump sudo skdump --overall "/dev/$DISK" > "$TMPDIR/disk.txt" 2>&1 || true
    fi

    if grep -Eqi "Failed to read SMART data|Operation not supported|SMART Disabled|not supported" "$TMPDIR/disk.txt"; then
        msg "Le disque /dev/$DISK ne supporte pas SMART ou nécessite un outil différent."
        return
    fi
    show_output "Santé disque $DISK" "$TMPDIR/disk.txt"
}
