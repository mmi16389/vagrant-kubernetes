#!/bin/bash
#set -e 

sudo kubeadm config images pull

sudo kubeadm init --apiserver-advertise-address=192.168.56.10
# --apiserver-advertise-address
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Calico networkhhg58o.tf9zhckwi5r1pn5p 
#su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml"