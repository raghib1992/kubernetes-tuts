# Ref
https://kubernetes.io/docs/concepts/cluster-administration/addons/
## how-to-implement-the-kubernetes-networking-model
https://kubernetes.io/docs/concepts/cluster-administration/networking/
***********************
# Pod Networking

# CNI
## CNI configuration
kubelet.service
```
--network plugin= cni
--cni bin dir ==/ cni /bin
--cni conf dir etc cni net.d
```
### same view by running kubelet service
```
ps aux | grep kubelet
```
### weavework
```
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
#### by kubeadm
```
kubectl get pods –n kube-system
kubectl logs weave-net-5gcmb weave –n kube-system
```
*******************
# IP address management
## CNI had 2 plugins to manage ip list
### 1. DHCP
### 2. host-local
### cni conf file where we can specify the type of plugin
```
cat /etc/cni/net.d/net-script.conf
```
*******************
# Service Networking
## Proxy Mode
### 1. usersapce
### 2. iptables
### 3. ipvs
### set proxymode
```
kube-proxy --proxy-mode [userspace | iptables | ipvs]
```
### to view ip on pod 
```
kubectl get pods -o wide
```
### to view service
```
kubectl get svc
```
### ip range of the service set in kube-apiserver
```
kube-api-server --service-cluster-ip-range ipNet (Default: 10.0.0.0/24)
```
### view it by
```
ps aux | grep kube-api-server
```
```
iptables -L -t nat | grep <svc-name>
cat /var/log/kube-proxy.log
```
