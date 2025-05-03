#!/bin/bash

# Détecter automatiquement l'interface avec l'IP privée (192.168.56.x)
NODE_IP=$(ip -4 addr show | grep '192.168.56' | awk '{print $2}' | cut -d'/' -f1)

if [ -z "$NODE_IP" ]; then
  echo "❌ Impossible de détecter une IP dans la plage 192.168.56.x"
  exit 1
fi

echo "✅ IP détectée : $NODE_IP"

# Ajouter ou mettre à jour les arguments du kubelet
echo "🔧 Configuration de kubelet avec l'IP $NODE_IP"
echo "KUBELET_EXTRA_ARGS=--node-ip=$NODE_IP" | sudo tee /etc/default/kubelet

# Redémarrer kubelet pour prendre en compte le changement
echo "🔁 Redémarrage de kubelet"
sudo systemctl daemon-reexec
sudo systemctl restart kubelet

echo "✅ Terminé ! Attends quelques secondes, puis vérifie avec : kubectl get nodes -o wide"
