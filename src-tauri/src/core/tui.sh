#!/usr/bin/env bash
set -euo pipefail

export CORE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$CORE_DIR/etc/config/find_project_root.sh" || echo "Error sourcing find_project_root.sh"
source "$CORE_DIR/etc/config/path.env"           || echo "Error sourcing path.env"
source "$LIB_DIR/ui/echo_status.sh"             || echo "Error sourcing echo_status.sh"

# HACK: IMPROVE DIALOG TUI

# MAP actions/descriptions
declare -A ACTION_DESC=(
    [PRINT]="Outils d'impression/rapport"
    [INSTALL_MAJ]="Install/Mise à jour système"
    [BOOT]="Réparation du boot"
    [STRESS-TEST]="Test de stress matériel"
    [CLONE]="Clonage de partitions/disques"
    [HDD]="Shred disque dur - HDD"
    [SSD]="Shred disque dur - SSD"
    [CLEAN]="Nettoyage des fichiers inutiles"
    [ISO]="Création d'une image ISO"
    [BASE]="Voir le site de la Goupil"
)

# Lister les actions disponibles
list_actions() {
    ls "$BIN_DIR"/*.sh 2>/dev/null | xargs -n1 basename | sed 's/\.sh$//'
}

# Génère la liste menu dialog
build_menu_items() {
    local menu=()
    for action in $(list_actions); do
        local tag="${action%.*}"
        local desc="${ACTION_DESC[$tag]:-}"
        menu+=("$tag" "$desc")
    done
    menu+=("QUITTER" "Sortir de l'outil")
    printf "%s\n" "${menu[@]}"
}

# Boucle principale du TUI
menu_tui() {
    dialog --msgbox "Bienvenue sur la Toolbox" 8 40

    while :; do
        # Construit les items à chaque itération (en cas de scripts ajoutés/supprimés dynamiquement)
        IFS=$'\n' read -r -d '' -a MENU_ITEMS < <(build_menu_items && printf '\0')

        ACTION=$(dialog \
                --clear \
                --title "Sélectionnez une action" \
                --menu "Choisissez une action à exécuter :" \
                20 70 12 \
                "${MENU_ITEMS[@]}" \
                3>&1 1>&2 2>&3
        ) || { echo "Action annulée." >&2; exit 1; }

        # Sanitize
        if ! [[ "$ACTION" =~ ^[A-Za-z0-9_-]+$ ]]; then
            echo_status_error "Action invalide : $ACTION"
            exit 1
        fi

        # Quitter ?
        [[ "$ACTION" == QUITTER ]] && exit 0

        # Cherche et exécute le script
        SCRIPT="$BIN_DIR/${ACTION}.sh"
        if [[ -f "$SCRIPT" && -x "$SCRIPT" ]]; then
            bash "$SCRIPT"
        elif [[ -f "$SCRIPT" ]]; then
            bash "$SCRIPT"
        else
            echo_status_error "Action inconnue ou script absent : $ACTION"
            sleep 2
        fi

        # Optionnel : Pause ou message après chaque action, sinon remove
        dialog --msgbox "Action $ACTION terminée." 6 40
    done
}

menu_tui
