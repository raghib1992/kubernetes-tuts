# Fargate
## command to deploy eks cluster with fargate
```
eksctl create cluster --name fargate-demo --fargate
```
## Create additional namespace under fargate profile
```
eksctl create fargateprofile --cluster <cluster name> --name <fargate profile name> --namespace <namespace name>