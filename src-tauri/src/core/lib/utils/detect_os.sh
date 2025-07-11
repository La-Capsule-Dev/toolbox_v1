#!/usr/bin/env bash

DETECTOS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$DETECTOS_DIR/echo_status.sh"

detect_os() {
    [[ -f /etc/os-release ]] || echo_status_error "OS introuvable, veuillez le signaler sur github pour qu'il soit ajouter"
    . /etc/os-release
    case "$ID" in
        arch|manjaro|endeavouros|cachyos) echo "arch" ;;
        fedora|nobara|rhel|rocky|alma)    echo "fedora" ;;
        ubuntu|debian|mint|kali)          echo "debian" ;;
        alpine)                           echo "alpine" ;;
        gentoo)                           echo "gentoo" ;;
        void)                             echo "void" ;;
        opensuse*|suse)                   echo "opensuse" ;;
        *)                                echo "$ID" ;;
    esac
}
