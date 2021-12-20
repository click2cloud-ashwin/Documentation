# Getting started

This document describes how to deploy centaurus dashboard using basic authentication.

1. Download the required YAML file.

```shell
wget https://raw.githubusercontent.com/Click2Cloud-Centaurus/Documentation/main/test-yamls/centaurus-dashboard.yaml
```

if required, update the container image `c2cengg20190034/dashboard:X.X.X`


2. Create the Centaurus Dashboard password file.

```shell
mkdir /etc/kubernetes/auth -p
vim /etc/kubernetes/auth/auth.csv
```

add following text which has password/token,username,userid, groups respectively.

```text
password,admin,admin,system:masters
```

3. Edit the Centaurus API configuration file, inside arktos directory.

```shell
vim ./hack/lib/common.sh
```

add following line inside `function kube::common::start_apiserver()` function.

```text
- --basic-auth-file=/etc/kubernetes/auth/auth.csv
```
#### before adding
```shell
 APISERVER_LOG=${LOG_DIR}/$apiserverlog
    ${CONTROLPLANE_SUDO} "${GO_OUT}/hyperkube" kube-apiserver "${authorizer_arg}" "${priv_arg}" ${runtime_config} \
      ${cloud_config_arg} \
      "${advertise_address}" \
      "${node_port_range}" \
      --v="${LOG_LEVEL}" \
      --vmodule="${LOG_SPEC}" \
      --audit-policy-file="${AUDIT_POLICY_FILE}" \
      --audit-log-path="${LOG_DIR}/$apiserverauditlog" \
      --cert-dir="${CERT_DIR}" \
      --client-ca-file="${CERT_DIR}/client-ca.crt" \
      --kubelet-client-certificate="${CERT_DIR}/client-kube-apiserver.crt" \
      --kubelet-client-key="${CERT_DIR}/client-kube-apiserver.key" \
      --service-account-key-file="${SERVICE_ACCOUNT_KEY}" \
      --service-account-lookup="${SERVICE_ACCOUNT_LOOKUP}" \
      --enable-admission-plugins="${ENABLE_ADMISSION_PLUGINS}" \
      --disable-admission-plugins="${DISABLE_ADMISSION_PLUGINS}" \
      --admission-control-config-file="${ADMISSION_CONTROL_CONFIG_FILE}" \
      --bind-address="${API_BIND_ADDR}" \
      --secure-port=$secureport \
      --tls-cert-file="${CERT_DIR}/serving-kube-apiserver.crt" \
      --tls-private-key-file="${CERT_DIR}/serving-kube-apiserver.key" \
      --insecure-bind-address="${API_HOST_IP}" \
      --insecure-port=$insecureport \
      --storage-backend="${STORAGE_BACKEND}" \
      --storage-media-type="${STORAGE_MEDIA_TYPE}" \
      --etcd-servers="http://${ETCD_HOST}:${ETCD_PORT}" \
      --service-cluster-ip-range="${SERVICE_CLUSTER_IP_RANGE}" \
      --feature-gates="${FEATURE_GATES}" \
      --external-hostname="${EXTERNAL_HOSTNAME}" \
      --requestheader-username-headers=X-Remote-User \
      --requestheader-group-headers=X-Remote-Group \
      --requestheader-extra-headers-prefix=X-Remote-Extra- \
      --requestheader-client-ca-file="${CERT_DIR}/request-header-ca.crt" \
      --requestheader-allowed-names=system:auth-proxy \
      --proxy-client-cert-file="${CERT_DIR}/client-auth-proxy.crt" \
      --proxy-client-key-file="${CERT_DIR}/client-auth-proxy.key" \
      ${service_group_id} \
      --partition-config="${configfilepath}" \
      --profiling=true \
      --contention-profiling=true \
```
#### after adding
```shell
 APISERVER_LOG=${LOG_DIR}/$apiserverlog
    ${CONTROLPLANE_SUDO} "${GO_OUT}/hyperkube" kube-apiserver "${authorizer_arg}" "${priv_arg}" ${runtime_config} \
      ${cloud_config_arg} \
      "${advertise_address}" \
      "${node_port_range}" \
      --v="${LOG_LEVEL}" \
      --vmodule="${LOG_SPEC}" \
      --audit-policy-file="${AUDIT_POLICY_FILE}" \
      --audit-log-path="${LOG_DIR}/$apiserverauditlog" \
      --basic-auth-file="/etc/kubernetes/auth/auth.csv" \
      --cert-dir="${CERT_DIR}" \
      --client-ca-file="${CERT_DIR}/client-ca.crt" \
      --kubelet-client-certificate="${CERT_DIR}/client-kube-apiserver.crt" \
      --kubelet-client-key="${CERT_DIR}/client-kube-apiserver.key" \
      --service-account-key-file="${SERVICE_ACCOUNT_KEY}" \
      --service-account-lookup="${SERVICE_ACCOUNT_LOOKUP}" \
      --enable-admission-plugins="${ENABLE_ADMISSION_PLUGINS}" \
      --disable-admission-plugins="${DISABLE_ADMISSION_PLUGINS}" \
      --admission-control-config-file="${ADMISSION_CONTROL_CONFIG_FILE}" \
      --bind-address="${API_BIND_ADDR}" \
      --secure-port=$secureport \
      --tls-cert-file="${CERT_DIR}/serving-kube-apiserver.crt" \
      --tls-private-key-file="${CERT_DIR}/serving-kube-apiserver.key" \
      --insecure-bind-address="${API_HOST_IP}" \
      --insecure-port=$insecureport \
      --storage-backend="${STORAGE_BACKEND}" \
      --storage-media-type="${STORAGE_MEDIA_TYPE}" \
      --etcd-servers="http://${ETCD_HOST}:${ETCD_PORT}" \
      --service-cluster-ip-range="${SERVICE_CLUSTER_IP_RANGE}" \
      --feature-gates="${FEATURE_GATES}" \
      --external-hostname="${EXTERNAL_HOSTNAME}" \
      --requestheader-username-headers=X-Remote-User \
      --requestheader-group-headers=X-Remote-Group \
      --requestheader-extra-headers-prefix=X-Remote-Extra- \
      --requestheader-client-ca-file="${CERT_DIR}/request-header-ca.crt" \
      --requestheader-allowed-names=system:auth-proxy \
      --proxy-client-cert-file="${CERT_DIR}/client-auth-proxy.crt" \
      --proxy-client-key-file="${CERT_DIR}/client-auth-proxy.key" \
      ${service_group_id} \
      --partition-config="${configfilepath}" \
      --profiling=true \
      --contention-profiling=true \
```
4. Clean up the existing binaries (Stop the cluster, if it is running).

```shell
make clean
```

5. Start the arktos-cluster.

```shell
./hack/arktos-up.sh
```

#### Output:
```text
clusterrolebinding.rbac.authorization.k8s.io/system:kubelet-network-reader created

Arktos Setup done.
*******************************************
Setup Kata Containers components ...
* Install Kata components
snap "kata-containers" is already installed, see 'snap help refresh'
* Checking Kata compatibility
time="2021-12-20T14:35:00+05:30" level=warning msg="Not running network checks as super user" arch=amd64 name=kata-runtime pid=9384 source=runtime time="2021-12-20T14:35:00+05:30" level=error msg="CPU property not found" arch=amd64 description="Virtualization support" name=vmx pid=9384 source=runtime type=flag time="2021-12-20T14:35:00+05:30" level=warning msg="modprobe insert module failed" arch=amd64 error="exit status 1" module=kvm_intel name=kata-runtime output="modprobe: ERROR: could not insert 'kvm_intel': Operation not supported\n" pid=9384 source=runtime time="2021-12-20T14:35:00+05:30" level=error msg="kernel property kvm_intel not found" arch=amd64 description="Intel KVM" name=kvm_intel pid=9384 source=runtime type=module time="2021-12-20T14:35:00+05:30" level=error msg="ERROR: System is not capable of running Kata Containers" arch=amd64 name=kata-runtime pid=9384 source=runtime ERROR: System is not capable of running Kata Containers
Aborted. Current system does not support Kata Containers.
Kata Setup done.
*******************************************
Local Kubernetes cluster is running. Press Ctrl-C to shut it down.

Logs:
  /tmp/kube-apiserver0.log
  /tmp/kube-controller-manager.log


  /tmp/kube-proxy.log
  /tmp/kube-scheduler.log
  /tmp/kubelet.log

To start using your cluster, you can open up another terminal/tab and run:

  export KUBECONFIG=/var/run/kubernetes/admin.kubeconfig
Or
  export KUBECONFIG=/var/run/kubernetes/adminN(N=0,1,...).kubeconfig

  cluster/kubectl.sh

Alternatively, you can write to the default kubeconfig:

  export KUBERNETES_PROVIDER=local

  cluster/kubectl.sh config set-cluster local --server=https://centaurus-master:6443 --certificate-authority=/var/run/kubernetes/server-ca.crt
  cluster/kubectl.sh config set-credentials myself --client-key=/var/run/kubernetes/client-admin.key --client-certificate=/var/run/kubernetes/client-admin.crt
  cluster/kubectl.sh config set-context local --cluster=local --user=myself
  cluster/kubectl.sh config use-context local
  cluster/kubectl.sh

```

