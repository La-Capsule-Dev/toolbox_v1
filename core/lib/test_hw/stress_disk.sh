#!/usr/bin/env bash
set -euo pipefail
source "$LIB_DIR/ui/stress_tui.sh"

# -- Détecte le "type" du disque pour choisir le backend
get_disk_type() {
    local dev="/dev/$1"
    [[ "$1" =~ ^nvme ]] && echo "nvme" && return
    echo "scsi"
}

# -- Sélection de disque (whiptail, adapt. possible)
select_disk() {
    local disks=() desc name descs
    while read -r name; do
        desc=$(lsblk -dn -o MODEL,SIZE "/dev/$name" 2>/dev/null | awk '{$1=$1;print}' | head -n1)
        disks+=("$name" "$desc")
    done < <(lsblk -dn -o NAME,TYPE | awk '$2=="disk"{print $1}')

    if (( ${#disks[@]} == 0 )); then
        msg "Aucun disque détecté."
        return 1
    fi

    local DISK
    DISK=$(whiptail --clear --title "Disque" --menu "Choisissez le disque" 20 60 10 "${disks[@]}" 3>&1 1>&2 2>&3) || return 2
    echo "$DISK"
}

# -- Backend analyse SMART
analyze_smart() {
    local disk="$1"
    local type="$2"
    local outfile="${TMPDIR:-/tmp}/smart-$disk.txt"

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

    if grep -Eqi "not supported|SMART Disabled|error|failed" "$outfile"; then
        msg "Le disque /dev/$disk ne supporte pas SMART, ou SMART désactivé."
        return 1
    fi

    cat "$outfile"
    show_output "SMART $disk" "$outfile"
}

stress_disk() {
    local disk
    disk=$(select_disk) || return
    local type
    type=$(get_disk_type "$disk")
    analyze_smart "$disk" "$type"
}
