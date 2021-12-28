# CoreDNS
## Delay as POD in kube-system ns (2 pods for redundancy)
```
./coredns
```
## conf file
```
cat /etc/coredns/Corefile
```
## this corefile also pass to configmap object
```
kubectl get configmap -n kube-system
```
## setting in pods to reach dns (to get ip od dns service)
```
kubectl get svc -n kube-system
cat /var/lib/kubelet/config.yaml
```
### enter the ip of the dns svc to 
```
cat /etc/resolv.conf
```
### to get fully qualified domain name
```
host <pod service name>
```