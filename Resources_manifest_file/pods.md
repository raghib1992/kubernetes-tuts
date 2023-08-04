# Deploy pods
kubectl run <name of the pod> --image <name of the image>
# Get the list of pods
kubectl get pods
# pods yaml file
## pod-definition.yml
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
      command:
      - sleep
      - "1000"
    schedulerName: my-custom-scheduler
```
kubeclt create -f pod-definition.yml
kubectl apply -f pod-definition.yml

# Get the details of the pods
kubectl describe pod <pod name>

# Delete Pod
kubectl delete pod <pod name>

## Generate POD Manifest YAML file (-o yaml). Don't create it(--dry-run)
```
kubectl run nginx --image=nginx --dry-run=client -o yaml
```

### The second option is to extract the pod definition in YAML format to a file using the command
```
kubectl get pod webapp -o yaml > my-new-pod.yaml
```
**********************************************
# complete pod-definition.yaml
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
      command:
      - sleep
      - "1000"
    schedulerName: my-custom-scheduler
    nodeName: worker-1
    tolerations:
    - key: "env"
      operator: "equal"
      value: "prod"
      effect: "preferNoSchedule"
    nodeSelector:
      type: special
    serviceAccountName: <sa-name>
```