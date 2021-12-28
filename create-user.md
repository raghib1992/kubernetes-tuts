# Create User

## Create ns
```
kubectl create ns <name-ns>
```
## Create user
```
useradd -m <user name>
```
## Generate TLS cert
```
openssl genrsa -out <user-name>.key 2048
openssl req -new -key <user-name>.key -subj "/CN=<user-name>/O=<group-name>" -out <user-name>.csr
openssl x509 -req -in <sanober>.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out <user-name>.crt -days 1000
```
## config kubeconfig file
### View your apiserver details
```
kubectl config view
```
### Method 1
#### send the key and crt to user and he will create kubeconfig file
```
kubectl config --kubeconfig <user-name>.kubeconfig set-cluster <cluster-name> --server https://<apiserver>:6443 --certificate-authority=ca.crt
```
### add user to kubeconfig file
```
kubectl config --kubeconfig <user-name>.kubeconfig set-credentials <username> --client-certificate <path to user.crt> --client-key <path to user.key> 
```
### set context
```
kubectl config --kubeconfig <username>.config set-context <username>-kubernetes --cluster=kubernetes-the-hard-way --namespace <name of namespace> --user=<username>
```

## edit <user-name>.kubeconfig file for current-context name
```
vi <username>.kubeconfig
```
### to remove use of the attribute from command --kubeconfig, cp this <user>.config file ~/.kube/config
```
cp <user>.kubeconfig ~/.kube/config
```
***************************************
## Method 3
### Create kubeconfig file
### Create role
```
kubectl create role <role-name> --verb=get,list,create --resource=pod --namespace=fiannce
```
### Create role binding
``` 
kubectl create rolebinding <name rolebinding> --role=<role name> --user=<username> --namespace <name of ns>
```

***************************************
## Method-2
## Create the user inside Kubernetes.
```
kubectl config set-credentials raghib \
  --client-certificate=raghib.crt \
  --client-key=raghib.key
```
## Create a context for the user.
```
kubectl config set-context raghib-context \
  --cluster=kubernetes-the-hard-way --user=raghib
```
### The raghib Kubernetes Configuration File

Generate a kubeconfig file for the `raghib` user:

```
{
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=raghib.kubeconfig

  kubectl config set-credentials raghib \
    --client-certificate=raghib.crt \
    --client-key=raghib.key \
    --embed-certs=true \
    --kubeconfig=raghib.kubeconfig

  kubectl config set-context raghib-context \
    --cluster=kubernetes-the-hard-way \
    --user=raghib \
    --kubeconfig=admin.kubeconfig

  kubectl config use-context kubernetes-the-hard-way --kubeconfig=raghib.kubeconfig
}
```
```
chown -R raghib: /home/raghib/
```
**********************************************************************************
# Create SA and bind with clusterROleBinding
## Cluster role
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  # "namespace" omitted since ClusterRoles are not namespaced
  name: nadim-clusterrole
rules:
- apiGroups: [""]
  resources: ["**"]
  verbs: ["*"]
```

## Cluster Role Binding
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: nadim-crb
subjects:
- kind: ServiceAccount
  name: nadim # name of your service account
  namespace: default # this is the namespace your service account is in
roleRef: # referring to your ClusterRole
  kind: ClusterRole
  name: nadim-clusterrole
  apiGroup: rbac.authorization.k8s.io
```

## extract token and decode base64
```
TOKENNAME=`kubectl get serviceaccount/<serviceaccount-name> -o jsonpath='{.secrets[0].name}'`
TOKEN=`kubectl get secret $TOKENNAME -o jsonpath='{.data.token}'| base64 --decode`
```
## Add Sa as a new user
```
kubectl config set-credentials <service-account-name> --token=$TOKEN
kubectl config set-context --current --user=<service-account-name>
```
## set kubeconfig file
```
{
  kubectl config set-cluster kubernetes-the-hard-way \
    --server=https://192.168.5.30:6443 \
    --kubeconfig=nadim.kubeconfig

  kubectl config set-credentials admin \
    --token="eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6Im5hZGltLXRva2VuLXh6cHB3Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6Im5hZGltIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiN2RjODgwMmItNjY2MC0xMWVjLWJmMzMtMDIyOWUwYzNiZTk0Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmRlZmF1bHQ6bmFkaW0ifQ.Wawma9_8mf6WDe4zmFiaU1cfIAhMyfgZ-hAfV80x8YkS1MyTS_VV6gumE7JOaxmGEBwKFVYEP7mqdGx9R8yN9uW-zNpgSd1VjyJqP4phobA_XFpZ9ji1Y2qKvabXliAW7OZLmOspNHVgXM543YAuM5tWCFVt5UedwqI-PtMvkpUZSm4__lKVRcYHG9rzox7MUzjRhYygwWsnm9yHu7r2mXmPkkLuBbomuhiVEj-2dnUUMfXmsdO7ZkcO1CD2B2SZbUZPaqVKUkdLU0Wfo4DAH7-Rn3fyM0nox7Bcqjtfv7mG7kzXVpfd85f39of1GxQ8i_KPo8_mBTeO1syUZwJIbQ"

  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=nadim \
    --kubeconfig=nadim.kubeconfig

  kubectl config use-context kubernetes-the-hard-way --kubeconfig=admin.kubeconfig
}
```