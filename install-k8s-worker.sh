#!/bin/bash

echo -e "100.0.0.4 master.ethans.com master\n100.0.0.5 worker.ethans.com worker" | sudo tee -a /etc/hosts
sudo apt-get update
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start  docker
sudo systemctl status docker
sudo ufw disable
sudo swapoff -a
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo bash -c 'echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'
sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl
sudo systemctl enable kubelet
sudo systemctl start kubelet