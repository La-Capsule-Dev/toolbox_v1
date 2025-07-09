#!/usr/bin/env bash
set -euo pipefail

echo "[init.sh] Entrée dans init.sh"

UTILS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

for file in "$UTILS_DIR"/*.sh; do
    [[ "$file" == "$UTILS_DIR/init.sh" ]] && continue
    source "$file"
done

echo "[init.sh] Chargement terminé"
