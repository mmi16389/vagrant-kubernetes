#!/bin/bash

# Création de l'utilisateur personnalisé
USERNAME="devuser"
PASSWORD="devpassword"

# Créer utilisateur sans mot de passe sudo
useradd -m -s /bin/bash $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd
usermod -aG sudo $USERNAME

# Configurer SSH pour devuser avec la clé publique de Vagrant
mkdir -p /home/$USERNAME/.ssh
cp /home/vagrant/.ssh/authorized_keys /home/$USERNAME/.ssh/
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
chmod 600 /home/$USERNAME/.ssh/authorized_keys

# Supprimer les paquets inutiles
apt-get clean
