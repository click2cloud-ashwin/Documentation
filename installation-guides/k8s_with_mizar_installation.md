 Introduction
================
This document intended to capture the installation steps for the single node and multi-node kubernetes platform with Mizar as the underlying network service.


## Setup Single-Node Kubernetes with Mizar


### 1. Check Network Interface
verify your interface name and IP by running:
```bash
ip a
```
##### Output:
```text
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens160: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 00:50:56:86:f2:c1 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.105/24 brd 192.168.1.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::250:56ff:fe86:f2c1/64 scope link
       valid_lft forever preferred_lft forever
```
Currently, for mizar CNI to work properly, here network interface should be `eth0`, if it is `eth0` then skip following section and goto **step 2**

If it is not `eth0` then to change interface to `eth0`, follow the following steps:

```bash
wget https://raw.githubusercontent.com/Click2Cloud-Centaurus/Documentation/main/deployment_scripts/enable_persistent_naming.sh
sudo bash enable_persistent_naming.sh
```

### 2. Update kernel
To check kernel, run following command

`uname -a`

If kernel version below `5.6.0-rc2`, to update kernel perform the following steps: 

```bash
wget https://raw.githubusercontent.com/CentaurusInfra/mizar/dev-next/kernelupdate.sh
sudo bash kernelupdate.sh
```
Please reboot your system after kernel update.

### 3. Install Kubernetes

verify your interface name and IP by running:
```bash
ip a
```
Currently, for mizar CNI to work properly, it should contain interface name as ```eth0``` and valid IP address
. If not, then perform **step 1**.
```text
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:50:56:af:b5:41 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.105/24 brd 192.168.1.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::250:56ff:feaf:b541/64 scope link
```

**A.** Install dependencies and setup kubernetes

```bash
sudo apt-get install -y ca-certificates curl apt-transport-https gnupg lsb-release vim
```
```bash
wget https://raw.githubusercontent.com/Click2Cloud-Centaurus/Documentation/main/deployment_scripts/k8s-setup.sh
sudo bash k8s-setup.sh
```

#### Selecting runtime ( docker / containerd )

#### i. docker

Configure the Docker daemon, in particular to use systemd for the management of the container’s cgroups.

```bash
sudo mkdir /etc/docker

cat <<EOF | sudo tee /etc/docker/daemon.json
{
"exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts": {
"max-size": "100m"
},
"storage-driver": "overlay2"
}
EOF
````
Restart Docker and enable on boot:

```bash
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
```

#### ii. containerd

Configure prerequisites:

```bash
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
```

```bash
sudo modprobe overlay
sudo modprobe br_netfilter
```
Setup required sysctl params, these persist across reboots.
```bash
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```
#### Apply sysctl params without reboot
```bash
sudo sysctl --system
```
Configure containerd:

```bash
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
```
Restart containerd:

```bash
sudo systemctl restart containerd
```
Using the systemd cgroup driver
To use the systemd cgroup driver in /etc/containerd/config.toml with runc, set

```text
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
...
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
```
If you apply this change make sure to restart containerd again:

```bash
sudo systemctl restart containerd
```

**B.** Run kubernetes cluster
```bash
sudo kubeadm init --apiserver-advertise-address=$(hostname -I | awk '{print $1}') --pod-network-cidr=20.0.0.0/8
```

kubeadm init first runs a series of prechecks to ensure that the machine is ready to run Kubernetes. These prechecks expose warnings and exit on errors. kubeadm init then downloads and installs the cluster control plane components. This may take several minutes. After it finishes you should see:

#### Output:
```text
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a Pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  /docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

To make kubectl work for your non-root user, run these commands, which are also part of the kubeadm init output:
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
Alternatively, if you are the root user, you can run:
```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
```
### 4. Deploy Mizar

```bash
kubectl apply -f https://raw.githubusercontent.com/Click2Cloud-Centaurus/mizar/grpcio-fix/etc/deploy/deploy.mizar.yaml
```

#### Note: On single node, to schedule pod you need to run the following command to remove taint.

```bash
kubectl taint nodes $(hostname) node-role.kubernetes.io/master:NoSchedule-
```
##### Output:
```text
node/master untainted
```
Now you your single node kubernetes cluster should ready to use.

**Note:** If you don't want to set up multi-node cluster, then you can jump to testing steps below:

# Setup Multi-Node Kubernetes with Mizar

## Installation Steps
1. Before begin, **please complete step 1,2 ( if applicable ) and 3.A** from the **on all the nodes** ( master and worker ) before proceeding.
   
