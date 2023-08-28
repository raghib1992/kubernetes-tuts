# EKS Cluster
    - EKS CLuster
    - Worker Nodegroup
    - Fargate Profile
    - VPC
    - RDS
    - ALB ingress
## delete EKs Cluster
```
eksctl delete cluster <clustername>
eksctl delete nodegroup --cluster=<cluster name> --name=<nodegroup name>
```
*****
## Ref github repo for EKS
 - AWS EKS Kubernetes - Masterclass
    - *https://github.com/stacksimplify/aws-eks-kubernetes-masterclass*
 - Docker Fundamentals
    - *https://github.com/stacksimplify/docker-fundamentals*
 - Kubernetes Fundamentals
    - *https://github.com/stacksimplify/kubernetes-fundamentals*


## Create EKS Cluster
 - *https://github.com/raghib1992/aws-eks-kubernetes-masterclass*

### **Step 01 Install AWS CLI**

### **Step 02 Install Kubectl**

### **Step 03 Install EKSCTL**

### **Step 04 Create EKs cluster using eksctl**
```sh
eksctl create cluster --name=eksdemo1 --region=ap-south-1 --zones=ap-south-1a,ap-south-1b --without-nodegroup
```
### **Step 05 Create and Associate IAM OIDC Provider for our EKS cluster**
```sh
eksctl utils associate-iam-oidc-provider --region ap-south-1 --cluster eksdemo1 --approve
```
### **Step 06 Create EC2 Key Pair**
- name: **kube-demo**


### **Step-07: Create Node Group with additional Add-Ons in Public and Private Subnets**
```sh
# Create Public Node Group   

eksctl create nodegroup --cluster=eksdemo1 --region=ap-south-1 --name=eksdemo1-ng-public1 --node-type=t3.medium --nodes=2 --nodes-min=2 --nodes-max=4 --node-volume-size=20 --ssh-access --ssh-public-key=kube-demo --managed --asg-access --external-dns-access --full-ecr-access --appmesh-access --alb-ingress-access
```

```sh
# Create Nodegroup in Private subnet

eksctl create nodegroup --cluster=eksdemo1 --region=ap-south-1 --name=eksdemo1-ng-private1 --node-type=t3.medium --nodes-min=2 --nodes-max=4 --node-volume-size=20 --ssh-access --ssh-public-key=kube-demo --managed --asg-access --external-dns-access --full-ecr-access --appmesh-access --alb-ingress-access --node-private-networking   
```
### **Subnet Route Table Verification - Outbound Traffic goes via NAT Gateway**
1. Verify the node group subnet routes to ensure it created in private subnets
2. Go to Services -> EKS -> eksdemo -> eksdemo1-ng1-private
3. Click on Associated subnet in **Details** tab
4. Click on **Route Table** Tab.
5. We should see that internet route via NAT Gateway (0.0.0.0/0 -> nat-xxxxxxxx)

### **Step 08: Verify Cluster and Nodes**
1. Verify EKS Nodegroup Subnet, asg, Networking, logging (by default disable)
2. Worker node IAM role and policies
3. Check cloudformation
4. Check Security Group
5. List EKS clusters
```sh
eksctl get cluster
```
6. List NodeGroups in a cluster
```sh
eksctl get nodegroup --cluster=<clusterName>
```
7. Delete NodeGroups in a EKS Cluster
```sh
eksctl delete nodegroup <NodeGroup-Name> --cluster <Cluster-Name>
eksctl delete nodegroup eksdemo1-ng-public1 --cluster eksdemo1

# Error: 1 pods are unevictable from node ip-192-168-35-54.ap-south-1.compute.internal

eksctl delete nodegroup eksdemo1-ng-public1 --cluster eksdemo1 --drain=false --disable-eviction
```
8. List Nodes in current kubernetes cluster
```sh
kubectl get nodes -o wide
```
8. Our kubectl context should be automatically changed to new cluster
```sh
kubectl config view --minify
```
### **Step-09: Create Resplicaset**
```sh
kubectl apply -f replicaSet.yaml
```
### Step-10: Expose replicaSet using NodePort
```sh
kubectl expose rs my-helloworld-rs --type=NodePort --port=80 --name=my-helloworld-service
```
### Step-11: Create deployment
```sh
kubectl create deployment <deployment name> --image=<image name>
kubectl create deployment my-first-deployment --image=stacksimplify/kubenginx:1.0.0
```
### Step-12: Edit deployment
1. replicas
```sh
kubectl scale --replicas=20 deployment/<Deployment-Name>
kubectl scale --replicas=20 deployment/my-first-deployment
```
2. image
```sh
kubectl set image deployment/<Deployment-Name> <Container-Name>=<Container-Image> --record=true
```
3. Edit Deployment
```sh
kubectl edit deployment/<Deployment-Name> --record=true
```
4. resources
```sh
kubectl set resources deployment/my-first-deployment -c=kubenginx --limits=cpu=20m,memory=30Mi
```
### Step-13: Verify rollout
```sh
kubectl rollout status deployment/my-first-deployment
```
### Step-14: Verify Rollout History of a Deployment
```sh
kubectl rollout history deployment/<Deployment-Name>
kubectl rollout history deployment/my-first-deployment --revision=<revision number>
```
### Step-15: Rollback to previous version
```sh
kubectl rollout undo deployment/my-first-deployment
kubectl rollout undo deployment/my-first-deployment --to-revision=3
```
### Step-16: Rolling Restarts of Application
### Rolling restarts will kill the existing pods and recreate new pods in a rolling fashion.
```sh
kubectl rollout restart deployment/<Deployment-Name>
kubectl rollout restart deployment/my-first-deployment
```
### Step-17: Pause qand resume deployment
1. Pause
```sh
kubectl rollout pause deployment/<Deployment-Name>
kubectl rollout pause deployment/my-first-deployment
```
2. Update deployment
```sh
kubectl set image deployment/my-first-deployment kubenginx=stacksimplify/kubenginx:4.0.0 --record=true
```
3. Resume the Deployment
```sh
kubectl rollout resume deployment/my-first-deployment
```
### Step-18: Expose deployment
```sh
kubectl expose deployment <Deployment-Name>  --type=NodePort --port=80 --target-port=80 --name=<Service-Name-To-Be-Created>

kubectl expose deployment my-first-deployment  --type=NodePort --port=80 --target-port=80 --name=my-first-service
```
### Step-19: Create Namespace
```sh
kubectl get ns
kubectl get all -n kube-system
kubectl create ns prod
```

#### Namespace script
```yml
# nasmespace.yaml
# kubectl apply -f nasmespace.yaml
apiVersion: v1
kind: Namespace
metadata:  
    name: dev
```

## EKS CLuster Pricing

- `$0.10 per hour` for each amazon eks cluster and `$2.4 per day` and `$30` for month
- Worker Node Pricing
    - T3 medium Server
    - `$0.0416 per` hour and $1 for per day