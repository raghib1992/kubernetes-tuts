# Deploy pods
kubectl run <name of the pod> --image <name of the image>
# Get the list of pods
kubectl get pods
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
```
kubeclt create -f pod-definition.yml
kubectl apply -f pod-definition.yml

# Get the details of the pods
kubectl describe pod <pod name>

# Delete Pod
kubectl delete pod <pod name>