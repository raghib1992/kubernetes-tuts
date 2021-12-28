# API Group
## check version
```
curl https://<api-server>:6443/version --key admin.key --cert admin.crt --cacert ca.crt
```

## api group responsible for cluster function
### core /api
### named /apis

```

```
## to view api group
```
curl https://localhost:6443 -k
```
```
curl https://localhost:6443/apis -k | grep "name"
```
# You can use kube proxy in place of passing key and cert name in command for authenticaition
# kube proxy started locally on port 8001 and uses credential and certificate from kubeconfig file
```
kubectl proxy
curl https://localhost:8001 -k
``` 
