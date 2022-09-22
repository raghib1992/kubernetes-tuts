## Add repo
helm repo add stable https://charts.helm.sh/stable

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


## TO search all the repo
helm search repo
helm search repo <repo name>
helm search hub <package name>
## To update stable repo
helm repo update
## to add repo
helm repo add bitnami https://charts.bitnami.com/bitnami
## to get the list of repo
helm repo list
## to check chart parameter and values before add it locally
helm show values stable/tomcat  
helm show chart stable/tomcat
helm show all stable/tomcat 

## Create chart 
helm create <any name>


## Install chart
helm install <release name> <repo> <chart name>
helm install testjenkins-1 stable/jenkins

## to uninstall/delete chart
helm delete <chart name>

## to get the list of chart
helm list

## to dry run amy chart
helm install --dry-run dev-jenkins stable/jenkins

## time period to wait for install chart
helm install --wait --timeout 25s prod-tomcat stable/tomcat


## install required chart version
helm install testjenkins-1 stable/jenkins --version XX.XX.XX


## get the describetion of installed chart 
helm get <all/values/manifest> <chart name>

## check the status of helm
helm status <chart name> 

## to set any chart values
helm install test-jenkins stable/jenkins --set master.serviceType=NodePort

## to check the chart manifest file 
helm get manifest <chart name>

## to check status
helm status <chart name>

## to check chart revision
helm history <chart name>

## to upgrade a releasse
helm upgrade <chart name> <repo/chart>

## to roll back to previous version
helm rollback <chart name> <revision>

## download chart to check manifest file
helm pull <repo/chart>
helm pull --untar <repo/chart>

## to search for any specific chart
helm search repo <redis>
