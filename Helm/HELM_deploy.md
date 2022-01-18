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

### Usefull command
```
helm help
helm install --values --name
helm fetch (fetch the chart locally to your machine)
helm list (list installed application)
helm status (status of the application)
helm search
helm repo update
helm upgrade
helm rollback
helm delete --purge
helm reset
```
