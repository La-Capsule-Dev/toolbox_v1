#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/ui/init.sh"
source "$LIB_DIR/utils/init.sh"
source "$LIB_DIR/pkgmgr/install_pkgs_csv.sh"


CSV="$ETC_DIR/config/pkgs-mapping.csv"

remove_pkgs_csv() {
    local os_id
    os_id="$(detect_os_id)"
    mapfile -t pkgs < <(get_pkgs_for_os "$os_id" "$CSV")
    # Optionnel : filtrer pour ne garder que les paquets réellement installés
    to_remove=()
    for pkg in "${pkgs[@]}"; do
        case "$os_id" in
            fedora)    rpm -q "$pkg" &>/dev/null ;;
            debian|ubuntu|linuxmint) dpkg -s "$pkg" &>/dev/null ;;
            arch)      pacman -Qi "$pkg" &>/dev/null ;;
            alpine)    apk info -e "$pkg" &>/dev/null ;;
            gentoo)    equery list "$pkg" &>/dev/null 2>&1 ;;
            void)      xbps-query -Rs "$pkg" &>/dev/null ;;
            opensuse)  zypper se --installed-only "$pkg" &>/dev/null ;;
            *)         false ;;
        esac && to_remove+=("$pkg")
    done

    if [[ "${#to_remove[@]}" -eq 0 ]]; then
        echo_status_ok "Aucun paquet du CSV n'est installé : rien à supprimer."
        return 0
    fi

    local cmd
    case "$os_id" in
        debian|ubuntu|linuxmint) cmd="sudo apt-get remove -y" ;;
        fedora)        cmd="sudo dnf remove -y" ;;
        arch)          cmd="sudo pacman -Rns --noconfirm" ;;
        alpine)        cmd="sudo apk del" ;;
        gentoo)        cmd="sudo emerge -C" ;;
        void)          cmd="sudo xbps-remove -Ry" ;;
        opensuse)      cmd="sudo zypper remove -y" ;;
        *)             echo_status_error "OS non supporté : $os_id" ; return 1 ;;
    esac

    echo_status "Suppression des paquets listés dans le CSV : ${to_remove[*]}"
    if eval "$cmd \"\${to_remove[@]}\""; then
        echo_status_ok "Suppression des paquets réussie."
    else
        echo_status_error "Échec suppression sur $os_id"
    fi
}
