# Kube config
## Using curl command
```
curl https://my-kube-playground:6443/api/v1/pods --key admin.key --cert admin.crt --cacert ca.crt
```
## Using kubectl
```
kubectl get pods
    --server my-kube-playground:6443
    --client-key admin.key
    --client-certificate admin.crt
    --certificate-authority ca.crt
```
## Using config file
### $HOME/.kube/config (default)
```
--server my-kube-playground:6443
--client-key admin.key
--client-certificate admin.crt
--certificate-authority ca.crt
```
```
kubectl get pods --kubeconfig config
```
**************************
# kubeConfig
## Config file had 3 section
### 1. Cluster
#### Development, Production, testing 
### 2. Context
#### Which user account will access which cluster
#### eg admin@production, dev@development
### 3. Users
#### Admin, Dev ,Prod User
## kubeconfig file
```
apiVersion: v1
kind: Config
current-context: dev-user@google (become default context)
clusters:
contexts:
- name: my-kube-playground
  cluster:
    certificate-authority: ca,crt
    server: https://my-kube-playground:6443
contexts:
- name: my-kube-admin@my-kube-playground
  context:
    cluster: my-kube-playground
    user: my-kube-admin
    namespace: finance
users:
- name: my-kube-admin
  user:
    client-certificate: admin.crt
    client-key: admin.key
```
### toview the current config file
```
kubectl config view
```
### to amke use to config file rather than default one present $HOME die
```
kubectl config view --kubeconfig=my-custom-config
```
### to update the current context of the kube config file
```
kubectl config use-context prod@prodcution
```
### for other
```
kubectl config -h
```
### Note: also can provide crt data in base64 decode in config file
```
certificate-authority-data: Lsodafnal;faoiwerhfao'w:Frw'
```