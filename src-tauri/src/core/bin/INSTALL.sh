#!/usr/bin/env bash

set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$ETC_DIR/config/pkgs-list.sh"
source "$LIB_DIR/pkgmgr/wrapper.sh"
source "$LIB_DIR/ui/init.sh"
source "$LIB_DIR/utils/init.sh"

install() {
    local os_type="$(detect_os)"
    local pkgs_var="PKGS_${os_type^^}"
    declare -n pkgs="$pkgs_var"

    echo_status "Initialisation de l'installation sur votre linux favori : $os_type ᕦ( ͡° ͜ʖ ͡°)ᕤ"

    if ! declare -p "$pkgs_var" &>/dev/null; then
        echo_status_error "Aucune liste de paquets définie pour $os_type ($pkgs_var)"
        return 1
    fi

    echo_status "Recherche des paquets compatibles avec $os_type..."
    # 3. Appel à la fonction d'installation
    install_packages_ui "$os_type" "${pkgs[@]}"

    if prompt_yes_no "Désirez-vous mettre à jour votre système ?"; then
        echo_status "Mise à niveau du système"
        update_pkgs_native "$os_type" && \
            echo_status_ok "Mise à jour réussie" || \
            echo_status_error "Échec upgrade"

        # 5. Purge optionnelle
        if prompt_yes_no "Désirez-vous un nettoyage du cache de votre système ?"; then
            cancel_purge
            # uncomment cette line en prod
            # remove_files
            sleep 2
        fi
    fi



    echo_status_ok " ヽ( •_)ᕗ Installation & mise à jour complète de votre machine réussie "

}

cancel_purge() {
    echo_status_warn "LE NETTOYAGE DU CACHE VA COMMENCER !"
    echo_status_warn "Appuyer sur les touches Ctrl+C pour annuler la purge, sinon votre cache sera perdu (╯°□°）╯︵ ┻━┻"
    for i in 10 9 8 7 6 5 4 3 2 1; do
        echo "$i"
        sleep 1
    done
}

install
