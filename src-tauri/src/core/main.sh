#!/usr/bin/env bash
set -euo pipefail

CORE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export CORE_DIR
source "$CORE_DIR/etc/config/path.env" || echo "Error sourcing"
source "$CORE_DIR/lib/ui/echo_status.sh"             || echo "Error sourcing echo_status.sh"

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
    local folder="bin"
    find "$folder" -type f -name "*.sh" | sed 's/\.sh$//' | xargs -n1 basename
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
