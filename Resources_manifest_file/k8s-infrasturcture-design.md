## Purpose

### • Education
#### 1. minikube
#### 2. Single node cluster with kubeadm/aws/gcp

### • Development & Testing
#### 1. Multinode cluster with single master and multi worker nodes
#### 2. setup using kubeadm tool or quick provision on GCP/aws/AKS

### • Hosting Production Applications
#### 1. HA multinode cluster with with multimaster node
#### 2. Kubeadm or GCP or Kops on AWS or other supported platforms
#### 3. Upto 5000 nodes
#### 4. Upto 150,000 PODs in the cluster
#### 5. Upto 300,000 Total Containers
#### 6. Upto 100 PODs per Node

## Cloud or OnPrem?
#### 1. Use Kubeadm for on prem
#### 2. GKE for GCP
#### 3. Kops for AWS
#### 5. EKS for AWS
#### 4. Azure Kubernetes Service(AKS) for Azure

## Separate ETCD cluster from master node
### cat /etc/systemd/system/kube-apiserver.service
```
--etcd-servers=https://10.240.0.10:2379,https://10.240.0.11:2379
```
## HA
```
kube-controller-manager --leader-elect true [other options]
--leader-elect-lease-duration 15s
--leader-elect-renew-deadline 10s
--leader-elect-retry-period 2s
```

## Tool for self managed k8s cluster
#### Openshift
#### Cloud Foundry container runtime
#### VMware cloud PKS
#### Vagrant