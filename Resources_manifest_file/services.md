# Node services
ref: https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands

## definition file
nodeport-definition.yaml
```
apiVersion: v1
kind: Service
metadata:
    name: myapp-service
spec:
    type: NodePort
    ports:
     - targetPort:80
       port: 80
       nodePort: 30008 # 300000-32767
    selector:
        app: web  # from contianer
        env: prod
```

## commands
```
kubectl create -f service-definition.yaml
kubectl get services
kubectl expose pod redis --port=6379 --name redis-service --dry-run=client -o yaml

kubectl expose pod nginx --type=NodePort --port=80 --name=nginx-service --dry-run=client -o yaml
```

# ClusterIP service
## Connect frontend to backend
## single interface for group of pods
## definition file
clusterIP-definition.yaml
```
apiVersion: v1
kind: Service
metadata:
    name: backend
spec:
    type: ClusterIP
    ports:
     - targetPort:80
       port: 80

    selector:
        app: web  # from contianer
        env: prod
```
## Command
```
kubectl create -f clusterIP-definition.yaml
kubectl get svc
kubectl create service clusterip redis --tcp=6379:6379 --dry-run=client -o yaml
kubectl create service nodeport nginx --tcp=80:80 --node-port=30080 --dry-run=client -o yaml
```

# Load Balancer
## definition file
load-balancer-definition.yaml
```
apiVersion: v1
kind: Service
metadata:
    name: lb-svc
spec:
    type: LoadBalancer
    ports:
     - targetPort:80
       port: 80
       noePort: 300008
    selector:
        app: web  # from contianer
        env: prod
```