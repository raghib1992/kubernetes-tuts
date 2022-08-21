Ways to spinup  EKS CLuster
1. AWS Console
2. Cloudformation/terraform
3. AWS CLI
4. eksctl cli (recommended)


Prerequisite
1. install and setup awscli
2. install kubectl
3. install eksctl 



Create EKS cluster using eksctl 

1. create clustre one nodegroup contaning 2 m5.large worker nodes
```
eksctl create cluster
```
2. Create eks cluster with version 1.15 with 2  t3.micro nodes
```
eksctl create cluster --name test-cluster --version 1.15 --node-type t3.micro --nodes 2
```
3. Create eks cluster with managed nodegroup
```
eksctl create cluster --name dev-cluster --version 1.15 --nodegroup dev-ng --node-type t3.micro --nodes 2 --managed
```
4. eks cluster with fargate profile
```
eksctl create cluster --name prod-cluster --fargate
```
*** Alternatively***
Use configfile to create ng
```
eksctl create nodegroup --config-file=eksctl-create-ng.yaml
eksctl get nodegroup --cluster=clustername
```
use config file to create cluster
```
eksctl create cluster --config-file=eksctl-create-cluster.yaml
eksctl get cluster
eksctl delete cluster --name=<cluster name>
```

Limits pod on nodes
Ref: https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt