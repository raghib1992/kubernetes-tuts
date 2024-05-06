# To measure the  resource utilization, we need to install metric server
### Install metric server in minikube
```sh
# check enable addons
minikube addons list
# enable metrics-server
minikube addons enable metrics-server
# check metric server pods in kube-system namespace
kubectl get pods -n kube-system
```

### Create hpa, rollout and service
```sh
kubectl apply -f 01-hpa.yaml
kubectl apply -f 02-rollout.yaml
kubectl apply -f 03-service.yaml
```

### Increase cpu utilization
```sh
# Create pod
kubectl run -i --tty load-generator --image=busy /bin/bash

while true; do wget -q -O- http://rollouts-demo; done
```