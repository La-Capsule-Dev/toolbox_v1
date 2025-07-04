#!/usr/bin/env bash

set -euo pipefail

mem_parser(){
  sudo inxi -m | \
  sed -e '1,3d' \
      -e ':a;N;$!ba;s/\n//g' \
      -e "s/  Device-1:/Slot numéro 1   :/"  \
      -e "s/DIMM A//" \
      -e "s/size://" \
      -e "s/speed/ Fréquence /" \
      -e "s/:  /:/" \
      -e "s/  Device-2:/\nSlot numéro 2   :/" \
      -e "s/DIMM B//" \
      -e "s/size://" \
      -e "s/speed/ Fréquence /" \
      -e "s/:  /:/" \
      -e "s/DIMM C//" \
      -e "s/size://" \
      -e "s/speed/ Fréquence /" \
      -e "s/  Device-3:/\nSlot numéro 3   :/" \
      -e "s/:  /:/" \
      -e "s/DIMM D//" \
      -e "s/size://" \
      -e "s/speed/ Fréquence /" \
      -e "s/  Device-4:/\nSlot numéro 4   :/" \
      -e "s/:  /:/" \
      -e "s/  Device-5:/\nSlot numéro 5   :/" \
      -e "s/:  /:/" \
      -e "s/  Device-6:/\nSlot numéro 6   :/" \
      -e "s/:  /:/" \
      -e "s/  Device-7:/\nSlot numéro 7   :/" \
      -e "s/:  /:/" \
      -e "s/  Device-8:/\nSlot numéro 8   :/" \
      -e "s/:  /:/"
}
