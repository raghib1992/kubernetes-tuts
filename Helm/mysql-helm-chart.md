## Install mysql helm chart
```
helm install <instance name> <repo name>/<chart name>
helm install mydb bitnami/mysql
```
## To pass own custom password to db
```
helm install mydb bitnami/mysql --set auth.rootPassword = test123
```
#### create values.yaml file
```
auth:
  rootPassword: "test@123"
```
#### Use the valuse file to pass pasword 
```
helm install mydb bitnami/mysql --values /opt/helm/values.yaml
```
#### Use namespace to install mysql chart into particular namespace
```
helm install mydb bitnami/mysql -n prod-ns
```
#### Note: Copy all the logs 


## To get the release notes
```
helm get notes mydb
```

### To get all the values set
```
helm get values mydb
```
## To get all values
```
helm get values mydb --all
```

## To get the entire maniest file 
```
helm get manifest mydb
```