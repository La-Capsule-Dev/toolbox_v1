#!/usr/bin/env bash
set -euo pipefail

source "$DIR_ROOT/lib/utils/echo_status.sh"

# 1. Résout la commande à lancer selon OS + opération (sans exécuter)
resolve_pkgmgr_cmd() {
    local op="$1" os="$2"
    case "$op:$os" in
        install:arch)      echo "sudo pacman -Sy --noconfirm" ;;
        install:debian)    echo "sudo apt-get update -qq && sudo apt-get install -y" ;;
        install:fedora)    echo "sudo dnf install -y" ;;
        install:alpine)    echo "sudo apk add" ;;
        install:gentoo)    echo "sudo emerge" ;;
        install:void)      echo "sudo xbps-install -Sy" ;;
        install:opensuse)  echo "sudo zypper install -y" ;;

        remove:arch)      echo "sudo pacman -Rns --noconfirm" ;;
        remove:debian)    echo "sudo apt-get remove -y" ;;
        remove:fedora)    echo "sudo dnf remove -y" ;;
        remove:alpine)    echo "sudo apk del" ;;
        remove:gentoo)    echo "sudo emerge -C" ;;
        remove:void)      echo "sudo xbps-remove -Ry" ;;
        remove:opensuse)  echo "sudo zypper remove -y" ;;

        update:arch)      echo "sudo pacman -Syu --noconfirm" ;;
        update:debian)    echo "sudo apt-get update -qq && sudo apt-get upgrade -y" ;;
        update:fedora)    echo "sudo dnf upgrade --refresh -y" ;;
        update:alpine)    echo "sudo apk update && sudo apk upgrade" ;;
        update:gentoo)    echo "sudo emerge --sync && sudo emerge --update --deep --newuse @world" ;;
        update:void)      echo "sudo xbps-install -Syu" ;;
        update:opensuse)  echo "sudo zypper refresh && sudo zypper update -y" ;;

        autoremove:arch)   echo 'pkgs=$(pacman -Qdtq); [[ -n "$pkgs" ]] && sudo pacman -Rns --noconfirm $pkgs' ;;
        autoremove:debian) echo "sudo apt autoremove -y" ;;
        autoremove:fedora) echo "sudo dnf autoremove -y" ;;
        autoremove:opensuse) echo 'echo_status_warn "Zypper: autoremove non automatisé"' ;;
        autoremove:void) echo "sudo xbps-remove -O" ;;
        autoremove:alpine|autoremove:gentoo) echo 'echo_status_warn "Autoremove non supporté"' ;;

        clean:arch)      echo "sudo pacman -Sc --noconfirm" ;;
        clean:debian)    echo "sudo apt autoclean -y" ;;
        clean:fedora)    echo "sudo dnf clean packages" ;;
        clean:alpine)    echo "sudo apk cache clean" ;;
        clean:opensuse)  echo "sudo zypper clean" ;;
        clean:void)      echo "sudo xbps-remove -Oo" ;;
        clean:gentoo)    echo 'echo_status_warn "Clean non supporté"' ;;
        *)
            echo_status_error "resolve_pkgmgr_cmd: action/OS non supporté ($op/$os)"
            return 1
            ;;
    esac
}

# 2. Exécute la commande fournie avec logging (réutilisable)
run_pkgmgr_cmd() {
    local op="$1" os="$2" cmd="$3"
    shift 3
    local pkgs=("$@")

    if [[ "$op" =~ ^(install|remove)$ ]]; then
        if [[ "${#pkgs[@]}" -eq 0 ]]; then
            echo_status_warn "[SKIP] Aucun paquet fourni pour l'opération '$op' ($os)"
            return 0
        fi
        echo_status "[ACTION] $op sur : ${pkgs[*]} ($os) ➔ $cmd"
        if eval "$cmd \"\${pkgs[@]}\""; then
            echo_status_ok "[OK] $op réussi sur $os : ${pkgs[*]}"
        else
            echo_status_error "[FAIL] $op échoué sur $os : ${pkgs[*]}"
        fi
    else
        echo_status "[ACTION] $op global sur $os ➔  $cmd"
        if eval "$cmd"; then
            echo_status_ok "[OK] $op global réussi sur $os"
        else
            echo_status_error "[FAIL] $op global échoué sur $os"
        fi
    fi
}

# 3. Fonction principale unique (API publique)
pkg_op_native() {
    local os="$1"
    local op="$2"
    shift 2
    local pkgs=("$@")

    local cmd
    cmd="$(resolve_pkgmgr_cmd "$op" "$os")" || return 1
    run_pkgmgr_cmd "$op" "$os" "$cmd" "${pkgs[@]}"
}
