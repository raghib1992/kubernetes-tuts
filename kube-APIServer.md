# Kube-apiserver is a primary management compoenet in k8s
## If you install k8s by kube-adm tool, kube-apiserver install as a pod into kube-system namespace
```
kubectl get pods -n kube-system
```

## pod definition file located at
```
cat /etc/kubernetes/manifests/kube-apiserver.yaml
```

## In  non-kubeadm setup, we can view the apiserver service
```
cat /etc/systemd/system/kube-apiserver.service
```

## Running process
```
ps -aux | grep kube-apiserver
```


 

