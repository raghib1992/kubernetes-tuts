# Ref
```
https://aws.amazon.com/blogs/opensource/kubernetes-ingress-aws-alb-ingress-controller/
https://aws.amazon.com/premiumsupport/knowledge-center/eks-alb-ingress-aws-waf/
```
# Deploy Amazon EKS
## Create Cluster
```
eksctl create cluster --name=attractive-gopher
```

## Create IODC provider to access associated cluster
```
eksctl utils associate-iam-oidc-provider --cluster=attractive-gopher --approve
```
# Deploy AWS ALB Ingress controller

## deploy the relevant RBAC roles and role bindings as required by the AWS ALB Ingress controller:
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/rbac-role.yaml
```
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  labels:
    app.kubernetes.io/name: alb-ingress-controller
  name: alb-ingress-controller
rules:
  - apiGroups:
      - ""
      - extensions
    resources:
      - configmaps
      - endpoints
      - events
      - ingresses
      - ingresses/status
      - services
    verbs:
      - create
      - get
      - list
      - update
      - watch
      - patch
  - apiGroups:
      - ""
      - extensions
    resources:
      - nodes
      - pods
      - secrets
      - services
      - namespaces
    verbs:
      - get
      - list
      - watch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  labels:
    app.kubernetes.io/name: alb-ingress-controller
  name: alb-ingress-controller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: alb-ingress-controller
subjects:
  - kind: ServiceAccount
    name: alb-ingress-controller
    namespace: kube-system
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/name: alb-ingress-controller
  name: alb-ingress-controller
  namespace: kube-system
...
```
## create an IAM policy named ALBIngressControllerIAMPolicy to allow the ALB Ingress controller to make AWS API calls on your behalf
```
aws iam create-policy \
    --policy-name ALBIngressControllerIAMPolicy \
    --policy-document https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/iam-policy.json
```
## create a Kubernetes service account and an IAM role (for the pod running the AWS ALB Ingress controller)
```
eksctl create iamserviceaccount \
       --cluster=attractive-gopher \
       --namespace=kube-system \
       --name=alb-ingress-controller \
       --attach-policy-arn=$PolicyARN \
       --override-existing-serviceaccounts \
       --approve
```

##
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: "argocd"
  namespace: "argocd"
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
  labels:
    app.kubernetes.io/component: server
    app.kubernetes.io/name: argocd-server
    app.kubernetes.io/part-of: argocd 
spec:
  rules:
    - http:
        paths:
          - path: /*
            backend:
              serviceName: "argocd-server"
              servicePort: 30411
```

## deploy the AWS ALB Ingress controller:
```
curl -sS "https://raw.githubusercontent.com/kubernetes-sigs/aws-alb-ingress-controller/v1.1.4/docs/examples/alb-ingress-controller.yaml" \
     | sed "s/# - --cluster-name=devCluster/- --cluster-name=attractive-gopher/g" \
     | kubectl apply -f 
```

## Finally, verify that the deployment was successful and the controller started:
```
kubectl logs -n kube-system $(kubectl get po -n kube-system | egrep -o alb-ingress[a-zA-Z0-9-]+)
```
