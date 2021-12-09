# Resource Request
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
    resources:
      requests:
        memory: "1Gi"
        cpu: 1
```
## CPU 0.1=100 milli (lowest unit)
## mem 256 Mi
### 1 G (Gigabyte)  = 1,000,000,000 bytes
### 1 M (Megabyte) = 1,000,000 bytes
### 1 K (Kilobyte) = 1,000 bytes

### 1 Gi (Gibibyte) = 1,073,741,824 bytes
### 1 Mi (Mebibytes) = 1,048,576 bytes
### 1 Ki (kibibyte) = 1,024 bytes

# Resource Limit
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
    resources:
      requests:
        memory: "1Gi"
        cpu: 1
      limits:
        memory: "2Gi"
        cpu: 2
        