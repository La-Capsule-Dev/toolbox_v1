#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/ui/echo_status.sh"

full_pkg_maintenance() {
    local os="$1"

    # 1. Update
    echo_status "Mise à jour des paquets"
    case "$os" in
        debian|ubuntu|linuxmint)
            if sudo apt-get update -qq && sudo apt-get upgrade -y; then
                echo_status_ok "Mise à jour réussie"
            else
                echo_status_error "Échec de la mise à jour"
            fi
            ;;
        fedora)
            if sudo dnf upgrade --refresh -y; then
                echo_status_ok "Mise à jour réussie"
            else
                echo_status_error "Échec de la mise à jour"
            fi
            ;;
        arch)
            if sudo pacman -Syu --noconfirm; then
                echo_status_ok "Mise à jour réussie"
            else
                echo_status_error "Échec de la mise à jour"
            fi
            ;;
        alpine)
            if sudo apk update && sudo apk upgrade; then
                echo_status_ok "Mise à jour réussie"
            else
                echo_status_error "Échec de la mise à jour"
            fi
            ;;
        gentoo)
            if sudo emerge --sync && sudo emerge --update --deep --newuse @world; then
                echo_status_ok "Mise à jour réussie"
            else
                echo_status_error "Échec de la mise à jour"
            fi
            ;;
        void)
            if sudo xbps-install -Syu; then
                echo_status_ok "Mise à jour réussie"
            else
                echo_status_error "Échec de la mise à jour"
            fi
            ;;
        opensuse)
            if sudo zypper refresh && sudo zypper update -y; then
                echo_status_ok "Mise à jour réussie"
            else
                echo_status_error "Échec de la mise à jour"
            fi
            ;;
        *)
            echo_status_error "OS non supporté pour update : $os"
            ;;
    esac

    # 2. Fix broken (Debian/Ubuntu only)
    if [[ "$os" == "debian" || "$os" == "ubuntu" || "$os" == "linuxmint" ]]; then
        echo_status "Réparation des paquets cassés"
        if sudo apt --fix-broken install -y; then
            echo_status_ok "Réparation des paquets cassés réussie"
        else
            echo_status_error "Échec fix-broken"
        fi
    fi

    # 3. Clean/autoclean
    echo_status "Nettoyage des paquets obsolètes"
    case "$os" in
        debian|ubuntu)
            if sudo apt-get autoclean -y; then
                echo_status_ok "Nettoyage réussi"
            else
                echo_status_error "Échec nettoyage"
            fi
            ;;
        fedora)
            if sudo dnf clean packages; then
                echo_status_ok "Nettoyage réussi"
            else
                echo_status_error "Échec nettoyage"
            fi
            ;;
        arch)
            if sudo pacman -Sc --noconfirm; then
                echo_status_ok "Nettoyage réussi"
            else
                echo_status_error "Échec nettoyage"
            fi
            ;;
        alpine)
            if sudo apk cache clean; then
                echo_status_ok "Nettoyage réussi"
            else
                echo_status_error "Échec nettoyage"
            fi
            ;;
        void)
            if sudo xbps-remove -Oo; then
                echo_status_ok "Nettoyage réussi"
            else
                echo_status_error "Échec nettoyage"
            fi
            ;;
        opensuse)
            if sudo zypper clean; then
                echo_status_ok "Nettoyage réussi"
            else
                echo_status_error "Échec nettoyage"
            fi
            ;;
        gentoo)
            echo_status_warn "Clean non supporté pour Gentoo."
            ;;
        *)
            echo_status_error "OS non supporté pour clean : $os"
            ;;
    esac

    # 4. Autoremove
    echo_status "Suppression des dépendances inutiles"
    case "$os" in
        debian|ubuntu|linuxmint)
            if sudo apt-get autoremove -y; then
                echo_status_ok "Suppression des dépendances inutiles réussie"
            else
                echo_status_error "Échec suppression dépendances"
            fi
            ;;
        fedora)
            if sudo dnf autoremove -y; then
                echo_status_ok "Suppression des dépendances inutiles réussie"
            else
                echo_status_error "Échec suppression dépendances"
            fi
            ;;
        arch)
            pkgs=$(pacman -Qdtq)
            if [[ -n "$pkgs" ]] && sudo pacman -Rns --noconfirm $pkgs; then
                echo_status_ok "Suppression des dépendances inutiles réussie"
            else
                echo_status_ok "Aucune dépendance orpheline à supprimer"
            fi
            ;;
        alpine)
            echo_status_warn "Autoremove non supporté sur Alpine."
            ;;
        gentoo)
            echo_status_warn "Autoremove non supporté sur Gentoo."
            ;;
        void)
            if sudo xbps-remove -O; then
                echo_status_ok "Suppression des dépendances inutiles réussie"
            else
                echo_status_error "Échec suppression dépendances"
            fi
            ;;
        opensuse)
            echo_status_warn "Zypper: autoremove non automatisé."
            ;;
        *)
            echo_status_error "OS non supporté pour autoremove : $os"
            ;;
    esac
}
