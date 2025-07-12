#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${BIN_DIR%%/core*}/core"

source "$DIR_ROOT/lib/ui/echo_status.sh"
source "$DIR_ROOT/lib/pkgmgr/wrapper.sh"    # <-- contient tes wrappers install/remove/update/etc
source "$DIR_ROOT/lib/utils/detect_os.sh"

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
    # HACK: Condition demandé si désire install boot-repair
    # -- Installation générique par nom "boot-repair" selon la logique mapping de pkgs-list.sh
    if ! command -v boot-repair &>/dev/null && ! dpkg -s boot-repair &>/dev/null; then
        echo_status_warn "BOOTRepair non installé, tentative d'installation..."

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
        echo_status_ok "BOOTRepair déjà installé"
    fi

    echo_status "Lancement de boot-repair"
    if command -v boot-repair &>/dev/null && boot-repair; then
        echo_status_ok "Boot-repair effectué"
    else
        echo_status_error "Erreur lors de l'exécution de boot-repair"
    fi
}

booting_repair
