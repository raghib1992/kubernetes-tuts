# Network Policies
### To restrict pod to access by other pods
## Traffic
## Network Policy
### policy.yaml
```
apiversion: networking.k8s.io/v1
kind: Networkingpolicy
metadata:
    name: db-policy
spec:
    podSelector:
        matchLabels:
            role:db
    policyType:
    - Ingress
    - Egress
    ingress:
    - from:
        - podSelector:
            matchLabels:
            name: api-pod
          namespaceSelector:
            name: prod
        - ipBlock:
            cidr: 192.168.5.10/32
      ports:
        - protocol: TCP
          port: 3306
    egress:
    - to:
        - ipBlock:
            cidr: 192.168.5.10.32
        ports:
            - protocol: TCP
              port: 80
```
```
kubectl create -f policy.yaml
kubectl get netpol
```
### Flannel doen't support network policies