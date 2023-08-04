# Node Affinity
## To set limitation on the pod so it go into the desire node...pod placement on specific node
# pods yaml file
pod-definition.yml
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
    affinity:
        nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                - matchExpressions:
                  - key: size
                    operator: In/NotIn/Exists
                    values:
                    - Large
                    - Medium
```
Node Affinity type
- requiredDuringSchedulingIgnoredDuringExecution
- preferredDuringSchedulingIgnoredDuringExecution
- requiredDuringSchedulingRequiredDuringExecution