#!/bin/bash

####################

echo Setup: Install go

sudo apt-get update && sudo apt-get install build-essential -y -q

cd /tmp
wget https://dl.google.com/go/go1.15.15.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.15.15.linux-amd64.tar.gz
rm -rf go1.15.15.linux-amd64.tar.gz

####################

echo Setup: Install bazel

sudo apt-get update 
sudo apt install g++ unzip zip -y -q
sudo apt-get install openjdk-8-jdk -y -q
cd /tmp
wget https://github.com/bazelbuild/bazel/releases/download/0.26.1/bazel-0.26.1-installer-linux-x86_64.sh
chmod +x bazel-0.26.1-installer-linux-x86_64.sh
./bazel-0.26.1-installer-linux-x86_64.sh --user

####################

echo Setup: Enlist arktos

cd ~
git clone https://github.com/CentaurusInfra/arktos.git ~/go/src/k8s.io/arktos
cd ~/go/src/k8s.io/arktos && git checkout v0.9
cd ~/go/src/k8s.io
ln -s ./arktos kubernetes

git config --global credential.helper 'cache --timeout=3600000'

####################

echo Setup: Install etcd

cd ~/go/src/k8s.io/arktos/
git tag v1.15.0
./hack/install-etcd.sh

####################

echo Setup: Install Docker

sudo apt-get update && sudo apt -y install docker.io
sudo gpasswd -a $USER docker

####################

echo Setup: Install crictl

cd /tmp
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.17.0/crictl-v1.17.0-linux-amd64.tar.gz
sudo tar -zxvf crictl-v1.17.0-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-v1.17.0-linux-amd64.tar.gz

touch /tmp/crictl.yaml
echo runtime-endpoint: unix:///run/containerd/containerd.sock >> /tmp/crictl.yaml
echo image-endpoint: unix:///run/containerd/containerd.sock >> /tmp/crictl.yaml
echo timeout: 10 >> /tmp/crictl.yaml
echo debug: true >> /tmp/crictl.yaml
sudo mv /tmp/crictl.yaml /etc/crictl.yaml

sudo mkdir -p /etc/containerd
sudo rm -rf /etc/containerd/config.toml
sudo containerd config default > /tmp/config.toml
sudo mv /tmp/config.toml /etc/containerd/config.toml
sudo systemctl restart containerd

####################

echo Setup: Install miscellaneous

sudo apt-get update 
sudo apt install awscli -y -q
sudo apt install jq -y -q

####################

echo Setup: Install Containerd

cd $HOME
wget https://github.com/containerd/containerd/releases/download/v1.4.2/containerd-1.4.2-linux-amd64.tar.gz
cd /usr
sudo tar -xvf $HOME/containerd-1.4.2-linux-amd64.tar.gz
sudo rm -rf $HOME/containerd-1.4.2-linux-amd64.tar.gz

echo Setup: Replace Containerd

cd $HOME/go/src/k8s.io/arktos
wget -qO- https://github.com/CentaurusInfra/containerd/releases/download/tenant-cni-args/containerd.zip | zcat > /tmp/containerd
sudo chmod +x /tmp/containerd
sudo systemctl stop containerd
sudo mv /usr/bin/containerd /usr/bin/containerd.bak
sudo mv /tmp/containerd /usr/bin/
sudo systemctl restart containerd
sudo systemctl restart docker

####################

echo Setup: Setup profile

echo PATH=\"\$HOME/go/src/k8s.io/arktos/third_party/etcd:/usr/local/go/bin:\$HOME/go/bin:\$HOME/go/src/k8s.io/arktos/_output/bin:\$HOME/go/src/k8s.io/arktos/_output/dockerized/bin/linux/amd64:\$PATH\" >> ~/.profile
echo GOPATH=\"\$HOME/go\" >> ~/.profile
echo GOROOT=\"/usr/local/go\" >> ~/.profile
echo >> ~/.profile
echo alias arktos=\"cd \$HOME/go/src/k8s.io/arktos\" >> ~/.profile
echo alias k8s=\"cd \$HOME/go/src/k8s.io/kubernetes\" >> ~/.profile
echo alias up=\"\$HOME/go/src/k8s.io/arktos/hack/arktos-up.sh\" >> ~/.profile
echo alias status=\"git status\" >> ~/.profile
echo alias pods=\"kubectl get pods -A -o wide\" >> ~/.profile
echo alias nets=\"echo 'kubectl get subnets'\; kubectl get subnets\; echo\; echo 'kubectl get droplets'\; kubectl get droplets\; echo\; echo 'kubectl get bouncers'\; kubectl get bouncers\; echo\; echo 'kubectl get dividers'\; kubectl get dividers\; echo\; echo 'kubectl get vpcs'\; kubectl get vpcs\; echo\; echo 'kubectl get eps'\; kubectl get eps\; echo\; echo 'kubectl get networks'\; kubectl get networks\" >> ~/.profile
echo alias kubectl=\'$HOME/go/src/k8s.io/arktos/cluster/kubectl.sh\'  >> ~/.profile
echo alias kubeop=\"kubectl get pods \|\ grep mizar-operator \|\ awk \'{print \$1}\' \|\ xargs -i kubectl logs {}\"  >> ~/.profile
echo alias kubed=\"kubectl get pods \|\ grep mizar-daemon \|\ awk \'{print \$1}\' \|\ xargs -i kubectl logs {}\"  >> ~/.profile
echo export CONTAINER_RUNTIME_ENDPOINT=\"\containerRuntime,container,/run/containerd/containerd.sock\" >> ~/.profile
echo export KUBECTL_LOG=\"\/tmp/${USER}_kubetctl.err\" >> ~/.profile
echo export GPG_TTY=\$\(tty\) >> ~/.profile
echo cd \$HOME/go/src/k8s.io/arktos >> ~/.profile

source "$HOME/.profile"

####################

echo Setup: Basic

cd ~/go/src/k8s.io/arktos/
make all WHAT=cmd/arktos-network-controller

sudo systemctl stop ufw
sudo systemctl disable ufw
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo partprobe
sudo echo "vm.swappiness=0" | sudo tee --append /etc/sysctl.conf
sudo sysctl -p
IP_ADDR=$(hostname -I | awk '{print $1}')
HOSTNAME=$(hostname)
sudo sed -i '2s/.*/'$IP_ADDR' '$HOSTNAME'/' /etc/hosts
sudo sed -i '0,/RANDFILE/{s/RANDFILE/\#&/}' /etc/ssl/openssl.cnf
sudo rm -f /etc/resolv.conf
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

#####################

sudo apt autoremove -y

echo Setup: Machine setup completed!

sudo reboot
