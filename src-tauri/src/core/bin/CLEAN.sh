#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/utils/init.sh"
source "$LIB_DIR/maintenance/init.sh"
source "$LIB_DIR/pkgmgr/remove_pkgs_csv.sh"

# Étapes unitaires
repair_orphans() {
    repare_pkgs_native "$1"
}

drop_cache() {
    drop_memory_cache
}

remove_installed() {
    remove_pkgs_csv
    echo_status_ok "Suppression réussie"
}

remove_junk() {
    remove_files
    echo_status_ok "Nettoyage effectué avec succès"
}

clean_up() {
    local os_type
    os_type="$(detect_os_id)"
    echo_status "Début du nettoyage intégral..."
    echo_status "Obtention des droits sur les fichiers verrouillés"
    echo_status "Veuillez entrer votre mot de passe administrateur"

    fix_permissions "$os_type"

    # Tableau des étapes
    steps=("repair_orphans" "drop_cache" "remove_installed" "remove_junk")
    steps_msg=(
        "Réparation et suppressions des paquets orphelins"
        "Vidage du cache mémoire (drop_caches)"
        "Suppression des paquets spécifiques installés"
        "Nettoyage des fichiers inutiles"
    )

    if prompt_yes_no "Désirez-vous passer en mode manuel ?"; then
        for i in "${!steps[@]}"; do
            if prompt_yes_no "Désirez-vous lancer : ${steps_msg[$i]} ?"; then
                echo_status "${steps_msg[$i]}"
                "${steps[$i]}" "$os_type"
            fi
        done
    else
        for i in "${!steps[@]}"; do
            echo_status "${steps_msg[$i]}"
            "${steps[$i]}" "$os_type"
        done
    fi

    echo_status_ok "ヽ( •_)ᕗ Nettoyage de votre machine réussi"
}
drop_memory_cache(){
    sync
    sudo sysctl vm.drop_caches=3 || echo_status_error "Échec drop_caches"
    echo_status_ok "Cache mémoire vidé"
    echo_status "État de la mémoire :"
    swapon -s || echo_status_error "Échec swapon"
    free -m  || echo_status_error "Échec free"
}

clean_up
