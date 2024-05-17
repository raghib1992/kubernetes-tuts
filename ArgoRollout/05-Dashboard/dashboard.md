# Start dashboard
```sh
kubectl argo rollouts dashboard
```

Start canary-rollout rollout and service 
```sh
cd C:\Users\knrs986\raghib\kubernetes-tuts\ArgoRollout\05-Dashboard
kubectl apply -f 01-canary-rollout.yaml
kubectl apply -f 02-rollout-service.yaml
```
# Dashboard with ingress and service
### Create ingress
```yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argo-rollouts-dashboard
  namespace: argo-rollouts
spec:
  rules:
    - host: argo-rollouts.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argo-rollouts-server
                port:
                  number: 8080
```
### Secure Access
```yml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: argo-rollouts
  name: argo-rollouts-dashboard
rules:
- apiGroups: [""]
  resources: ["services"]
  verbs: ["get", "list"]
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]

---

apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: argo-rollouts-dashboard
  namespace: argo-rollouts
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: argo-rollouts-dashboard
subjects:
- kind: ServiceAccount
  name: default
  namespace: argo-rollouts
```

