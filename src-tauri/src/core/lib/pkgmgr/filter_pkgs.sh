#!/usr/bin/env bash
set -euo pipefail

PKGMGR_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${PKGMGR_DIR%%/core*}/core"
source "$DIR_ROOT/lib/ui/echo_status.sh"

filter_available_pkgs() {
    local os_type="$1"; shift
    local found=() missing=()

    for pkg in "$@"; do
        case "$os_type" in
            fedora)    dnf list --available "$pkg" &>/dev/null ;;
            debian|ubuntu) apt-cache show "$pkg" &>/dev/null ;;
            arch)      pacman -Si "$pkg" &>/dev/null ;;
            alpine)    apk info -e "$pkg" &>/dev/null ;;
            void)      xbps-query -Rs "$pkg" &>/dev/null ;;
            opensuse)  zypper info "$pkg" &>/dev/null ;;
            gentoo)    equery list "$pkg" &>/dev/null 2>&1 || emerge -s "$pkg" | grep -q "^$pkg" ;;
            *)
                echo_status_error "[WARN] OS non supporté pour le filtrage packages: $os_type" >&2
                continue
                ;;
        esac
        if [[ $? -eq 0 ]]; then
            found+=("$pkg")
        else
            missing+=("$pkg")
        fi
    done

    if ((${#missing[@]})); then
        echo_status_warn "Paquets introuvables sur $os_type : ${missing[*]}"
    fi

    # *** SEULEMENT la vraie liste pour stdout ***
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
