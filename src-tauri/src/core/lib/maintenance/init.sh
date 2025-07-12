#!/usr/bin/env bash
set -euo pipefail

MAINTENANCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$LIB_DIR/ui/echo_status.sh"

for file in "$MAINTENANCE_DIR"/*.sh; do
    [[ "$file" == "$MAINTENANCE_DIR/init.sh" ]] && continue
    source "$file"
done
