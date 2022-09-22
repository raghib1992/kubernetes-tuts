## install helm 3
### Ref https://helm.sh/docs/intro/install/
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```
### service account
```
kubectl create sa tiller -n kube-system
```

### cluster role
```
cluster-admni
```

### cluster binding role
```
kubectl create clusterrolebinding tiller-role-binding --clusterrole cluster-admin --serviceaccount=kube-system:tiller
```

s
