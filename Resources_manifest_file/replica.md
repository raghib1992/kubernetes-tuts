# Replication Controller
rc-definition.yaml
```
apiversion: v1
kind: relicationController
metadata:
    name: myapp-rc
    type: frontend
specs:
    template:
        metadata:
            name: myapp-pod
            env: prod
            tier: frontend
        specs:
            containers:
                - name: nginx-contorller
                  image: ngins
    replication: 3
```

## Command to create replication controller
```
kubectl create -f rc-definition.yaml
```

## To check the rc
```
kubectl get replicationcontroller
```

# Replica Sets
## replicasets-definition.yml
```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
    name: myapp-rc
    type: frontend
specs:
    template:
        metadata:
            name: myapp-pod
            env: prod
            tier: frontend
        specs:
            containers:
                - name: nginx-contorller
                  image: ngins
    replication: 3
    selector:
        matchLabels:
            type: front-end
```
### selector in replica set will define, which pod come under this replica set, even pods created before this replica sets have the same selector fall under this replica sets

## command to create 
```
kubectl apply -f replicaset-definition.yaml
kubectl delete -f replicaset-definition.yaml
kubectl delete <type> <name>
```

## scale
```
kubectl replace -f replicaset-definition.yml
kubectl scale --replicas=6 -f replicaset-definition.yml
kubectl scale --replicas=6 <type> <name of the replicaset>
kubectl edit <type> <name>
```
