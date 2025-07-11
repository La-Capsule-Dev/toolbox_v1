#!/usr/bin/env bash
set -euo pipefail

HW_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${HW_DIR%%/core*}/core"

for file in "$HW_DIR"/*.sh; do
    [[ "$file" == "$HW_DIR/init.sh" ]] && continue
    source "$file"
done
