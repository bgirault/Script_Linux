#!/bin/bash


# Script de paramétrage d'un serveur Debian type TP TAI
# B.Girault le 10/01/2018
# Pour lancer le paramétrage automatisé, il faut donner les droits d'execution au script avec la commande :
# chmod +x parametrage.sh 
# puis le lancer avec :
# ./parametrage.sh



# Commente la 5 ligne du cd-rom dans la sources.list
path_sources='/etc/apt'
sed 5s/deb/#\ deb/ $path_sources/sources.list > $path_sources/sources.tmp && mv $path_sources/sources.tmp $path_sources/sources.list
echo cd-rom désactivé

# installation ssh
apt install ssh -y
echo ssh installé

# Parametrage port ssh
echo Quel port pour le SSH ?
read port
sed 13s/#Port/Port/ $path_ssh/sshd_config > $path_ssh/sshd_config.tmp && mv $path_ssh/sshd_config.tmp $path_ssh/sshd_config
sed 13s/22/$port/ $path_ssh/sshd_config > $path_ssh/sshd_config.tmp && mv $path_ssh/sshd_config.tmp $path_ssh/sshd_config
echo port changé en $port

# acces root interdit sur SSH
sed 32s/#PermitRootLogin/PermitRootLogin/ $path_ssh/sshd_config > $path_ssh/sshd_config.tmp && mv $path_ssh/sshd_config.tmp $path_ssh/sshd_config
sed 32s/prohibit-password/no/ $path_ssh/sshd_config > $path_ssh/sshd_config.tmp && mv $path_ssh/sshd_config.tmp $path_ssh/sshd_config

# acces SSH pour un utilisateur
echo Nom utilisateur pour le ssh
read user
sed "36i\Allowusers\ $user" $path_ssh/sshd_config > $path_ssh/sshd_config.tmp && mv $path_ssh/sshd_config.tmp $path_ssh/sshd_config

# redemarrage SSH
systemctl restart ssh.service
echo l\'utilisateur SSH $user est autorisé

# installation de qq paquets utiles

apt install -y vim nano wget zip unzip bzip2 linux-kernel-headers screen ca-certificates curl

# mise à jour
apt-get update && apt-get upgrade

echo Votre serveur Debian est prêt "!"
echo cd-rom désactivé
echo SSH installé
echo port SSH changé en $port
echo l\'utilisateur SSH $user est autorisé
echo Outils installés : vim nano wget zip unzip bzip2 linux-kernel-headers screen ca-certificates curl

