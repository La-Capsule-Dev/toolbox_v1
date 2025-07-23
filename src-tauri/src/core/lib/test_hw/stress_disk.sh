#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/ui/stress_tui.sh"

# -- Détecte le "type" du disque pour choisir le backend
get_disk_type() {
    local dev="/dev/$1"
    [[ "$1" =~ ^nvme ]] && echo "nvme" && return
    # Si tu veux affiner : parsers via udevadm ou lsblk -o TYPE
    echo "scsi"
}

# -- Sélection de disque (avec whiptail, adapt. possible)
select_disk() {
    local -a disks descs
    while read -r name; do
        desc=$(lsblk -dn -o MODEL,SIZE "/dev/$name" 2>/dev/null | awk '{$1=$1;print}' | head -n1)
        disks+=("$name" "$desc")
    done < <(lsblk -dn -o NAME,TYPE | awk '$2=="disk"{print $1}')

    (( ${#disks[@]} == 0 )) && { msg "Aucun disque détecté." ; return 1; }

    DISK=$(whiptail --clear --title "Disque" --menu "Choisissez le disque" 20 60 10 "${disks[@]}" 3>&1 1>&2 2>&3) || return 2
    echo "$DISK"
}

# -- Backend analyse SMART
analyze_smart() {
    local disk="$1"
    local type="$2"
    local outfile="$TMPDIR/smart-$disk.txt"

    case "$type" in
        nvme)
            if command -v nvme >/dev/null 2>&1; then
                sudo nvme smart-log "/dev/$disk" > "$outfile" 2>&1 || true
            else
                sudo smartctl -a -d nvme "/dev/$disk" > "$outfile" 2>&1 || true
            fi
            ;;
        scsi|*)
            if command -v skdump >/dev/null 2>&1; then
                sudo skdump --overall "/dev/$disk" > "$outfile" 2>&1 || true
            else
                sudo smartctl -a "/dev/$disk" > "$outfile" 2>&1 || true
            fi
            ;;
    esac

    # Détection d’échec/absence de SMART
    if grep -Eqi "not supported|SMART Disabled|error|failed" "$outfile"; then
        msg "Le disque /dev/$disk ne supporte pas SMART, ou SMART désactivé."
        return 1
    fi

    cat "$TMPDIR/smart-$disk.txt"
    show_output "SMART $disk" "$outfile"
}

# -- Fonction unique orchestrant le tout
stress_disk() {
    local disk
    disk=$(select_disk) || return
    local type
    type=$(get_disk_type "$disk")
    analyze_smart "$disk" "$type"
}
