# ETCD

## Install ETCD
### Download Binaries
Ref: curl -L https://github.com/etcd io/etcd/releases/download/v3.3.11/etcd-v3.3.11 linux amd64.tar.gz o etcd v3.3.11 linux amd64.tar.gz
### Extract
Ref: tar xzvf etcd v3.3.11 linux amd64.tar.gz
### Run ETCD Service
./ etcd

## By default listen on port 2379
## By default client come with ETCD is ETCD control client
### To store Key value pair
./etcdctl set key1 value1
### TO retrieve the data
./etcdctl get key1
### To more more command
./etcdctl  ### without any arguments

## Setup ETCD from scratch
### Downaload binaries
```
wget -q --https-only \
"https://github.com/coreos/etcd/releases/download/v3.3.9/etcd-v3.3.9-linux-amd64.tar.gz"
tar -xvf etcd-v3.3.9-linux-amd64.tar.gz
mv etcd-v3.3.9-linux-amd64/etcd* /usr/local/bin/
mkdir -p /etc/etcd /var/lib/etcd
cp ca.pem kubernetes-key.pem kubernetes.pem /etc/etcd/
```
### info in etcd.service about its peer
```
--
initial cluster controller 0=https://${CONTROLLER0_IP}:2380,controller 1=https://${CONTROLLER1_IP}:2380
```
### ETCDCTL
```
export ETCDCTL_API=3
etcdctl put name john
etcdctl get name
etcdctl get / --prefix --keys-only
```

## Kubeadm deploy ETCD server as a POD in Kubesystem namespace
```
kubectl get pods -n kube-system
kubectl exec etcd-master -n kube-system etcdctl get / --prefix -keys-only  ## to list all keys
```

## In HA, there will be more than one ETCD server
## All must about each other by setting parameter
```
--initial-cluster controller-0=https://${CONTROLLER0_IP}:2380,controller-1=https://${CONTROLLER1_IP}:2380 \\
```

# ETCDCTL is the CLI tool used to interact with ETCD.

## ETCDCTL can interact with ETCD Server using 2 API versions - Version 2 and Version 3.  By default its set to use Version 2. Each version has different sets of commands
## For example ETCDCTL version 2 supports the following commands:
```
etcdctl backup
etcdctl cluster-health
etcdctl mk
etcdctl mkdir
etcdctl set
```
## Whereas the commands are different in version 3
```
etcdctl snapshot save 
etcdctl endpoint health
etcdctl get
etcdctl put
```

## To set the right version of API set the environment variable ETCDCTL_API command
```
export ETCDCTL_API=3
```
### When API version is not set, it is assumed to be set to version 2. And version 3 commands listed above don't work. When API version is set to version 3, version 2 commands listed above don't work
### Apart from that, you must also specify path to certificate files so that ETCDCTL can authenticate to the ETCD API Server. The certificate files are available in the etcd-master at the following path. We discuss more about certificates in the security section of this course. So don't worry if this looks complex:
```
--cacert /etc/kubernetes/pki/etcd/ca.crt     
--cert /etc/kubernetes/pki/etcd/server.crt     
--key /etc/kubernetes/pki/etcd/server.key
```
### So for the commands I showed in the previous video to work you must specify the ETCDCTL API version and path to certificate files. Below is the final form:
```
kubectl exec etcd-master -n kube-system -- sh -c "ETCDCTL_API=3 etcdctl get / --prefix --keys-only --limit=10 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt  --key /etc/kubernetes/pki/etcd/server.key" 
```
********************************