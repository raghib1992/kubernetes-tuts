# security context
## security at pod level
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
    securityContext:
        ranAsUser: 1000
    containers:
    - name: nginx-container
      image: nginx
      command: ["sleep", "1000"]
```
## security at container level
```
pod-definition.yaml
-------------------------
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
      command: ["sleep", "1000"]
      securityContext:
        ranAsUser: 1000
        capabilities:
            add: ["MAC_ADMIN"]
```