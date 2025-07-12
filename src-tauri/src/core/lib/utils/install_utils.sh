#!/usr/bin/env bash
set -euo pipefail

# --- Facteur install UX : résumé, split, install, statuts ---
source "$LIB_DIR/ui/echo_status.sh"
source "$LIB_DIR/ui/prompt_yes_no.sh"
source "$LIB_DIR/pkgmgr/wrapper.sh"
source "$LIB_DIR/pkgmgr/filter_pkgs.sh"

install_packages_ui() {
    local os_type="$1"
    shift
    local pkgs=( "$@" )

    # Filtrage : paquets réellement présents dans le dépôt
    local pkgs_found=( $(filter_available_pkgs "$os_type" "${pkgs[@]}") )

    if ((${#pkgs_found[@]} == 0)); then
        echo_status_ok "Aucun paquet installable trouvé pour $os_type."
        return 0
    fi

    local already_installed=() to_install=()

    for pkg in "${pkgs_found[@]}"; do
        if is_pkg_installed "$os_type" "$pkg"; then
            already_installed+=("$pkg")
        else
            to_install+=("$pkg")
        fi
    done

    if ((${#already_installed[@]})); then
        echo_status_ok "Paquet(s) déjà installé(s) : ${already_installed[*]}"
    fi


    if ((${#to_install[@]})); then
        echo_status "À installer : ${to_install[*]}"
        echo_status_warn "NB: Les paquets manquants sont affichés ci-dessus si présents." # optionnel
        # Prompt robuste
        #
        if prompt_yes_no "Voulez-vous les installer ?"; then
            echo_status "Installation des paquets : ${to_install[*]}"
            if ! install_pkgs_native "$os_type" "${to_install[@]}"; then
                echo_status_error "L'installation a échoué."
            fi
            echo_status_ok "Installation des dépendances réussie"
        fi
    fi
}
