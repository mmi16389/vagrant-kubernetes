#!/bin/bash
#set -e
# Met à jour la liste des paquets
sudo apt-get update

# Installe les paquets nécessaires
sudo apt-get install -y apt-transport-https curl gnupg lsb-release

# Crée le dossier des clés si nécessaire
sudo mkdir -p /etc/apt/keyrings

# Ajoute la clé GPG du dépôt Kubernetes
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Ajoute le dépôt Kubernetes
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# Met à jour la liste des paquets après ajout du dépôt
sudo apt-get update

# Installe kubelet, kubeadm et kubectl
sudo apt-get install -y kubelet kubeadm kubectl

# Empêche leur mise à jour automatique
sudo apt-mark hold kubelet kubeadm kubectl

