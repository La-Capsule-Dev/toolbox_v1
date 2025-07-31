#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/ui/init.sh"
source "$LIB_DIR/pkgmgr/install_pkgs_csv.sh"
source "$LIB_DIR/utils/init.sh"

install() {
    echo_status "Initialisation de l'installation sur : $(detect_os_id) ᕦ( ͡° ͜ʖ ͡°)ᕤ"
    install_all_from_csv

    if prompt_yes_no "Désirez-vous mettre à jour votre système ?"; then
        local os_id
        os_id="$(detect_os_id)"
        echo_status "Mise à niveau du système"
        case "$os_id" in
            debian|ubuntu) sudo apt-get update -qq && sudo apt-get upgrade -y ;;
            fedora)        sudo dnf upgrade --refresh -y ;;
            arch)          sudo pacman -Syu --noconfirm ;;
            alpine)        sudo apk update && sudo apk upgrade ;;
            gentoo)        sudo emerge --sync && sudo emerge --update --deep --newuse @world ;;
            void)          sudo xbps-install -Syu ;;
            opensuse)      sudo zypper refresh && sudo zypper update -y ;;
            *)             echo_status_error "OS non supporté : $os_id" ;;
        esac
        echo_status_ok "Mise à jour réussie"

        if prompt_yes_no "Désirez-vous un nettoyage du cache de votre système ?"; then
            echo_status_warn "LE NETTOYAGE DU CACHE VA COMMENCER !"
            echo_status_warn "Appuyer sur les touches Ctrl+C pour annuler la purge, sinon votre cache sera perdu (╯°□°）╯︵ ┻━┻"
            for i in 6 5 4 3 2 1; do
                echo "$i"
                sleep 1
            done
            # remove_files  # à décommenter si tu as un script de nettoyage
            sleep 2
        fi
    fi

    echo_status_ok "ヽ( •_)ᕗ Installation & mise à jour complète de votre machine réussie"
}

install
