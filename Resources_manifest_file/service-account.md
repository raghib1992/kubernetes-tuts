# Account
## User account
## Service account
### Account made by application to interact with k8s
### to create a service account
```
kubectl create serviceaccount <account-name>
kubectl get serviceaccount
kubectl describe serviceaccount <account-name>
```
### when service account created, its generate a token, that token used by 3rd party to get authenticate
#### to view the secret object (token value)
```
kubectl describe secret <token name>
```

```
curl https://192.168.56.70:6443/api -insecure --header "Authorization: Bearer Eklfslkhfosndv..."
```
## to view token inside pod as volume mount
```
kubectl exec -ti <container-name> cat /var/run/secret/kubernetes.io/serviceaccount/token
```
## to add service account to pod
```
apiVersion: v1
kind: Pod
metadata:
    name: myapp-pod
    labels:
        app: web
        env: prod
        tier: front-end
spec:
    containers:
    - name: nginx-container
      image: nginx
    serviceAccountName: dashboard-sa
```
## k8s also mention a default service account or you explicitly mention 
```
automountServiceAccountToken: false
```
## Role binding for service account
```
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: ServiceAccount
  name: dashboard-sa # Name is case sensitive
  namespace: default
roleRef:
  kind: Role #this must be Role or ClusterRole
  name: pod-reader # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
  ```
