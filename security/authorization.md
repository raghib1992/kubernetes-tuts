# Authorization
## Different authorization mechanism
## 1. Node
#### any components which is part of Group SYSTEM:NODES will authorized by node authorizer
## 2. ABAC
### Attribute Based Authorization
### You have to create policy file in JSON 
### create a policy for each user
```
{"kind": "Policy", "spec": {"user": "dev-user", "namespace": "*", "resource": "pods", "apiGroup": "*"}}
```
## 3. RBAC
### we create a role and attach the user as much as required
#### developer-role.yaml
```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
    name: developer
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list", "get", "create", "update", "delete"]
- apiGroups: [""]
  resources: ["configMap"]
  verbs: ["create"]
```
### specific role
#### developer-role.yaml
```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
    name: developer
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["list", "get",  "create", "update", "delete"]
  resourceNames: ["blue", "orange"]
```
#### command to create the rule
```
kubectl create -f developer-rule.yaml
```
##### For core group leave api group blank and for other mention the group name
#### role-binding.yaml
```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
    name: devuser-developer-binding
subjects:
- kind: User
  name: dev-user
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.io
```
#### command to bind the user with role
```
kubectl create -f role-binding.yaml
```
#### to view the created role
```
kubectl get roles
```
#### to get the list of role binding
```
kubectl get rolebindings
```
#### to details of the role
```
kubectl describe role developer
```
#### to view details of the role binding
```
kubectl describe rolebinding <name of the role binding>
```
******************
# How to check what I have access
```
kubectl auth can-i create deployments
kubectl auth can-i create nodes
kubectl auth can-i create pods --as <user name>
kubectl auth can-i create pods --as <user name> --namespace <name ns>
```
## 4. Webhook
### authrorization fron ext such as open policy agent
## 5. always allow
### 
## 6. always deny
## mode are set on kube-apiserver
```
--authorization-mode=AlwaysAllow (default)
--authorization-mode=Node,RBAZ,Webhook \\
```
****************************************************
# Cluster Role and Cluster Role Bindings
## Cluster Scope: nodes, PV, clusterroles, clusterrolebindings, certificatesigningrequests, namespaces
## to list the all resources in namespace and without namespace
```
kubectl api-resources --namespaced=true
kubectl api-resources --namespaced=false
```
## Create cluster-role
cluster-admin-role.yaml
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
    name: cluster-administrator
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["list", "get",  "create", "update", "delete"]
```
```
kubectl create -f cluster-admin-role.yaml
```
## create role binding
cluster-admin-role-binding.yaml
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
    name: cluster-admin-role-binding
subjects:
- kind: User
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-administrator
  apiGroup: rbac.authorization.k8s.io
```
```
kubectl create -f cluster-admin-role-binding.yaml
```