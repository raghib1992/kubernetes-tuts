- Open folder canary
- check kustomizatopn.yaml
- run `kubectl kustomize | kubectl apply -f -` in canary folder

- access in browser using `localhost:8001/api/v1/namespaces/default/services/canary-demo-preview:80/proxy`
- update rollout image
```sh
kubectl argo rollouts set image canary-demo canary-demo=argoproj/rollouts-demo:red
```