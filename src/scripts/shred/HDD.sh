#!/usr/bin/env bash

set -euo pipefail

echo -e "Liste des disques connectés :"
lsblk -x NAME | awk '{print " -", $1, "-->", $4, " "}'

echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

source "./shred_disk.sh"
shred_disk "sudo shred -n 3 -z -u -v /dev/%s"
