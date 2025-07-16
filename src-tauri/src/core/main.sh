#!/usr/bin/env bash
set -euo pipefail

CORE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export CORE_DIR
source "$CORE_DIR/etc/config/path.env" || echo "Error sourcing"
source "$LIB_DIR/ui/echo_status.sh"

# TODO: Shellcheck - A voir

usage() {
    cat <<EOF
Usage: $0 <ACTION> [ARGS...]

Actions disponibles :
$(list_actions | xargs -n1 echo "  -")
Exemple: $0 PRINT
EOF
}

list_actions() {
    for script in "$BIN_DIR"/*.sh; do
        [ -e "$script" ] || continue
        echo "  - $(basename "$script" .sh)"
    done
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
