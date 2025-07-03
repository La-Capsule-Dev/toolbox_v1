#!/usr/bin/env bash

printf "\e[8;92;90t" 

source "./../UI/color.sh"

echo ""
echo -e "${cc_red_back}${cc_yellow} Liste des disques connectés :${cc_yellow_back}${cc_red}"
lsblk -x NAME | awk '{print echo " - " $1 echo " --> " $4 echo "   "}'
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur à shredder ${cc_normal} ex: b pour le /dev/sdb"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read 
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
echo ""