**Note: Make sure that your ```/etc/hosts``` file contains master node and worker nodes entries.**

2. From the **master node** machine, start kubernetes cluster if you haven't already: 
```bash
sudo kubeadm init --apiserver-advertise-address=$(hostname -I | awk '{print $1}') --pod-network-cidr=20.0.0.0/8
```
#### Output:
```text
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a Pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  /docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

To make kubectl work for your non-root user, run these commands, which are also part of the kubeadm init output:
```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
Alternatively, if you are the root user, you can run:
```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
```

3. Joining your nodes
The nodes are where your workloads (containers and Pods, etc.) run. 

To add new nodes to your cluster do the following for each machine:

Run the command that was **output by kubeadm init on master node**. 
For example:

```bash
sudo kubeadm join <control-plane-host>:<control-plane-port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```


## Testing Steps

#### To check status of node

```bash
kubectl get nodes
```
##### Output: 
**Note:** It may differ depending upon size of cluster.
````text
NAME            STATUS   ROLES                  AGE    VERSION
dnd-centaurus   Ready    control-plane,master   149m   v1.21.2
````
#### To check pods

```bash
kubectl get pods -Ao wide
```
##### Output:
**Note:** It may differ depending upon size of cluster.
```text
default       mizar-daemon-fjnqn                      1/1     Running   0          152m   192.168.0.105   dnd-centaurus   <none>           <none>
default       mizar-operator-79d4846f95-xnqlv         1/1     Running   0          152m   192.168.0.105   dnd-centaurus   <none>           <none>
kube-system   coredns-558bd4d5db-rv8c8                0/1     Running   36         153m   20.0.0.30       dnd-centaurus   <none>           <none>
kube-system   coredns-558bd4d5db-zbzcf                0/1     Running   36         153m   20.0.0.46       dnd-centaurus   <none>           <none>
kube-system   etcd-dnd-centaurus                      1/1     Running   0          153m   192.168.0.105   dnd-centaurus   <none>           <none>
kube-system   kube-apiserver-dnd-centaurus            1/1     Running   0          153m   192.168.0.105   dnd-centaurus   <none>           <none>
kube-system   kube-controller-manager-dnd-centaurus   1/1     Running   0          153m   192.168.0.105   dnd-centaurus   <none>           <none>
kube-system   kube-proxy-jcqfs                        1/1     Running   0          153m   192.168.0.105   dnd-centaurus   <none>           <none>
kube-system   kube-scheduler-dnd-centaurus 
```

#### To check vpcs

```bash
kubectl get vpcs -A
```
##### Output:
```text
NAME   IP         PREFIX   VNI   DIVIDERS   STATUS        CREATETIME                   PROVISIONDELAY
vpc0   20.0.0.0   8        1     1          Provisioned   2021-06-21T06:51:10.241690   41.406581
```
#### To check subnets

```bash
kubectl get subnets -A
```
##### Output:
```text
NAME   IP         PREFIX   VNI   VPC    STATUS        BOUNCERS   CREATETIME                   PROVISIONDELAY
net0   20.0.0.0   8        1     vpc0   Provisioned   1          2021-06-21T06:51:10.307781   61.483709
```
#### To check droplets

```bash
kubectl get droplets -A
```
##### Output:
```text
NAME            MAC                 IP              STATUS        INTERFACE   CREATETIME                   PROVISIONDELAY
dnd-centaurus   fa:16:3e:56:f4:21   192.168.0.105   Provisioned   eth0        2021-06-21T06:51:51.056378   0.355918
```
#### To check dividers

```bash
kubectl get dividers -A
```
##### Output:
```text
NAME                                          VPC    IP              MAC                 DROPLET         STATUS        CREATETIME                   PROVISIONDELAY
vpc0-d-ef998d38-ccb2-42d8-8de7-16e0a893c985   vpc0   192.168.0.105   fa:16:3e:56:f4:21   dnd-centaurus   Provisioned   2021-06-21T06:51:51.636539   0.240687
```
#### To check bouncers

```bash
kubectl get bouncers -A
```
##### Output:
```text
NAME                                          VPC    NET    IP              MAC                 DROPLET         STATUS        CREATETIME                   PROVISIONDELAY
net0-b-ff73d09e-6f84-4792-b1a0-fc99cfc57cd5   vpc0   net0   192.168.0.105   fa:16:3e:56:f4:21   dnd-centaurus   Provisioned   2021-06-21T06:52:11.782960   1.41518
```
