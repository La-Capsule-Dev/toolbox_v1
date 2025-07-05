#!/usr/bin/env bash

set -euo pipefail

echo -e "Référence du disque connecté:"
nvme list

echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "Liste des disques connectés :"
lsblk -x NAME | awk '{print " -", $1, "-->", $4, " "}'
echo "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------"

source "./shred_disk.sh"

shred_disk "sudo nvme format -s2 /dev/%s && blkdiscard /dev/%s"
