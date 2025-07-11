#!/usr/bin/env bash
set -euo pipefail

HARDWARE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${HARDWARE_DIR%%/core*}/core"

for file in "$HARDWARE_DIR"/*.sh; do
    [[ "$file" == "$HARDWARE_DIR/init.sh" ]] && continue
    source "$file"
done
