#!/bin/bash
# Set modules and desactive swapp
# Désactive le swap (requis par kubeadm)
sudo swapoff -a
sudo sed -i '/^\/swap\.img[[:space:]]\+none[[:space:]]\+swap[[:space:]]\+sw[[:space:]]\+0[[:space:]]\+0/ s/^/#/' /etc/fstab

## Module overlay and bridge
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

#!/bin/bash
# Set modules and desactive swapp
# Désactive le swap (requis par kubeadm)
sudo swapoff -a
sudo sed -i '/^\/swap\.img[[:space:]]\+none[[:space:]]\+swap[[:space:]]\+sw[[:space:]]\+0[[:space:]]\+0/ s/^/#/' /etc/fstab

## Module overlay and bridge
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Aller dans un répertoire temporaire
cd /tmp

# Télécharger l’archive
wget https://github.com/containernetworking/plugins/releases/download/v1.6.2/cni-plugins-linux-amd64-v1.6.2.tgz

# Créer le dossier si ce n’est pas déjà fait
sudo mkdir -p /opt/cni/bin

# Extraire les binaires dans /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf cni-plugins-linux-amd64-v1.6.2.tgz


