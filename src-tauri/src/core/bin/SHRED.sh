#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/ui/echo_status.sh"

# NOTE: Voir implémentation fio

# -- Affichage contextuel de l'état des disques --
show_header() {
    echo -e "Référence des disques NVMe connectés :"
    nvme list 2>/dev/null || echo_status_warn "(Aucun NVMe détecté)"
    echo "-----------------------------------------------------------------"
    echo -e "Liste des disques connectés :"
    echo -e "NOM:           TAILLE:"
    lsblk -n -x NAME | awk '$1 != "/" && $1 {print "-", $1, "--->", $4, " "}'
    echo "-----------------------------------------------------------------"
}

_mount_mnt(){
    local entry="$1"
    local dname="$2"

    mnt=$(awk '{print $3}' <<< "$entry")

    if [[ "$mnt" != "-" ]]; then
        echo_status_warn "ATTENTION : /dev/$dname est monté sur $mnt !" >&2
        while true; do
            read -rp "Continuer quand même ? [o/N] " really
            case "$really" in
                [oO]) break ;;
                [nN]|"") echo_status_error "Annulé." ; return 2 ;;
                *) echo_status_warn "Réponse invalide. Tapez 'o' pour continuer, 'n' pour annuler." ;;
            esac
        done
    fi
}

_learning_disk_type() {
    local dev="/dev/$1"

    if command -v nvme &>/dev/null && nvme list | grep -qw "$dev"; then
        echo "nvme"
    elif hdparm -I "$dev" 2>/dev/null | grep -qi 'not frozen'; then
        echo "sata"
    else
        echo "hdd"
    fi
}

# -- Sélectionne un disque (CLI natif, non graphique) --
select_disk() {
    local dname mnt

    lsblk_cmd() { lsblk -dn -o NAME,SIZE,TYPE,MOUNTPOINT; }
    awk_lsblk() { awk '$3=="disk"{print $1 " (" $2 ") " ($4==""?"-":$4)}'; }

    # Ajouter le contenu de la command LSBLK dans un array
    mapfile -t DEVICES < <( lsblk_cmd| awk_lsblk)

    echo "Sélectionnez un disque :" >&2
    select entry in "${DEVICES[@]}"; do
        if [[ -z "$entry" ]]; then
            echo_status_warn "Choix invalide." >&2
            continue;
        fi
        dname=$(awk '{print $1}' <<< "$entry")
        # Appeler la fonction _mount_mnt pour voir si monter sur mount
        _mount_mnt "$entry" "$dname"

        echo "$dname"
        return 0
    done
    return 1
}


# # -- Effacement sécurisé, branche selon type --
secure_erase_disk() {
    local disk="$1"
    local dev="/dev/$disk"
    local type

    [[ -b "$dev" ]] || { echo_status_error "$dev n'existe pas."; return 1;}

    show_header
    echo_status_warn "Effacement sécurisé de $dev lancé..."

    type=$(_learning_disk_type "$disk")

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


# # -- Vérification post-effacement (par défaut : 10MiB) --
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
