#!/usr/bin/env bash
set -euo pipefail

# Configuration initiale plus robuste
readonly CORE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export CORE_DIR

# Fonction de sourcing sécurisée
source_file() {
    local file="$1"
    if [[ -r "$file" ]]; then
        # shellcheck source=/dev/null
        source "$file"
    else
        printf "Erreur: impossible de lire %s\n" "$file" >&2
        return 1
    fi
}

# Sourcing avec gestion d'erreur améliorée
source_file "$CORE_DIR/etc/config/find_project_root.sh" || exit 1
source_file "$CORE_DIR/etc/config/path.env" || exit 1
source_file "$CORE_DIR/lib/ui/echo_status.sh" || exit 1

# Déclaration en lecture seule pour plus de sécurité
declare -rA ACTION_DESC=(
    [PRINT]="Outils d'impression/rapport"
    [MAJ]="Install/Mise à jour système"
    [TESTHW]="Test de matériel v2"
    [CLONE]="Clonage de partitions/disques"
    [SHRED]="Shred disque dur"
    [CLEAN]="Nettoyage des fichiers inutiles"
)

list_actions() {
    local -r folder="bin"

    # Vérification de l'existence du dossier
    [[ -d "$folder" ]] || {
        printf "Erreur: dossier %s introuvable\n" "$folder" >&2
        return 1
    }

    local file name
    while IFS= read -r -d '' file; do
        name="${file##*/}"      # basename
        name="${name%.sh}"      # retire la dernière occurrence de .sh
        printf '%s\n' "$name"
    done < <(find "$folder" -type f -name "*.sh" -executable -print0 2>/dev/null)
}

build_menu_items() {
    local -a menu=()
    local action desc

    while IFS= read -r action; do
        desc="${ACTION_DESC[$action]:-Script personnalisé}"
        menu+=("$action" "$desc")
    done < <(list_actions)

    menu+=("QUITTER" "Sortir de l'outil")
    printf '%s\n' "${menu[@]}"
}

# Validation d'entrée renforcée
validate_action() {
    local -r action="$1"

    # Validation plus stricte du format
    if ! [[ "$action" =~ ^[A-Z][A-Z0-9_-]*$ ]]; then
        return 1
    fi

    # Vérification contre les injections de chemin
    if [[ "$action" == *".."* ]] || [[ "$action" == *"/"* ]]; then
        return 1
    fi

    return 0
}

execute_script() {
    local -r action="$1"
    local -r script="$BIN_DIR/${action}.sh"

    if [[ -f "$script" ]]; then
        if [[ -x "$script" ]]; then
            # Exécution dans un sous-shell pour isolation
            (
                cd "$CORE_DIR" || exit 1
                exec "$script"
            )
        else
            printf "Attention: script %s non exécutable, tentative avec bash...\n" "$script" >&2
            (
                cd "$CORE_DIR" || exit 1
                exec bash "$script"
            )
        fi
    else
        echo_status_error "Script introuvable : $script"
        return 1
    fi
}

menu_tui() {
    local action
    local -a items

    # Message de bienvenue
    if ! whiptail --title "Bienvenue sur la Toolbox" \
        --msgbox "Bienvenue sur la Toolbox" 8 40; then
        printf "Interface utilisateur indisponible\n" >&2
        exit 1
    fi

    while :; do
        # Construction dynamique du menu avec gestion d'erreur
        if ! mapfile -t items < <(build_menu_items); then
            echo_status_error "Erreur lors de la construction du menu"
            sleep 2
            continue
        fi

        # Affichage du menu avec gestion d'annulation
        if ! action=$(whiptail \
                --title "Sélectionnez une action" \
                --menu "Choisissez une action à exécuter :" 20 70 12 \
                "${items[@]}" \
                3>&1 1>&2 2>&3); then
            printf "Action annulée par l'utilisateur.\n" >&2
            exit 0
        fi

        # Validation de l'entrée
        if ! validate_action "$action"; then
            echo_status_error "Action invalide détectée : $action"
            sleep 2
            continue
        fi

        # Gestion de la sortie
        [[ "$action" == "QUITTER" ]] && exit 0

        # Exécution du script
        if execute_script "$action"; then
            whiptail --title "Succès" \
                --msgbox "Action $action terminée avec succès." 6 50
        else
            whiptail --title "Erreur" \
                --msgbox "Échec de l'exécution de $action." 6 50
            sleep 2
        fi
    done
}

# Point d'entrée principal
main() {
    # Vérification des prérequis
    command -v whiptail >/dev/null 2>&1 || {
        printf "Erreur: whiptail requis mais non installé\n" >&2
        exit 1
    }

    [[ -n "${BIN_DIR:-}" ]] || {
        printf "Erreur: variable BIN_DIR non définie\n" >&2
        exit 1
    }

    menu_tui
}

# Exécution seulement si script appelé directement
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
