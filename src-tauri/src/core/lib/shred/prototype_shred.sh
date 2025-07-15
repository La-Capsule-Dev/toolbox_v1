#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/ui/echo_status.sh"

# -- Affichage contextuel de l'état des disques --
show_header() {
    echo -e "Référence des disques NVMe connectés :"
    nvme list 2>/dev/null || echo_status_warn "(Aucun NVMe détecté)"
    echo "-----------------------------------------------------------------"
    echo -e "Liste des disques connectés :"
    lsblk -x NAME | awk '{print " -", $1, "-->", $4, " "}'
    echo "-----------------------------------------------------------------"
}

# -- Sélectionne un disque (CLI natif, non graphique) --
select_disk() {
    mapfile -t DEVICES < <(
        lsblk -dn -o NAME,SIZE,TYPE,MOUNTPOINT | \
            awk '$3=="disk"{print $1 " (" $2 ") " ($4==""?"-":$4)}'
    )
    echo "Sélectionnez un disque :" >&2
    select entry in "${DEVICES[@]}"; do
        [[ -n $entry ]] || { echo_status_warn "Choix invalide." >&2; continue; }
        local dname mnt
        dname=$(awk '{print $1}' <<< "$entry")
        mnt=$(awk '{print $3}' <<< "$entry")
        if [[ "$mnt" != "-" ]]; then
            echo_status_warn "ATTENTION : /dev/$dname est monté sur $mnt !" >&2
            read -p "Continuer quand même ? [o/N] " really
            [[ $really =~ ^[oO]$ ]] ||  { echo_status_error "Annulé."; return 2; }
        fi
        echo "$dname"
        return 0
    done
    return 1
}

# -- Détection du type de disque : nvme, sata, hdd --
learning_disk_type() {
    local dev="/dev/$1"
    if command -v nvme &>/dev/null && nvme list | grep -qw "$dev"; then
        echo "nvme"
    elif hdparm -I "$dev" 2>/dev/null | grep -qi 'not frozen'; then
        echo "sata"
    else
        echo "hdd"
    fi
}

# -- Effacement sécurisé, branche selon type --
secure_erase_disk() {
    local disk="$1"
    local dev="/dev/$disk"

    [[ -b "$dev" ]] || { echo_status_error "$dev n'existe pas."; return 1; }

    show_header
    echo_status_warn "Effacement sécurisé de $dev lancé..."

    local type
    type=$(learning_disk_type "$disk")

    case "$type" in
        nvme)
            echo_status "Type NVMe SSD détecté, format secure erase."
            sudo nvme format -s1 "$dev"
            ;;
        sata)
            echo_status "SATA SSD/HDD détecté, exécution de hdparm secure-erase."
            sudo hdparm --user-master u --security-set-pass p "$dev"
            sudo hdparm --user-master u --security-erase p "$dev"
            ;;
        *)
            echo_status "HDD détecté, utilisation de shred (1 passe + zero)."
            sudo shred -v -n1 -z "$dev"
            ;;
    esac

    verify_disk "$disk"
}

# -- Vérification post-effacement (par défaut : 10MiB) --
verify_disk() {
    local disk="$1"
    local size="${2:-10}"
    local dev_path="/dev/$disk"
    [[ -b "$dev_path" ]] || { echo_status_error "$dev_path n'existe pas."; return 1; }

    echo_status "Scan du disque $dev_path pour vérifier la présence de données résiduelles (premiers ${size}MiB)..."
    if sudo strings "$dev_path" | head -c $((size*1024*1024)) | grep -q .; then
        echo_status_warn "Des données textuelles subsistent dans les premiers ${size}MiB !"
        return 2
    else
        echo_status_ok "Aucune donnée lisible détectée dans les premiers ${size}MiB."
        return 0
    fi
}

# -- Main --
main() {
    show_header
    local disk
    disk=$(select_disk) || exit 1
    secure_erase_disk "$disk"
}

main "$@"
