## Add repo stable
helm repo add stable https://charts.helm.sh/stable
## to add repo
helm repo add bitnami https://charts.bitnami.com/bitnami

## link for bitnami chart
bitnami.com/stacks/helm

## to get the list of repo
helm repo list

## To update stable repo
helm repo update

## to remove the repo
helm repo remove <repo name>
helm repo remove bitnami
******************
## TO search all the chart in repo
helm search repo
helm search repo <repo name>
helm search repo mysql
helm search repo mysql --version
helm search hub <package name>

## to get the list of chart
helm list

## Create chart 
helm create <any name>

## to uninstall/delete chart
helm delete <chart name>

## Install chart
helm install <release name> <repo> <chart name>
helm install testjenkins-1 stable/jenkins
helm install apache bitnami/apache --namespace web

## Upgrade Chart
helm upgrade apache bitname/apache --namespace web



## to dry run amy chart
helm install --dry-run dev-jenkins stable/jenkins

## time period to wait for install chart
helm install --wait --timeout 25s prod-tomcat stable/tomcat
## to set any chart values
helm install test-jenkins stable/jenkins --set master.serviceType=NodePort
## To install chart in namespace and create the namesoace at the same time
helm install myweb bitnami/apapche --namespace web --create-namespace
## helm upgrad and install
helm upgrade --install myweb bitnami/apache -n web
## install required chart version
helm install testjenkins-1 stable/jenkins --version XX.XX.XX

## To helm generate instance name
helm install bitnami/mysql --generate-name
helm install bitnami/apache --generate-name --name-template "myweb-{{randAlpha 7 | lower}}"

## To allow wait to onject to wait
helm install bitnami/apache --wait --timeout 5m10s

#### Note If installation not complete in given wait period, then install back to previous successful release
helm install myweb bitnami/apache --atomc --timeout 7m10s




## to check chart parameter and values before add it locally
helm show values stable/tomcat  
helm show chart stable/tomcat
helm show all stable/tomcat 

## to uninstall chart
helm uninstall <chart name>
helm uninstall apache

#### to keep the history (kepl in the secret file)
helm unibstall mydb --keep-history

## get the describetion of installed chart 
helm get <all/values/manifest> <chart name>

## check the status of helm
helm status <chart name> 



## to check the chart manifest file 
helm get manifest <chart name>

## to check status
helm status <chart name>

## to check chart revision
helm history <instance name>
helm history mydb


## download chart to check manifest file
helm pull <repo/chart>
helm pull --untar <repo/chart>

## Update chart
helm status <instance name>
helm status mydb
#### GIve the info for update chart
helm upgrade <chart name> <repo/chart>
helm upgrade mydb bitnami/mysql
helm upgrade mydb bitnami/mysql --force
helm upgrade mydb bitnami/mysql --cleanup-on-failure (## To clean all danzling thingls)
helm upgrade mydb bitnami/mysql --values ./values.yaml
#### To reuse the vlaues file from installation time
helm upgrade mydb bitnami/mysql --reuse-values

## TO check the template 
helm template <instance> <repo/chart> --value ./values.yaml
helm template mydb bitnami/mysql --values ./values.yaml

## to roll back to previous version
helm rollback <instance name> <revision>
helm rollback apache 1 --namespace web

