#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/ui/echo_status.sh"
source "$LIB_DIR/ui/prompt_yes_no.sh"

# NOTE: Voir implémentation fio

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


_detect_disk_type() {
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
    local dname mnt serial

    lsblk_cmd() {
        # Ajoute SERIAL AVANT MOUNTPOINT dans le print
        lsblk -dn -o NAME,SIZE,TYPE,SERIAL,MOUNTPOINT |
        awk '$3 == "disk" && $1 !~ /^zram/ && $1 !~ /^loop/ {
            printf "%s (%s) [S/N:%s] %s\n", $1, $2, ($4==""?"-":$4), ($5==""?"-":$5)
        }'
    }
    mapfile -t DEVICES < <(lsblk_cmd)

    select entry in "${DEVICES[@]}"; do
        if [[ -z "$entry" ]]; then
            echo_status_warn "Choix invalide." >&2
            continue
        fi

        # Extraction du nom du disque (avant l'espace ou le premier '(')
        dname=$(awk '{split($1,a,"("); print a[1]}' <<< "$entry")
        _mount_mnt "$entry" "$dname"
        echo "$dname"
        return 0
    done
    return 1
}
# # -- Effacement sécurisé, branche selon type --
#
# TODO: VOIR HDD SAS
secure_erase_disk() {
    local disk="$1"
    local dev="/dev/$disk"
    local type

    if [[ ! -b "$dev" ]]; then
        echo_status_error "❌ Le périphérique $dev n'existe pas."
    fi

    echo -e "\n\e[1;33m⚠️  Lancement de l'effacement sécurisé de :\e[0m \e[1m$dev\e[0m"

    type=$(_detect_disk_type "$disk")

    echo_status "🔍 Type de disque détecté : \e[1m$type\e[0m"

    case "$type" in
        nvme)
            echo_status_warn "✴️  Effacement NVMe : envoi de la commande format (secure erase)."
            #sudo nvme format -s1 "$dev"
            ;;
        sata)
            echo_status_warn "✴️  Effacement SATA avec hdparm secure erase (2 étapes)."
            # sudo hdparm --user-master u --security-set-pass p "$dev"
            # sudo hdparm --user-master u --security-erase p "$dev"
            ;;
        *)
            echo_status_warn "✴️  Disque classique (HDD ?), effacement avec shred (1 passe + zero)."
            # sudo shred -v -n1 -z "$dev"
            ;;
    esac

    if prompt_yes_no "Désirez-vous procéder à la vérification de l'effacement?"; then
        echo -e "\n\e[1m🧪 Vérification post-effacement...\e[0m"
        verify_disk_erased "$disk"
    fi
}

# TODO: Add testdisk tools (CG Security)
# # -- Vérification post-effacement (par défaut : 10MiB) --
verify_disk_erased() {
    local disk="$1"
    local dev="/dev/$disk"
    local tmpfile

    echo_status "🧪 Vérification de l'effacement de $dev..."

    # 1. Vérifie qu'aucune signature de FS ou partition n'est présente
    if sudo wipefs --noheadings "$dev" | grep -q .; then
        echo_status_warn "⚠️  Signatures de système de fichiers ou table de partitions détectées !"
        sudo wipefs --noheadings "$dev"
        return 2
    fi

    # 2. Vérifie si des chaînes ASCII lisibles restent
    tmpfile=$(mktemp)
    sudo dd if="$dev" bs=1M count=10 status=none of="$tmpfile" 2>/dev/null

    if strings "$tmpfile" | grep -q .; then
        echo_status_warn "⚠️  Données ASCII résiduelles détectées dans les 10 premiers MiB !"
        strings "$tmpfile" | head -n 10 | sed 's/^/   /'
        rm -f "$tmpfile"
        return 2
    fi

    rm -f "$tmpfile"
    echo_status_ok "✅ Aucun système de fichiers détecté, contenu ASCII vierge."
    return 0
}

# -- Affichage contextuel de l'état des disques --
show_header() {
    echo -e "\e[1m📦 Référence des disques NVMe connectés\e[0m"
    nvme list 2>/dev/null || echo_status_warn "(Aucun NVMe détecté)"
    echo "────────────────────────────────────────────────────────────────────────────"

    echo -e "\n\e[1m🖴 Liste des disques physiques détectés\e[0m"
    echo
    printf "  %-3s │ %-10s │ %-10s │ %-20s │ %-20s\n" "ID" "Nom" "Taille" "Serial" "Monté sur"
    echo " ─────┼────────────┼────────────┼──────────────────────┼────────────────────"

    local i=1
    lsblk -dn -o NAME,SIZE,TYPE,SERIAL,MOUNTPOINT | \
        awk '$3=="disk" && $1 !~ /^zram/ && $1 !~ /^loop/ {
        printf "%s %s %s %s %s\n", $1, $2, $3, $4, ($5==""?"-":$5)
    }' | \
        while read -r name size type serial mnt; do
        printf "  \e[36m%2d)\e[0m │ %-10s │ %-10s │ %-20s │ %-20s\n" \
            "$i" "$name" "$size" "${serial:--}" "${mnt:--}"
        ((i++))
    done
    echo
}

# -- Main --
main() {
    show_header
    local disk
    disk=$(select_disk) || exit 1
    echo "Ok"
    secure_erase_disk "$disk"
}

main "$@"
