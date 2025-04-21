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

