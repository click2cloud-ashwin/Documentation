# Arktos and Mizar Multi Node Installation Guide

## Introduction
This document is intended to capture the installation steps for multi node Arktos platform with Mizar as the underlying network service.

## Installation Steps
1. Before begin, please complete [Single Node Installation Guide](arktos_single_node_installation.md) before proceed this installation guide

For more details on Arktos installation, please refer to [Arktos Setup Guide](https://github.com/CentaurusInfra/arktos/blob/master/docs/setup-guide/multi-node-dev-cluster.md)

If this machine will be used as the master of a multi-node cluster, please set adequate permissive security groups. 

For AWS VM in this lab, we allowed inbound rule of ALL-Traffic 0.0.0.0/0.

**Note: Make sure that your ```/etc/hosts``` file contains master node and worker nodes entries.**

2. From the **master node** machine, start Arktos server if haven't already:

```bash
cd $HOME/go/src/k8s.io/arktos
./hack/arktos-up.sh
```

In a new terminal window, start Mizar if haven't already:
```bash
sudo ls /etc/cni/net.d
sudo rm /etc/cni/net.d/bridge.conf
kubectl deploy -f https://raw.githubusercontent.com/CentaurusInfra/mizar/dev-next/etc/deploy/deploy.mizar.yaml
```

3. Prepare worker node lab machine: Open a new terminal window, ssh into your **worker node** lab machine. To add worker nodes, please ensure following worker secret files copied from the master node. From worker node lab machine, run:
```bash
mkdir -p /tmp/arktos
scp <master-node-instance>:/var/run/kubernetes/kubelet.kubeconfig /tmp/arktos/
scp <master-node-instance>:/var/run/kubernetes/client-ca.crt /tmp/arktos/
```
NOTE: you need to re-run the above command once you restart the machine.

Then at worker node, run following commands:
```bash
export KUBELET_IP=<worker-ip>
./hack/arktos-worker-up.sh
```
where, the <worker-ip> is your lab machine's private ip address.

After the script returns, go to master node terminal and run command "[arktos_repo]/cluster/kubectl.sh get nodes", you should see the work node is displayed and its status should be "Ready".