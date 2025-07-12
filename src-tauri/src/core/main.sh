#!/usr/bin/env bash
set -euo pipefail

export CORE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$CORE_DIR/etc/config/find_project_root.sh" || echo "Error sourcing"
source "$CORE_DIR/etc/config/path.env" || echo "Error sourcing"
source "$LIB_DIR/ui/echo_status.sh"


usage() {
    cat <<EOF
Usage: $0 <ACTION> [ARGS...]

Actions disponibles :
$(ls "$BIN_DIR" | grep -E '\.sh$' | sed 's/\.sh$//' | xargs -n1 echo "  -")
Exemple: $0 PRINT
EOF
}

list_actions() {
    ls "$BIN_DIR" | grep -E '\.sh$' | sed 's/\.sh$//'
}

# Entrypoint
ACTION="${1:-}"
shift || true

case "$ACTION" in
    ""|"help"|"--help"|"-h")
        usage
        exit 0
        ;;
    "list")
        list_actions
        exit 0
        ;;
    *)
        SCRIPT="$BIN_DIR/${ACTION}.sh"
        if [[ -f "$SCRIPT" && -x "$SCRIPT" ]]; then
            source "$SCRIPT" "$@"
        elif [[ -f "$SCRIPT" ]]; then
            source "$SCRIPT" "$@"
        else
            echo_status_error "Action inconnue ou script absent: $ACTION"
        fi
        ;;
esac
