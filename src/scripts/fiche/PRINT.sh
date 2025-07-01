#!/bin/bash

######## Déclaration de variables #########

e=$(echo " ")

######## Traitement des commandes #########
# Machine #
marque=$(sudo dmidecode -s system-manufacturer)
model=$(sudo dmidecode -s system-product-name)
serial=$(sudo dmidecode -s system-serial-number)
# Processeur #
arch=$(uname -m)
modele=$(cat /proc/cpuinfo | sed "s/model name/Modèle   /" | sed -n 5p)
# Mémoire ram #
mem=$(sudo inxi -m |  
sed '1,3d' |
tr -d "\n" | 
sed "s/  Device-1:/Slot numéro 1   :/"  | 
sed "s/DIMM A//" |
sed "s/size://" | 
sed "s/speed/ Fréquence /" | 
sed "s/:  /:/" |
sed "s/  Device-2:/\nSlot numéro 2   :/" | 
sed "s/DIMM B//" |
sed "s/size://" | 
sed "s/speed/ Fréquence /" | 
sed "s/:  /:/" |
sed "s/DIMM C//" |
sed "s/size://" | 
sed "s/speed/ Fréquence /" | 
sed "s/  Device-3:/\nSlot numéro 3   :/" | 
sed "s/:  /:/" |
sed "s/DIMM D//" |
sed "s/size://" | 
sed "s/speed/ Fréquence /" | 
sed "s/  Device-4:/\nSlot numéro 4   :/" | 
sed "s/:  /:/" |
sed "s/  Device-5:/\nSlot numéro 5   :/" | 
sed "s/:  /:/" |
sed "s/  Device-6:/\nSlot numéro 6   :/" | 
sed "s/:  /:/" |
sed "s/  Device-7:/\nSlot numéro 7   :/" | 
sed "s/:  /:/" |
sed "s/  Device-8:/\nSlot numéro 8   :/" | 
sed "s/:  /:/")
# Stockage de masse #
cible=$(sudo skdump --overall $(sudo blkid | cut -d ':' -f1 | sed '1d' | sed -e '2,5d' | cut -d '1' -f1) |
sed "s/GOOD/BON/" |
sed "s/BAD/MAUVAIS/")
type=$(sudo lsblk -o name,rota | 
tail | 
sed "s/loop.*$//" | 
sed "s/sr0.*$//" | 
sed "/^[[:space:]]*$/d" | 
sed "1,8d" | 
sed "s/sda       1/HDD/" | 
sed "s/NAME//" |
sed "s/ROTA//" |
sed "s/nvme*/SSD/")
disque=$(sudo inxi -D |
tr -d " " | 
sed '1,2d' |
sed "s/ID-1:/Disque interne  :/" |
sed "s/ID-2:/Disque interne  :/" |
sed "s/\/dev/ $type/" |
sed "s/type/\ntype            : /" |
sed "s/vendor:/\nMarque          : /" |
sed "s/model:/\nModèle          : /" |
sed "s/size:/\nTaille          : /" |
sed "s/used:/Utilisé         : /" |
sed "s/GiB/ GiB\nétat            : $cible/" |
sed "/^[[:space:]]*$/d")
# Batterie #
batterie=$(sudo acpi -i |
sed "s/Full, /Chargée à /" |
sed "s/Battery 0: //" |
sed "s/Charging,/Chargement      :/" |
sed "s/Discharging,/Déchargée à     :/" |
sed "s/Unknow,/Inconnue        :/" |
sed "s/%,/%\nTemps restant   :/" |
sed "s/until charged//" |
sed "s/design capacity/Capacité totale :/" |
sed "s/mAh,/mAh\n/" |
sed "s/ last full capacity/Capacité réelle :/" |
sed "s/=/ soit environ/" )
batmod=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 |
awk 'NR>1 && NR< 5' | 
sed "s/  vendor:               /Vendeur         : /" |
sed "s/  model:                /Modèle          : /" |
sed "s/  serial:               /Série           : /"|
sed "s/  power supply:         no/Pas de batterie détectée/" |
sed "s/  updated:         .*$//" |
sed "s/  has history:          no//")
power=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | 
awk /energy-full-design/,/voltage/ |
sed "s/    energy-full-design:  /Puissance       : /" |
sed "s/    energy-rate:         /Taux            : /" |
sed "s/    voltage:             /Tension         : /" )
# Cartes Réseaux #
reseau=$(sudo inxi -N |
sed "s/Network://" | 
sed "s/  Device-1/Carte numéro 1  /" |
sed "s/  Device-2/Carte numéro 2  /" |
sed "s/  Device-3/Carte numéro 3  /" |
sed "s/ 802.11.*$/ Carte WIFI/" | 
sed "s/ Gigabit Ethernet/ Carte ETHERNET/" | 
sed "s/ Ethernet Adapter/ Carte ETHERNET/" |  
sed "s/type: .*$//" | 
sed "s/driver: .*$//" | 
sed "/^[[:space:]]*$/d")
# Carte graphique #
graphique=$(sudo inxi -G | 
sed "1d" | 
sed "s/  Device-1:/Modèle          :/" |
sed "s/  Device-2:/Caméra          :/" |
sed "s/  Message:/Message          :/" |
sed "s/  OpenGL://" |
sed "s/renderer:/\nPilote          :/" |
sed "s/  v:/Version         :/" |
sed "s/driver: .*$//" | 
sed "s/Display: .*$//" | 
sed "s/resolution: .*$//" | 
sed "3,4d" |
sed "s/  Graphics & Display//" |
sed "s/  unloaded: fbdev,vesa//" |
sed "/^[[:space:]]*$/d")
ecran=$(sudo xrandr | 
awk '/connected/' | 
sed "s/(.*$//" | 
sed "s/DVI-I/DVI/" |
sed "s/Virtual-/Écran virtuel   /" |
sed "s/eDP-1 /Écran intégré   : /" |
sed "s/DP-1 /Port VGA        : /" |
sed "s/HDMI-1 /Port HDMI       : /" |
sed "s/disconnected/${LRED}déconnecté${R}/" |
sed "s/connected/${LGREEN}connecté${R}/" |
sed "s/primary/${YB}principal${R}/")
taille=$(sudo python3 /usr/share/LACAPSULE/MULTITOOL/Gathering/dimension.py)
telecrante=$(sudo xrandr | 
awk '/connected/' | 
sed "s/(.*$//" | 
sed "s/VGA-1/Port VGA 1      :/" |
sed "s/VGA-2/Port VGA 2      :/" |
sed "s/DVI-I/DVI/" |
sed "s/DVI-2/DVI-2/" |
sed "s/Virtual-/Écran virtuel   /" |
sed "s/eDP-1/Écran intégré   :/" |
sed "s/eDP-2/Écran virtuel   :/" |
sed "s/DP-1/Port VGA        :/" |
sed "s/DP-2/Port VGA 2      :/" |
sed "s/HDMI-1/Port HDMI       :/" |
sed "s/HDMI-2/Port HDMI 2     :/" |
sed "s/disconnected/déconnecté/" |
sed "s/connected/connecté/" |
sed "s/primary/principal/")

######## Sortie de texte #########
 
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

echo "${resultat}" | 
iconv -f utf-8 -t iso-8859-1 | 
enscript --header='Fait le $F        Reconditionnement fait par :  ____________________________________' --title='Sortie PDF' -X 88591 -o - | 
ps2pdf - $HOME/resultat.pdf && x-www-browser $HOME/resultat.pdf

