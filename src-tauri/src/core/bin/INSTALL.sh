#!/usr/bin/env bash

BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${BIN_DIR%%/core*}/core"

source "$DIR_ROOT/etc/config/pkgs-list.sh"
source "$DIR_ROOT/lib/pkgmgr/wrapper.sh"
source "$DIR_ROOT/lib/pkgmgr/filter_pkgs.sh"
source "$DIR_ROOT/lib/utils/init.sh"

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


    echo_status "Mise à niveau du système"
    update_pkgs_native "$os_type" && \
        echo_status_ok "Mise à jour réussie" || \
        echo_status_error "Échec upgrade"

    # 5. Purge optionnelle
    prompt_yes_no "Désirez-vous un nettoyage du cache de votre système ?"
    cancel_purge
    # uncomment cette line en prod
    # remove_files
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
