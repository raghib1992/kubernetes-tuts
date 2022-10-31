# Give admin access to other IAM users for your cluster
## To get kubeconfig map 
aws eks update-kubeconfig --name test-cluster
## edit the iam user to predefine group system:master in config maps/aws-auth
```
kubectl edit -n kube-system configmap/aws-auth
```
```
mapUsers:
  - userarn: arn:aws:iam::98235792845:user/devopsraghib
    username: devopsraghib
    groups:
      - system:masters
```
********************************************************

# Give granular access to IAM users

## Create Role with name devlopers-role
## Create role binding and bind devlopers role with user devloper-nadim
## edit config map
  mapUsers: |
    - groups:
      - team-a
      userarn: arn:aws:iam::561243041928:user/team-a
      username: team-a