#!/usr/bin/env bash

PROMPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$PROMPT_DIR/echo_status.sh"

prompt_yes_no() {
    local question="$1"
    local reponse
    while true; do
        echo_status "$question (Oui/Non)"
        read -r reponse
        if [[ "$reponse" =~ ^([oO][uU][iI]|[oO][kK]|[yY][eE][sS]|[yY])$ ]]; then
            return 0
        elif [[ "$reponse" =~ ^([nN][oO][nN]|[nN][oO]|[nN])$ ]]; then
            return 1
        else
            echo_status_warn "Réponse non reconnue. Merci de répondre Oui ou Non."
        fi
    done
}
