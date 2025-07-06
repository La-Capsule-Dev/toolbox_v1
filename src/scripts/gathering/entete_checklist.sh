#!/usr/bin/env bash
set -euo pipefail

afficher_entete_checklist() {
    cat <<'EOF'
Nettoyage intérieur [ ]  Nettoyage extérieur [ ]  Aspect  neuf [ ] occasion [ ] nul [ ]
_______________________________________________________________________________________
Sorties vidéo  HDMI [ ] ok [ ] nul [ ]           -->  Webcam   ok [ ] moyen [ ] nul [ ]
               DP   [ ] ok [ ] nul [ ]           Port carte SD ok [ ] nul   [ ]
               VGA  [ ] ok [ ] nul [ ]           Port USB (si défectueux) nombre ______
               DVI  [ ] ok [ ] nul [ ]  autre type :           ok [ ] nul [ ]
Clavier        ok [ ] moyen [ ] nul [ ]       Pad/souris       ok [ ] moyen [ ] nul [ ]
Carte son      ok [ ] nul [ ]                 Haut-parleurs    ok [ ] moyen [ ] nul [ ]
Sortie audio   ok [ ] nul [ ]                 Entrée micro     ok [ ] nul [ ]
Micro interne  ok [ ] nul [ ]        Autre :                   ok [ ] moyen [ ] nul [ ]
_______________________________________________________________________________________
Température du processeur avant stress test    Moins de 90°c [ ]    Plus de 90°c [ ]
                          après stress test    Moins de 90°c [ ]    Plus de 90°c [ ]
Changement de pâte thermique                   oui           [ ]    non          [ ]
Shred des disques durs                         oui           [ ]    non          [ ]
_______________________________________________________________________________________
Le chargeur du pc est-il en bon état ?         oui           [ ]    non          [ ]
La pile setup a-t'elle été changée ?           oui           [ ]    non          [ ]
Le lecteur DVD est-il fonctionnel ?            oui  [ ] non  [ ]
EOF
}
