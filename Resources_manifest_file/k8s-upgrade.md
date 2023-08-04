# upgrade
## kubeadm
```
kubectl upgrade plan
kubectl upgrade apply
```
## Steps
### 1. upgrade master node
### 2. upgrade worker node
### commands master
```
apt-get upgrade -y kubeadm=1.12.0-00
kubectl upgrade plan
kubectl upgrade apply v1.12.0
kubectl get nodes
apt-get upgrade kubelet=1.12.0-00
systemctl restart kubelet
kubectl get nodes
```
### command worker
```
kubectl drian node01
apt-get upgrade -y kubeadm=1.12.0-00
apt-get upgrade kubelet=1.12.0-00
kubeadm upgrade node config --kubelet-version v1.12.0
systemctl restart kubelet
kubectl uncordon node01
```

## Practical
Ref:
```
https://v1-21.docs.kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/
```
### Upgrade Master Node
```
kubeadm token list
```
#### to name all the pods including kube-system namespace
```
kubectl get pods -A
```
#### to get the current verion of the kubelet
```
kubectl get nodes
```
#### To identify the OS of the node
```
cat /etc/*release*
```
#### Determine which version to upgrade to
```
apt update
apt-cache madison kubeadm
```
#### Upgrading control plane nodes (replace x with the latest patch version)
```
apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.19.x-00 && \
apt-mark hold kubeadm
```
#### check kubeadm version
```
kubeadm version
```
#### to check the upgrade plan the current version the upgrade version
```
sudo kubeadm upgrade plan
```
#### upgrade apply (replace x with the patch version you picked for this upgrade)
```
sudo kubeadm upgrade apply v1.19.x
```
#### To verify 
```
sudo kubeadm upgrade plan
```
#### to upgrade kubelet
```
kubectl drain <cp-node-name> --ignore-daemonsets
```
##### upgrade (replace x in 1.19.x-00 with the latest patch version)
```
apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet=1.19.x-00 kubectl=1.19.x-00 && \
apt-mark hold kubelet kubectl
```
##### Restart the kubelet
```
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```
##### Uncordon the control plane node
```
kubectl uncordon <cp-node-name>
```


### Upgrade Worker Node
#### Upgrade kubeadm on all worker nodes (replace x in 1.19.x-00 with the latest patch version)
```
apt-mark unhold kubeadm && \
apt-get update && apt-get install -y kubeadm=1.19.x-00 && \
apt-mark hold kubeadm
```
#### Upgrade the kubelet configuration
```
sudo kubeadm upgrade node
```
#### Drain the node (run on control plane node/master)
```
kubectl drain <node-to-drain> --ignore-daemonsets
```
#### Upgrade kubelet and kubectl
```
apt-mark unhold kubelet kubectl && \
apt-get update && apt-get install -y kubelet=1.19.x-00 kubectl=1.19.x-00 && \
apt-mark hold kubelet kubectl
```
#### Restart the kubelet
```
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```
#### Uncordon the node (run on controlplane/master)
```
kubectl uncordon <node-to-drain>
```
#### Verify the status of the cluster 
```
kubectl get nodes
```