6. Make sure your arktos cluster is running

```shell
./cluster/kubectl.sh get nodes -A
```

output of above command

```text
NAME               STATUS   ROLES    AGE   VERSION
centaurus-master   Ready    <none>   30m   v0.9.0
```

7. Generate certs and keys required for dashboard.

```shell
sudo sed -i '0,/RANDFILE/{s/RANDFILE/\#&/}' /etc/ssl/openssl.cnf
openssl genrsa -out dashboard.key 2048 
openssl rsa -in dashboard.key -out dashboard.key 
openssl req -sha256 -new -key dashboard.key -out dashboard.csr -subj "/CN=$(hostname -I | awk '{print $1}')"
openssl x509 -req -sha256 -days 365 -in dashboard.csr -signkey dashboard.key -out dashboard.crt 
```

#### Output:

```text
Generating RSA private key, 2048 bit long modulus (2 primes)
..................+++++
...................+++++
e is 65537 (0x010001)
root@centaurus-master:~/test# openssl rsa -in dashboard.key -out dashboard.key
writing RSA key
root@centaurus-master:~/test# openssl req -sha256 -new -key dashboard.key -out dashboard.csr -subj "/CN=$(hostname -I | awk '{print $1}')"
root@centaurus-master:~/test# openssl x509 -req -sha256 -days 365 -in dashboard.csr -signkey dashboard.key -out dashboard.crt
Signature ok
subject=CN = 192.168.1.233
Getting Private key
```

8. Deploy the dashboard
```shell
./cluster/kubectl.sh create namespace kubernetes-dashboard 
./cluster/kubectl.sh create secret generic kubernetes-dashboard-certs --from-file=$HOME/dashboard.key --from-file=$HOME/dashboard.crt -n kubernetes-dashboard
./cluster/kubectl.sh create -f kubernetes-dashboard.yaml
```

#### Output:

```text
namespace/kubernetes-dashboard created
secret/kubernetes-dashboard-certs created
serviceaccount/kubernetes-dashboard created
service/kubernetes-dashboard created
secret/kubernetes-dashboard-csrf created
secret/kubernetes-dashboard-key-holder created
configmap/kubernetes-dashboard-settings created
role.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
deployment.apps/kubernetes-dashboard created
service/dashboard-metrics-scraper created
deployment.apps/dashboard-metrics-scraper created
```
9. The Dashboard will be accessible at `https://<host_machine_ip>:30001` and you can log in using `username` & `password` used in `auth.csv`
