#!/usr/bin/env bash
set -euo pipefail

MAINTENANCE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${HARDWARE_DIR%%/core*}/core"

for file in "$MAINTENANCE_DIR"/*.sh; do
    [[ "$file" == "$MAINTENANCE_DIR/init.sh" ]] && continue
    source "$file"
done
