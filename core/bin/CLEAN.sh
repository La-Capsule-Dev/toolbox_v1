#!/usr/bin/env bash
set -euo pipefail

source "$CORE_DIR/etc/config/path.env"
source "$LIB_DIR/utils/init.sh"
source "$LIB_DIR/maintenance/init.sh"
source "$LIB_DIR/pkgmgr/remove_pkgs_csv.sh"

drop_memory_cache(){
    sync
    sudo sysctl vm.drop_caches=3 || echo_status_error "Échec drop_caches"
    echo_status_ok "Cache mémoire vidé"
    echo_status "État de la mémoire :"
    swapon -s || echo_status_error "Échec swapon"
    free -m  || echo_status_error "Échec free"
}

clean_up() {
    local os_type
    os_type="$(detect_os_id)"
    echo_status "Début du nettoyage intégral..."
    echo_status "Obtention des droits sur les fichiers verrouillés"
    echo_status "Veuillez entrer votre mot de passe administrateur"
    fix_permissions "$os_type"

    # Fonction pour lancer une étape en background et stocker le PID
    jobs=()
    run_bg() {
        "$@" &
        jobs+=($!)
    }

    if prompt_yes_no "Désirez-vous passer en mode manuel ?"; then
        if prompt_yes_no "Désirez-vous lancer la maintence du système complète ??"; then
            echo_status "Maintenance système complète : mise à jour, nettoyage, autoremove, etc."
            update_pkgs "$os_type"
            echo_status_ok "Maintenance réussie"
        fi

        # Ces deux actions sont indépendantes, on les propose séparément mais possible aussi de les faire ensemble si besoin
        if prompt_yes_no "Désirez-vous vider le cache mémoire (drop_cache) ?"; then
            echo_status "Vidage du cache mémoire (drop_caches)"
            run_bg drop_memory_cache
        fi

        if prompt_yes_no "Désirez-vous supprimer les paquets que vous avez installé ?"; then
            echo_status "Suppression des paquets spécifiques installés"
            remove_pkgs_csv
            echo_status_ok "Suppression réussi"
        fi

        if prompt_yes_no "Désirez-vous supprimer les fichiers inutiles ?"; then
            echo_status "Nettoyage des fichiers inutiles"
            run_bg remove_files
            echo_status_ok "Nettoyage effectué avec succès"
        fi

        # Attendre la fin des tâches lancées en fond
        if ((${#jobs[@]})); then
            for pid in "${jobs[@]}"; do
                wait "$pid" || echo_status_warn "Un job de nettoyage a échoué (pid $pid)"
            done
        fi

    else
        # Mode auto : on lance drop_cache et remove_files en parallèle
        echo_status "Maintenance système complète : mise à jour, nettoyage, autoremove, etc."
        update_pkgs "$os_type"
        echo_status_ok "Maintenance réussie"

        echo_status "Vidage du cache mémoire (drop_caches)"
        run_bg drop_memory_cache

        echo_status "Suppression des paquets spécifiques installés"
        remove_pkgs_csv
        echo_status_ok "Suppression réussi"

        echo_status "Nettoyage des fichiers inutiles"
        run_bg remove_files
        echo_status_ok "Nettoyage effectué avec succès"

        # Attendre la fin des tâches lancées en fond
        for pid in "${jobs[@]}"; do
            wait "$pid" || echo_status_warn "Un job de nettoyage a échoué (pid $pid)"
        done
    fi

    echo_status_ok "ヽ( •_)ᕗ Nettoyage de votre machine réussi"
}

clean_up
