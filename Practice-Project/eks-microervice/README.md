EKS CLuster Pricing
$0.10 per hour for each amazon eks cluster and $2.4 per day and $30 for month
Ref github repo for EKS


AWS EKS Kubernetes - Masterclass

https://github.com/stacksimplify/aws-eks-kubernetes-masterclass

Docker Fundamentals

https://github.com/stacksimplify/docker-fundamentals

Kubernetes Fundamentals

https://github.com/stacksimplify/kubernetes-fundamentals



https://github.com/raghib1992/aws-eks-kubernetes-masterclass
Step 01 Install AWS CLI
Step 02 Install Kubectl
Step 03 Install EKSCTL
Step 04 Create EKs cluster using eksctl
eksctl create cluster --name=eksdemo1 --region=ap-south-1 --zones=ap-south-1a,ap-south-1b --without-nodegroup

Step 05 Create and Associate IAM OIDC Provider for our EKS cluster
eksctl utils associate-iam-oidc-provider --region ap-south-1 --cluster eksdemo1 --approve

Step 06 Create EC2 Key Pair
name kube-demo

Step-07: Create Node Group with additional Add-Ons in Public Subnets
# Create Public Node Group   
eksctl create nodegroup --cluster=eksdemo1 --region=ap-south-1 --name=eksdemo1-ng-public1 --node-type=t3.medium --nodes=2 --nodes-min=2 --nodes-max=4 --node-volume-size=20 --ssh-access --ssh-public-key=kube-demo --managed --asg-access --external-dns-access --full-ecr-access --appmesh-access --alb-ingress-access

Step 08: Verify Cluster and Nodes
1. Verify EKS Nodegroup Subnet, asg, Networking, logging (by default disable)
2. Worker node IAM role and policies
3. Check cloudformation
4. Check Security Group
# List EKS clusters
eksctl get cluster

# List NodeGroups in a cluster
eksctl get nodegroup --cluster=<clusterName>

# List Nodes in current kubernetes cluster
kubectl get nodes -o wide

# Our kubectl context should be automatically changed to new cluster
kubectl config view --minify