# AutoScaler
## Ref https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html#cluster-autoscaler


## two components
### 1. Open Source Cluster AutoSclare
### 2. EKS Implementation (ASG, IAM etc)


```
eksctl create cluster --name <cluster name> --version <give the eks latest version> --managed --asg-access
```
## To deploy the Cluster Autoscaler

### Check autoscalre version as per cluster version
