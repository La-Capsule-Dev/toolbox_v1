#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${TEMPLATE_DIR%%/core*}/core"
source "$DIR_ROOT/lib/gathering/init.sh"

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

afficher_bloc_info_machine() {
    cat <<EOF
---------------------------------------------------------------------------| Machine |
Marque          : $marque
Modèle          : $model
NumSérie        : $serial
------------------------------------------------------------------------| Processeur |
Architecture    : $arch
$cpu_model
-----------------------------------------------------------------------| Mémoire RAM |
$mem
-----------------------------------------------------------------| Stockage de masse |
$disque
---------------------------------------------------------------| État de la batterie |
$batterie
$batmod
$power
--------------------------------------------------------------------| Cartes réseaux |
$reseau
-----------------------------------------------------------------| Cartes graphiques |
$graphique
-------------------------------------------------------------------------| Affichage |
$telecrante
$taille
--------------------------------------------------------------------------------------
Pour tout commentaire supplémentaire, merci d'écrire proprement au dos de cette feuille
EOF
}
