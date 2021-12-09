# namespace

## to connect in the name space
mysql.connect("db-service")

## to connect in the other namespace
mysql.connect("db-service.dev.svc.cluster.local")
****db-service=serviceName*****dev=ns******svc=service*****cluster.local=domain***

## ns-definition.yaml
```
apiVersion: v1
kind: Namespace
metadata:
    name: dev
```
## command
```
kubectl create -f ns-definition.yaml
kubectl create namespace dev
kubectl config set-context $(kubectl config current-context) --namespace=dev
kubectl get pods --all-namespaces
```

## to set limit in each namespace, create resource quota
comute-quota.yml
```
piVersion: v1
kind: ResourceQuota
metadata:
    name: compute-quota
    namespace: dev
spec:
    hard:
      pods: "10"
      requests.cpu: "4"
      requests.memory: 5Gi
      limits.cpu: "10"
      limit.memory: 10Gi
```

## pods yaml file
pod-definition.yml
```
apiVersion: v1
kind: Pod
metadata:
    name: myapp-pod
    namespace: dev
    labels:
        app: web
        env: prod
        tier: front-end
spec:
    containers:
        - name: nginx-container
          image: nginx
```

## create namespace
```
kubectl create -f definition.yaml --namespace=dev
```