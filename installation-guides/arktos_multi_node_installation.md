# Arktos and Mizar Multi-Node Installation Guide

## Introduction
This document intended to capture the installation steps for the multi-node Arktos platform with Mizar as the underlying network service.

## Installation Steps
1. Before begin, **please complete step 1,2,3 ( if applicable ) and 4.1** from the [Single Node Installation Guide](arktos_single_node_installation.md) **on all the nodes** ( master and worker ) before proceeding this installation guide

For more details on Arktos installation, please refer to [Arktos Multi-Node Cluster Guide](https://github.com/CentaurusInfra/arktos/blob/master/docs/setup-guide/multi-node-dev-cluster.md)

If this machine will be used as the master of a multi-node cluster, please set adequate permissive security groups.

For AWS VM in this lab, we allowed the inbound rule of ALL-Traffic 0.0.0.0/0.

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
kubectl apply -f https://raw.githubusercontent.com/CentaurusInfra/mizar/dev-next/etc/deploy/deploy.mizar.yaml
```

3. Prepare **worker node** lab machine:

Open a new terminal window, ssh into your **worker node** lab machine. To add worker nodes, please ensure the following worker secret files are copied from the master node.

From worker node lab machine, run:
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
where the <worker-ip> is your lab machine's private IP address.

After the script returns, go to the master node terminal and run the command "<arktos_repo>/cluster/kubectl.sh get nodes", you should see the work node is displayed and its status should be "Ready".
