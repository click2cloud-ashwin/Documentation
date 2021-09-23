# Arktos and Mizar Single Node Installation Guide

## Introduction

This document is intended for new users to install Arktos platform with Mizar as the underlying network technology.

For more details on Arktos installation, please refer to [this link](https://github.com/centaurus-cloud/arktos/blob/master/docs/setup-guide/arktos-enforces-network-feature.md)

### Prepare lab machine 

The preferred OS is **Ubuntu 18.04**.

If you are using AWS, the recommended instance size is ```t2.2xlarge``` and the storage size is ```128GB``` or more.

If you are using On-Premise, the recommended instance size is ```8 CPU```, ```16GB RAM``` and the storage size is ```150GB``` or more.

## Prerequisites
### Step 1: Install Dependencies
```bash
sudo apt-get install -y ca-certificates curl wget apt-transport-https gnupg lsb-release vim
```
### Step 2: Check Network Interface
```bash
ip a
```

```text
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:50:56:af:b5:41 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.222/24 brd 192.168.1.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::250:56ff:feaf:b541/64 scope link
```
Here network interface should be `eth0`, if it is `eth0` then skip following section and go to step 3

If it is not `eth0` then to change interface to eth0 follow following steps:

Edit Grub file and change `GRUB_CMDLINE_LINUX` as shown below:

```bash
sudo vim /etc/default/grub
```

Change line `GRUB_CMDLINE_LINUX=""` to `GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"`

After changing configuration, run following command

```bash
sudo update-grub
```

Edit network manager yaml

```
# Edit or Create if not exists
# Please give proper file name present /etc/netplan location
sudo vim /etc/netplan/00-installer-config.yaml 
```
It should have content like shown below
```text
network:
  version: 2
  ethernets:
          enXXXX:
            addresses: [private-ip-address/prefix]
            gateway4: default-gateway-ip
            nameservers:
              addresses: [dns-ip]
```

Change the interface name ```enXXXX``` to ```eth0```.

```text
network:
  version: 2
  ethernets:
          eth0:
            addresses: [private-ip-address/prefix]
            gateway4: default-gateway-ip
            nameservers:
              addresses: [dns-ip]
```

and then apply configuration and reboot your system

```bash
sudo netplan apply && sudo reboot
```

verify your interface name and IP by running:
```bash
ip a
```
it should contain interface name as ```eth0``` and valid IP address
```text
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:50:56:af:b5:41 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.222/24 brd 192.168.1.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::250:56ff:feaf:b541/64 scope link
```

### Step 3: Update kernel and install mizar dependencies
To check kernel, run following command

```bash
uname -a
```

To install mizar dependencies and update Kernel download and run:
If it is `5.6.0-rc2` then you can skip downloading ```kernelupdate.sh```
```bash
wget https://raw.githubusercontent.com/CentaurusInfra/mizar/dev-next/kernelupdate.sh
```
```bash
wget https://raw.githubusercontent.com/CentaurusInfra/mizar/dev-next/bootstrap.sh
sudo bash bootstrap.sh
```

### Step 4: Arktos and Mizar Deployment
1. Install the arktos and dependencies

```bash
wget https://raw.githubusercontent.com/Click2Cloud-Centaurus/Documentation/main/deployment_scripts/arktos-setup.sh
sudo bash arktos-setup.sh
```
The lab machine will be rebooted once above script is completed, you will be automatically logged out of the lab machine.

Also, please ensure the hostname and its ip address in /etc/hosts. For instance, if the hostname is centaurus-master, ip address is 192.168.1.222:
```text
127.0.0.1 localhost
192.168.1.222 centaurus-master
```

To make sure containerd is running as expected, run:

```bash
sudo systemctl status containerd.service
```
2. Enable network related feature and the default network to be of "mizar" type

**Note:** Required for mizar CNI only
```bash
export FEATURE_GATES="AllAlpha=false,MandatoryArktosNetwork=true"
export ARKTOS_NETWORK_TEMPLATE=mizar
```
3. Before deploying Mizar, you will need first start up Arktos API server:

```bash
cd $HOME/go/src/k8s.io/arktos
./hack/arktos-up.sh
```

If you see this warning ```Waiting for node ready at api server``` for more than 10 times, then run:

```bash
sudo systemctl restart containerd.service
```

Then wait till you see:

```text
To start using your cluster, you can open up another terminal/tab and run:

  export KUBECONFIG=/var/run/kubernetes/admin.kubeconfig
Or
  export KUBECONFIG=/var/run/kubernetes/adminN(N=0,1,...).kubeconfig

  cluster/kubectl.sh

Alternatively, you can write to the default kubeconfig:

  export KUBERNETES_PROVIDER=local

  cluster/kubectl.sh config set-cluster local --server=https://ip-172-31-16-157:6443 --certificate-authority=/var/run/kubernetes/server-ca.crt
  cluster/kubectl.sh config set-credentials myself --client-key=/var/run/kubernetes/client-admin.key --client-certificate=/var/run/kubernetes/client-admin.crt
  cluster/kubectl.sh config set-context local --cluster=local --user=myself
  cluster/kubectl.sh config use-context local
  cluster/kubectl.sh
```

4. Start Arktos network controller. From a new terminal window, run:
```bash
cd $HOME/go/src/k8s.io/arktos
./_output/local/bin/linux/amd64/arktos-network-controller --kubeconfig=/var/run/kubernetes/admin.kubeconfig --kube-apiserver-ip=xxx.xxx.xxx.xxx
```
where the ```kube-apiserver-ip``` is your lab machine's private ip address

The config file has below content

```yaml
apiVersion: v1
clusters:
- cluster:
  server: http://127.0.0.1:8080
  name: local
  contexts:
- context:
  cluster: local
  user: ""
  name: local-ctx
  current-context: local-ctx
  kind: Config
  preferences: {}
  users: []
```
Leave the arktos-network-controller termainal running and open a new terminal to install CNI plugin;

Now, the default network of system tenant should be Ready.
```bash
./cluster/kubectl.sh get net
```
Then you will you see:
```text
NAME      TYPE   VPC                         PHASE   DNS
default   mizar  system-default-network      Ready   10.0.0.207
```

You also want make sure the default kubernetes bridge network configuration file is deleted:

5. To deploy Mizar, run:

```bash
sudo ls /etc/cni/net.d
sudo rm /etc/cni/net.d/bridge.conf # if bridge.conf is present else skip this command
kubectl apply -f https://raw.githubusercontent.com/CentaurusInfra/mizar/dev-next/etc/deploy/deploy.mizar.yaml
```

6. Verify Mizar pods i.e. mizar-operator and mizar-daemon pods are in running state, for that run:

```bash
kubectl get pods
```
You should see the following output
```text
NAME                              HASHKEY               READY   STATUS    RESTARTS   AGE
mizar-daemon-qvf8h                3609709351651248785   1/1     Running   0          30s
mizar-operator-67df55cbd4-fbbtz   2504797451733876877   1/1     Running   0          30s
```
