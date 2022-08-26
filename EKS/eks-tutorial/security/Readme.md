RBAC
IRSA
Cluster Role
Cluster Role binding\

**********************************************
# Admin access to IAM user

To know the iam user who created the eks cluster
```
aws sts get-caller-identity
```

edit configmap/aws-auth
```
kubectl edit configmap/aws-auth -n kube-system
```
configmap
```
# Please edit the object below. Lines beginning with a '#' will be ignored,
# and an empty file will abort the edit. If an error occurs while saving this file will be
# reopened with the relevant failures.
#
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::561243041928:role/eksctl-dev-cluster-nodegroup-ng-2-NodeInstanceRole-YTKN7B6OKFWT
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    - userarn: arn:aws:iam::561243041928:user/test
      username: test
      groups:
        - system:masters
kind: ConfigMap
metadata:
  creationTimestamp: "2022-08-21T16:56:34Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "1387"
  uid: 01f7d1ca-aec7-4c0f-be3f-caa9429466da
```

************************

Role based granular access to IAM user

Create role and role binding
```
kubectl apply -f user-rolebinding.yaml
```
edit configmap/aws-auth
```
kubectl edit configmap/aws-auth -n kube-system
```
configmap