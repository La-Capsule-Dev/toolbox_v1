#!/bin/bash
printf "\e[8;22;50t" 
echo "" &&
sleep 1 &&

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

echo ""
echo "            Listing des disques présents " &&
echo ""
sleep 1 &&

echo "$disque" &&

echo ""
echo "                      ✅ OK ✅" &&
sleep 0.5 &&

echo ""
echo " Veuillez choisir le disque ou la partition MASTER " &&
echo ""
sleep 1 &&

echo -n "/dev/"
read -r premierChoix &&

echo ""
echo "  Veuillez choisir le disque ou la partition SLAVE " &&
echo ""
sleep 1 &&

echo -n "/dev/"
read -r secondChoix &&

echo ""
sleep 0.5 
echo ""

(pv -n | sudo dd if=/dev/$premierChoix of=/dev/$secondChoix bs=512 status=progress conv=sync,noerror && sync) 2>&1 | dialog --gauge "la commande dd est en cours d'exécution, merci de patienter..." 10 70 0
