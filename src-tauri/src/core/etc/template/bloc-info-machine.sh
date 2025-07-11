#!/usr/bin/env bash
set -euo pipefail

TEMPLATE_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DIR_ROOT="${TEMPLATE_DIR%%/core*}/core"
source "$DIR_ROOT/lib/hardware/init.sh"

afficher_bloc_info_machine() {
    cat <<EOF
----------------------------------------------------------------------------| Machine |
Marque          : $marque
Modèle          : $model
NumSérie        : $serial
-------------------------------------------------------------------------| Processeur |
Architecture    : $arch
$cpu_model
------------------------------------------------------------------------| Mémoire RAM |
$mem
------------------------------------------------------------------| Stockage de masse |
$disque
----------------------------------------------------------------| État de la batterie |
$batterie
$batmod
$power
---------------------------------------------------------------------| Cartes réseaux |
$reseau
------------------------------------------------------------------| Cartes graphiques |
$graphique
--------------------------------------------------------------------------| Affichage |
$telecrante
$taille
---------------------------------------------------------------------------------------
Pour tout commentaire supplémentaire, merci d'écrire proprement au dos de cette feuille
EOF
}
