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