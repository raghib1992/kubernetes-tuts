## Install kube-controller manager
```
wget https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kube-controller-manager
```

## kube-controller-manager.servive
```
cat /etc/systemd/system/kube-controller-manager.service
ps -aux | grep kube-controller-manager
```

# when install through kube-adm

## kube-controller available in kube-system name space
```
kubectl get pods -n kube-system
```

## manifests file located:
```
cat /etc/kubernetes/manifests/kube-controller-manager.yaml
```
