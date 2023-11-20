---
title: AWS Load Balancer Controller - Ingress Target Type IP
description: Learn AWS Load Balancer Controller - Ingress Target Type IP
---

## Step-01: Introduction
- `alb.ingress.kubernetes.io/target-type` specifies how to route traffic to pods. 
- You can choose between `instance` and `ip`
- **Instance Mode:** `instance mode` will route traffic to all ec2 instances within cluster on NodePort opened for your service.
- **IP Mode:** `ip mode` is required for sticky sessions to work with Application Load Balancers.


## Step-02: Ingress Manifest - Add target-type
- **File Name:** 04-ALB-Ingress-target-type-ip.yml
```yaml
    # Target Type: IP
    alb.ingress.kubernetes.io/target-type: ip   
```

## Step-03: Deploy all Application Kubernetes Manifests and Verify
```sh
# Deploy kube-manifests
kubectl apply -f 12-ingress-target-type-ip/

# Verify Ingress Resource
kubectl get ingress

# Verify Apps
kubectl get deploy
kubectl get pods

# Verify NodePort Services
kubectl get svc
```
### Verify Load Balancer & Target Groups
- Load Balancer -  Listeneres (Verify both 80 & 443) 
- Load Balancer - Rules (Verify both 80 & 443 listeners) 
- Target Groups - Group Details (Verify Health check path)
- Target Groups - Targets (Verify all 3 targets are healthy)
- **PRIMARILY VERIFY - TARGET GROUPS which contain thePOD IPs instead of WORKER NODE IP with NODE PORTS**
```sh
# List Pods and their IPs
kubectl get pods -o wide
```

### Verify External DNS Log
```sh
# Verify External DNS logs
kubectl logs -f $(kubectl get po | egrep -o 'external-dns[A-Za-z0-9-]+')
```
### Verify Route53
- Go to Services -> Route53
- You should see **Record Sets** added for 
  - target-type-ip-501.stacksimplify.com 


## Step-04: Access Application using newly registered DNS Name
### Perform nslookup tests before accessing Application
- Test if our new DNS entries registered and resolving to an IP Address
```sh
# nslookup commands
nslookup target-type-ip-501.stacksimplify.com 
```
### Access Application using DNS domain
```sh
# Access App1
http://i20.raghib.in/app1/index.html

# Access App2
http://i20.raghib.in/app2/index.html

# Access Default App (App3)
http://i20.raghib.in
```

## Step-05: Clean Up
```sh
# Delete Manifests
kubectl delete -f 12-ingress-target-type-ip/

## Verify Route53 Record Set to ensure our DNS records got deleted
- Go to Route53 -> Hosted Zones -> Records 
- The below records should be deleted automatically
  - target-type-ip-501.stacksimplify.com 
```