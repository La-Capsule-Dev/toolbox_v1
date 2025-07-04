#!/usr/bin/env bash
set -euo pipefail

LOGFILE="/tmp/toolbox.log"

log_info()  { echo "[INFO]  $(date +"%F %T") $*" >> "$LOGFILE"; }
log_warn()  { echo "[WARN]  $(date +"%F %T") $*" >> "$LOGFILE"; }
log_error() { echo "[ERROR] $(date +"%F %T") $*" >> "$LOGFILE"; }
