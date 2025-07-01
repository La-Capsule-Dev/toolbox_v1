#!/bin/bash 

printf "\e[8;92;90t" 

# Escape code
esc=`echo -en "\033"`

# Set colors
cc_red="${esc}[01;31m"
cc_red_back="${esc}[041;1m"
cc_green="${esc}[0;32m"
cc_yellow="${esc}[037;1m"
cc_yellow_back="${esc}[0;43m"
cc_normal=`echo -en "${esc}[m\017"`

echo ""
echo -e "${cc_red_back}${cc_yellow} Liste des disques connectés :${cc_yellow_back}${cc_red}"
sleep 1
lsblk -x NAME | awk '{print echo " - " $1 echo " --> " $4 echo "   "}'
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur à shredder ${cc_normal} ex: b pour le /dev/sdb"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/sd" && read
sleep 1
gnome-terminal --geometry 60x5 -- sudo shred -n 3 -z -u -v /dev/sd$REPLY
sleep 1
echo ""
