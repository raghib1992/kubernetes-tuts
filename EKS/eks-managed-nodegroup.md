## yaml file to create cluster
eksctl-create-cluster.yaml
```
--- 
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: config-file
  region: us-west-2

nodeGroups:
  - name: ng-default
    instanceType: t3.micro
    desiredCapacity: 2
```
## command
```
eksctl create cluster --config-file=eksctl-create-cluster.yaml
```
## Yaml file to create nodegroup
```
--- 
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: eksctl-test
  region: us-west-2

nodeGroups:
  - name: ng1-public
    instanceType: t3.micro
    desiredCapacity: 2
  
managedNodeGroups:
  - name: ng2-managed
    instanceType: t3.micro
    minSize: 1
    maxSize: 3
    desiredCapacity: 2 
```
```
eksctl create nodegroup --config-file=eksctl-create-ng.yaml
```

## create cluster with managed node group
```
eksctl create cluster --name <name> --version 1.15 --nodegroup-name <nodegroup name> --node-type t3.micro --nodes 2 --managed
```