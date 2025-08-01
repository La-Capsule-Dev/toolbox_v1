#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/ui/init.sh"
source "$LIB_DIR/utils/init.sh"


CSV="$ETC_DIR/config/pkgs-mapping.csv"

get_pkgs_for_os() {
    local os_id="$1"
    local csv="$2"
    awk -F, -v OS="$os_id" '
    NR==1 { for(i=2;i<=NF;i++) if(tolower($i)==OS) col=i }
    NR>1 && NF>1 && col { print $col }
    ' "$csv" | sort -u
}

install_all_from_csv() {
    local os_id
    os_id="$(detect_os_id)"
    mapfile -t pkgs < <(get_pkgs_for_os "$os_id" "$CSV")

    # PATCH Fedora ffmpeg-free
    if [[ "$os_id" == "fedora" ]]; then
        if rpm -q ffmpeg-free &>/dev/null; then
            pkgs=( "${pkgs[@]/ffmpeg}" )
            echo_status_warn "ffmpeg retiré de la liste (ffmpeg-free déjà installé sur Fedora)."
        fi
    fi

    # Filtrer la liste pour ne garder que les paquets absents
    to_install=()
    for pkg in "${pkgs[@]}"; do
        case "$os_id" in
            fedora)    ! rpm -q "$pkg" &>/dev/null ;;
            debian|ubuntu|linuxmint) ! dpkg -s "$pkg" &>/dev/null ;;
            arch)      ! pacman -Qi "$pkg" &>/dev/null ;;
            alpine)    ! apk info -e "$pkg" &>/dev/null ;;
            gentoo)    ! equery list "$pkg" &>/dev/null 2>&1 ;;
            void)      ! xbps-query -Rs "$pkg" &>/dev/null ;;
            opensuse)  ! zypper se --installed-only "$pkg" &>/dev/null ;;
            *)         true ;;
        esac && to_install+=("$pkg")
    done

    # Supprime toutes les chaînes vides ou composées uniquement d'espaces dans to_install
    filtered=()
    for pkg in "${to_install[@]}"; do
        [[ -n "${pkg// }" ]] && filtered+=("$pkg")
    done
    to_install=("${filtered[@]}")

    if [[ "${#to_install[@]}" -eq 0 ]]; then
        echo_status_ok "Tous les paquets nécessaires sont déjà installés ! Rien à faire."
        return 0
    fi

    local cmd
    case "$os_id" in
        debian|ubuntu|linuxmint) cmd="sudo apt-get update -qq && sudo apt-get install -y" ;;
        fedora)        cmd="sudo dnf install -y" ;;
        arch)          cmd="sudo pacman -Sy --noconfirm" ;;
        alpine)        cmd="sudo apk add" ;;
        gentoo)        cmd="sudo emerge" ;;
        void)          cmd="sudo xbps-install -Sy" ;;
        opensuse)      cmd="sudo zypper install -y" ;;
        *)             echo_status_error "OS non supporté : $os_id" ; return 1 ;;
    esac

    echo_status "Installation des paquets ($os_id): ${to_install[*]}"
    if eval "$cmd \"\${to_install[@]}\""; then
        echo_status_ok "Installation des paquets réussie !"
    else
        echo_status_error "Échec installation sur $os_id"
        if [[ "$os_id" == "fedora" ]]; then
            echo_status_warn "⚠️  Conflit ffmpeg/ffmpeg-free courant sur Fedora/RPMFusion : voir https://rpmfusion.org/Howto/Multimedia"
            echo_status_warn "Essayez : sudo dnf install ... --allowerasing ou --skip-broken"
        fi
    fi
}
