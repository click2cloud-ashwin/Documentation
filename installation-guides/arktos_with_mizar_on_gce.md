# How to Setup a multi-node Arktos cluster and Mizar using custom image in GCE

Use cases for a Arktos multi-node dev cluster on GCE are to test features in cloud deployments. This document outlines the steps to deploy such a cluster on GCE

## Prerequisites

1. You will need an GCP account, and [gcloud](https://cloud.google.com/sdk/docs/install#deb) configured in your bash profile. Please refer to gcloud configuration documentation.
### Install gcloud
```bash
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get install apt-transport-https ca-certificates gnupg -y -q
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update -y && sudo apt-get install google-cloud-sdk -y
gcloud init # Provide credentials
```
2. You will need golang, docker, and build-essential installed.

### Install Docker 
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
```

### Install Golang
```bash
wget https://storage.googleapis.com/golang/go1.15.4.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.15.4.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
echo 'export GOPATH=$HOME/gopath' >> /etc/profile
source /etc/profile
```

### Create custom image

1. Create an instance using `ubuntu-2004-focal-v20210720` image
2. Change Network Interface and disable persistent naming on created instance using following process:

Run `ip a` and check interface name 

```text
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000 
      link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
      inet 127.0.0.1/8 scope host lo
      valid_lft forever preferred_lft forever
      inet6 ::1/128 scope host
      valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
      link/ether 00:50:56:86:f2:c1 brd ff:ff:ff:ff:ff:ff
      inet 192.168.1.113/24 brd 192.168.1.255 scope global eth0
      valid_lft forever preferred_lft forever
      inet6 fe80::250:56ff:fe86:f2c1/64 scope link
      valid_lft forever preferred_lft forever
```
Here network interface should be `eth0`, if it is `eth0` then skip following section and go to Step 2

If it is not `eth0` then to change interface to eth0 follow following steps
```bash
apt remove ifupdown
dmesg | grep -i eth #this will give information
```
Edit Grub file and change `GRUB_CMDLINE_LINUX` as shown below:

`sudo vi /etc/default/grub`

From `GRUB_CMDLINE_LINUX=""` change to `GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"`
After changing configuration, run following command

`sudo grub-mkconfig -o /boot/grub/grub.cfg`

Edit network manager yaml

```
vi /etc/netplan/01-network-manager-all.yaml 
#Please give proper file name present /etc/netplan location
```
It should have content like shown below or simply replace `ensXX` with `eth0`
```yaml
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eth0:
            dhcp4: true
            match:
                macaddress: 42:01:0a:0:0f:c1
            set-name: eth0
    version: 2
```
and then apply configuration before reboot your system

``
sudo netplan generate && netplan apply && sudo reboot
``

3. Then create an image using same instance from console, use that image 
## Arktos cluster start-up

1. Clone arktos repository
```bash
mkdir -p /root/go/src/k8s.io
cd /root/go/src/k8s.io
git clone -b  kube-up-mizar https://github.com/Click2Cloud-Centaurus/arktos.git

```
2. Build the Arktos release binaries from a bash terminal from your Arktos source root directory.
```bash
cd /root/go/src/k8s.io/arktos
make clean
make quick-release
```

3. Edit `cluster/gce/config-default.sh` and change following parameters
   
   * `KUBE_GCI_VERSION` : provide custom image name
   * `KUBE_GCE_MASTER_PROJECT`: provide project name
   * `KUBE_GCE_NODE_PROJECT`: provide project name
   * `KUBE_CONTAINER_RUNTIME`: change to `containerd`
   * `NETWORK_POLICY_PROVIDER`: `mizar` or `flannel`
   * In `INSTANCE_PREFIX`="${KUBE_GCE_INSTANCE_PREFIX:-kubernetes}" , please replace `kubernetes` with some other custom cluster name

4. To deploy the admin cluster in GCE, run kube-up script as follows:
```bash
./cluster/kube-up.sh
```
kube-up script displays the admin cluster details upon successful deployment.

## Using the admin cluster and kubemark cluster

1. To use admin cluster, just use kubectl. The build node is setup with the config to access the admin cluster. e.g:
```bash
./cluster/kubectl.sh get nodes -o wide
```

## Arktos cluster tear-down

1. To terminate admin cluster, run the following:
```bash
./cluster/kube-down.sh
```
