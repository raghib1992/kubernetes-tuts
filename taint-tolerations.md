# Taint and Toleration
## Taint applied on the node so pod not tolerate that taint
## toleration applied on the pod, so pod tolerate the taint aplied on the node
## Commands
```
kubectl taint nodes <node-name> <key>=<value>:<taint-effect>
kubectl taint nodes worker-1 tier=prod:PreferNoSchedule
kubectl describe node <node name> | grep Taints
kubectl describe node worker-1 | grep Taints
```

## taint-effect:
### NoSchedule
### PreferNoSchedule
### NoExecute

## tolearation to pod
pod-definition.yaml
```
apiVersion: v1
kind: Pod
metadata:
    name: myapp-pod
    labels:
        app: web
        env: prod
        tier: front-end
spec:
    containers:
    - name: nginx-container
        image: nginx
    tolerations:
    - key: <"key">
      operator: "Equal"
      value: <"value">
      effect: <"taint-effect">
```