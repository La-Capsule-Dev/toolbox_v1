#!/usr/bin/env bash

printf "\e[8;92;90t" 

source "./../UI/color.sh"

# TODO: To Refactor
echo ""
echo -e "${cc_red_back}${cc_yellow} Liste des disques connectés :${cc_yellow_back}${cc_red}"
sleep 1
nvme list | awk '{print echo " - " $1 echo " --> " $4 echo "   "}'
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du NVME à shredder ${cc_normal} ex: 0n1 pour le /dev/nvme0n1"
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
echo -e "${cc_red_back}${cc_yellow} Veuillez entrer la lettre du lecteur suivant ${cc_normal}"
sleep 1
echo ""
echo -n "${cc_yellow} -----> ${cc_normal} dev/nvme" && read 
sleep 1
gnome-terminal --geometry 60x5 -- sudo nvme format -s2 /dev/nvme$REPLY && blkdiscard /dev/nvme$REPLY
sleep 1
echo ""
