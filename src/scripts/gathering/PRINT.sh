#!/usr/bin/env bash
set -euo pipefail

source "./converter.sh"
 
resultat=$(
echo "  Nettoyage intérieur [ ]  Nettoyage extérieur [ ]  Aspect  neuf [ ] occasion [ ] nul [ ]  "
echo "___________________________________________________________________________________________"
echo "  Sorties vidéo  HDMI [ ] ok [ ] nul [ ]           -->  Webcam   ok [ ] moyen [ ] nul [ ]  "
echo "                 DP   [ ] ok [ ] nul [ ]           Port carte SD ok [ ] nul   [ ]          "
echo "                 VGA  [ ] ok [ ] nul [ ]           Port USB (si défectueux) nombre ________"
echo "                 DVI  [ ] ok [ ] nul [ ]  autre type :           ok [ ] nul [ ]            "
echo "  Clavier        ok [ ] moyen [ ] nul [ ]       Pad/souris       ok [ ] moyen [ ] nul [ ]  "
echo "  Carte son      ok [ ] nul [ ]                 Haut-parleurs    ok [ ] moyen [ ] nul [ ]  "
echo "  Sortie audio   ok [ ] nul [ ]                 Entrée micro     ok [ ] nul [ ]            "
echo "  Micro interne  ok [ ] nul [ ]        Autre :                   ok [ ] moyen [ ] nul [ ]  "
echo "___________________________________________________________________________________________"
echo "  Température du processeur avant stress test    Moins de 90°c [ ]    Plus de 90°c [ ]     "
echo "                            après stress test    Moins de 90°c [ ]    Plus de 90°c [ ]     "
echo "  Changement de pâte thermique                   oui           [ ]    non          [ ]     "
echo "  Shred des disques durs                         oui           [ ]    non          [ ]     "
echo "___________________________________________________________________________________________"
echo "  Le chargeur du pc est-il en bon état ?         oui           [ ]    non          [ ]     "
echo "  La pile setup a-t'elle été changée ?           oui           [ ]    non          [ ]     "
echo "  Le lecteur DVD est-il fonctionnel ?            oui  [ ] non  [ ]                         "
echo "--------------------------------------------------------------------------------| Machine |"
echo "Marque          : $marque"
echo "Modèle          : $model"
echo "NumSérie        : $serial"
echo "-----------------------------------------------------------------------------| Processeur |"
echo "Architecture    : $arch"
echo "$modele"
echo "----------------------------------------------------------------------------| Mémoire RAM |"
echo "$mem"
echo "----------------------------------------------------------------------| Stockage de masse |"
echo "$disque"
echo "--------------------------------------------------------------------| État de la batterie |"
echo "$batterie"
echo "$batmod"
echo "$power"
echo "-------------------------------------------------------------------------| Cartes réseaux |"
echo "$reseau"
echo "----------------------------------------------------------------------| Cartes graphiques |"
echo "$graphique"
echo "------------------------------------------------------------------------------| Affichage |"
echo "$telecrante"
echo "$taille"
echo "-------------------------------------------------------------------------------------------"
echo "  Pour tout commentaire supplémentaire, merci d'écrire proprement au dos de cette feuille  "
)

echo "${resultat}" |  iconv -f utf-8 -t iso-8859-1 | 
enscript --header='Fait le $F        Reconditionnement fait par :  ____________________________________' --title='Sortie PDF' -X 88591 -o - | 
ps2pdf - $HOME/resultat.pdf && x-www-browser $HOME/resultat.pdf
