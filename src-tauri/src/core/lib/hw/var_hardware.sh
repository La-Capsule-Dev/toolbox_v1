#!/usr/bin/env bash

set -euo pipefail

batterie=$(battery_parser)
batmod=$(batmod_parser)
power=$(power_parser)
ecran=$(ecran_parser)
taille=$(taille_parser)
telecrante=$(telecrante_parser)
graphique=$(graphique_parser)
mem=$(mem_parser)
reseau=$(reseau_parser)
arch=$(arch_get)
cpu_model=$(cpu_parser)
disque=$(disque_parser)
marque=$(marque_get)
model=$(model_get)
serial=$(serial_get)
