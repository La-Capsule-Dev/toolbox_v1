#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/hw/init.sh"

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
