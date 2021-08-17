#!/bin/bash

sudo apt-get update -y && sudo apt-get dist-upgrade -y
sudo apt-get install -y -q \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y -q \
	docker-ce \
	docker-ce-cli \
	containerd.io

sudo usermod -aG docker $USER
sudo systemctl start docker
sudo systemctl enable docker

sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list && sudo apt-get update

sudo apt install  -y -q \
	kubeadm=1.21.1-00 \
	kubelet=1.21.1-00 \
	kubectl=1.21.1-00 \
	kubernetes-cni \
	&& sudo apt-mark hold kubeadm kubelet kubectl
