#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/ui/echo_status.sh"

filter_available_pkgs() {
    local os_type="$1"; shift
    local found=() missing=()

    pkg_exists() {
        local pkg="$1"
        case "$os_type" in
            fedora)    dnf list --available "$pkg" &>/dev/null ;;
            debian|ubuntu) apt-cache show "$pkg" &>/dev/null ;;
            arch)      pacman -Si "$pkg" &>/dev/null ;;
            alpine)    apk info -e "$pkg" &>/dev/null ;;
            void)      xbps-query -Rs "$pkg" &>/dev/null ;;
            opensuse)  zypper info "$pkg" &>/dev/null ;;
            gentoo)    equery list "$pkg" &>/dev/null 2>&1 || emerge -s "$pkg" | grep -q "^$pkg" ;;
            *)         return 2 ;;
        esac
    }

    for pkg in "$@"; do
        if pkg_exists "$pkg"; then
            found+=("$pkg")
        else
            missing+=("$pkg")
        fi
    done

    if ((${#missing[@]})); then
        echo_status_warn "Paquets introuvables sur $os_type : ${missing[*]}"
        echo_status_warn "Veuillez signaler que ces paquets ne sont plus disponibles sur $os_type"
    fi

    if [[ ${#missing[@]} -eq 0 && ${#found[@]} -gt 0 ]]; then
        echo_status_ok "Tous les paquets nécessaires sont déjà installés."
    fi

    printf '%s\n' "${found[@]}"
}


is_pkg_installed() {
    local os_type="$1"
    local pkg="$2"
    case "$os_type" in
        fedora)    rpm -q "$pkg" &>/dev/null ;;
        debian|ubuntu) dpkg -s "$pkg" &>/dev/null ;;
        arch)      pacman -Qi "$pkg" &>/dev/null ;;
        alpine)    apk info -e "$pkg" &>/dev/null ;;
        void)      xbps-query -Rs "$pkg" &>/dev/null ;;  # à adapter si besoin
        opensuse)  zypper se --installed-only "$pkg" &>/dev/null ;;
        gentoo)    equery list "$pkg" &>/dev/null 2>&1 ;;
        *)         return 2 ;;
    esac
}
