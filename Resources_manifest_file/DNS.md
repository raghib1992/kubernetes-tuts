# CoreDNS
## Delay as POD in kube-system ns (2 pods for redundancy)
```
./coredns
```
## COreDNS require conf file,
### cat /etc/coredns/Corefile
```
.:53 {
    errors
    health
    kubernetes cluster.local in-addr.arpa ip6.arpa {
        pods insure
        upstream
        fallthrough in.addr.arpa ip6.arpa
    }
    prometheus :9153
    proxy . /etc/resolv.conf
    cache 30
    reload
}
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