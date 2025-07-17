#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/ui/echo_status.sh"
source "$LIB_DIR/ui/prompt_yes_no.sh"
source "$LIB_DIR/pkgmgr/wrapper.sh"    # <-- contient tes wrappers install/remove/update/etc
source "$LIB_DIR/utils/detect_os.sh"

# HACK: boot-repair ne marche que sur Debian/Ubuntu
booting_repair() {
    local os_type
    os_type="$(detect_os)"

    echo_status "Vérification des prérequis"
    if update_pkgs_native "$os_type"; then
        echo_status_ok "Update réussi"
    else
        echo_status_error "Échec de la mise à jour des paquets"
    fi

    echo_status "Vérification du package boot-repair"
    if ! command -v boot-repair &>/dev/null && ! dpkg -s boot-repair &>/dev/null; then
        install_bootrepair
    else
        echo_status_ok "Boot-repair déjà installé"
    fi

    if prompt_yes_no "Désirez-vous lancer boot-repair ?"; then
        echo_status "Lancement de boot-repair"
        if command -v boot-repair &>/dev/null && boot-repair; then
            echo_status_ok "Boot-repair effectué"
        else
            echo_status_error "Erreur lors de l'exécution de boot-repair"
        fi
    else

        echo_status_ok "Lancement de boot-repair annulé"
    fi

}

install_bootrepair(){

    echo_status_warn "BOOTRepair non installé"

    # Installation générique par nom "boot-repair" selon la logique mapping de pkgs-list.sh
    if prompt_yes_no "Désirez-vous installer BOOTRepair ?"; then
        # Spécificité DEBIAN/UBUNTU : ajout du PPA si besoin (autodétection)
        if [[ "$os_type" == "debian" ]]; then
            if ! grep -h -R "yannubuntu/boot-repair" /etc/apt/sources.list /etc/apt/sources.list.d/* &>/dev/null; then
                sudo add-apt-repository -y ppa:yannubuntu/boot-repair
            fi
            update_pkgs_native "$os_type"
        fi

        if install_one_pkg_native "$os_type" "boot-repair"; then
            echo_status_ok "Installation de boot-repair réussie"
        else
            echo_status_error "Échec installation boot-repair"
        fi
    else
        echo_status_ok "Installation de boot-repair refusé"
        return 1
    fi

}

booting_repair
