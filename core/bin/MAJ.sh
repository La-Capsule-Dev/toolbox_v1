#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/ui/init.sh"
source "$LIB_DIR/pkgmgr/install_pkgs_csv.sh"
source "$LIB_DIR/utils/init.sh"

install() {
    local os_id
    os_id="$(detect_os_id)"
    echo_status "Initialisation de l'installation sur : $(detect_os_id) ᕦ( ͡° ͜ʖ ͡°)ᕤ"
    install_all_from_csv

    echo_status "Maintenance système complète : mise à jour, nettoyage, autoremove, etc."
    update_pkgs "$os_id"
    echo_status_ok "Maintenance réussie"

    if prompt_yes_no "Désirez-vous un nettoyage du cache de votre système ?"; then
        echo_status_warn "LE NETTOYAGE DU CACHE VA COMMENCER !"
        echo_status_warn "Appuyer sur les touches Ctrl+C pour annuler la purge, sinon votre cache sera perdu (╯°□°）╯︵ ┻━┻"
        for i in 6 5 4 3 2 1; do
            echo "$i"
            sleep 1
        done
        remove_files  # à décommenter si tu as un script de nettoyage
        sleep 2
    fi

    echo_status_ok "ヽ( •_)ᕗ Installation & mise à jour complète de votre machine réussie"
}

install
