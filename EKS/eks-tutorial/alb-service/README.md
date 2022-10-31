## Create OIDC provider
```
aws eks describe-cluster --name test1 --query "cluster.identity.oidc.issuer" --output text
```


## To check the iam oidc provider in my aws account
```
aws iam list-open-id-connect-providers | grep C39769F3B876998107F279CF53348E35
```

## Create Iam oidc provide to access accociated cluster
```
eksctl utils associate-iam-oidc-provider --cluster test1 --approve
```
## reate an IAM policy named AWSLoadBalancerControllerIAMPolicy to allow the ALB Ingress controller to make AWS API calls on your behalf
```
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam-policy.json
```

## create a Kubernetes service account and an IAM role
```
eksctl create iamserviceaccount \
        --cluster=test1 \
        --namespace=kube-system \
        --name=aws-load-balancer-controller \
        --attach-policy-arn=arn:aws:iam::561243041928:policy/AWSLoadBalancerControllerIAMPolicy \
        --override-existing-serviceaccounts \
        --approve
```

## Install Cert manger to help insert certificate into webhook
```
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml
```
## Download ingress controller yaml file
```
curl -Lo ingress-controller.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.4/v2_4_4_full.yaml
```
## Edit the cluster-name for your cluster. 
### For example:
```
spec:
    containers:
    - args:
        - --cluster-name=your-cluster-name # edit the cluster name
        - --ingress-class=alb
```
## Update only the ServiceAccount section of the file only.
### For example:
```
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  annotations:                # Add the annotations line
    eks.amazonaws.com/role-arn: arn:aws:iam::111122223333:role/role-name              # Add the IAM role
  name: aws-load-balancer-controller
  namespace: kube-system
```
## AWS Load Balancer Controller
```
kubectl apply -f ingress-controller
```