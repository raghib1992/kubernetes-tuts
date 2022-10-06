## To view the config
```
kubectl config view 
```
## To view the config context
```
kubectl config get-contexts
```
## To create new context
```
kubectl config set-context <context-name> --namespace= --user --cluster
```
## To view current context
``` 
kubectl config current-context
```
## change context
```
kubectl config use-context <context name>
```