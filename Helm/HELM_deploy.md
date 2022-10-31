# official site to download helm
https://helm.sh/docs/intro/install/


## install helm on window
choco install kubernetes-helm

## install helm 3 on linux
### Ref https://helm.sh/docs/intro/install/
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
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
