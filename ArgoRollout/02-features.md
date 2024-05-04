# Research the Argo Rollouts Features.
### The benefits of using Argo Rollouts for application delivery are followings:
- Advance deployment strategies like Canary Deployment, Blue-Green Deployment, Rolling Updates, Recreate, Fine Grained
- we can add manual or automatic promote of deployment steps in rollouts:
- Sample rollout for auto promotion of steps in strategy in every 10 sec
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: example-rollout
spec:
  replicas: 3
  selector:
    matchLabels:
      app: example
  template:
    metadata:
      labels:
        app: example
    spec:
      containers:
      - name: rollouts-demo
        image: argoproj/rollouts-demo:blue
        ports:
        - containerPort: 8080
  strategy:
    canary:
      steps:
      - setWeight: 20
      - pause: {duration: 10s}
      - setWeight: 40
      - pause: {duration: 10s}
      - setWeight: 60
      - pause: {duration: 10s}
      - setWeight: 80
      - pause: {duration: 10s}
```
- If pause duration is not mention, then its need to promote manually


# Compare Argo Rollouts with existing application delivery tools like ArgoCD & Kargo
# Identify potential challenges or limitations of implementing Argo Rollouts.
# Find out how we can add permission and Login access using SSO
# Check dedicated UI available. and open dashboard through present ingress