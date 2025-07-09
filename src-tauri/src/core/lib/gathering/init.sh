#!/usr/bin/env bash
set -euo pipefail

GATHERING_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${GATHERING_DIR%%/core*}/core"

for file in "$GATHERING_DIR"/*.sh; do
    [[ "$file" == "$GATHERING_DIR/init.sh" ]] && continue
    source "$file"
done
