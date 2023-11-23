```sh
# Viewing the Kubernetes Configuration
kubectl config view
# Finding the Current Context in Kubectl
kubectl config current-context
# Listing Kubernetes Contexts
kubectl config get-contexts
# Viewing Kubernetes Context Information
kubectl get context <context name>
# Creating a new Context
kubectl config set-context <context-name> --namespace=<namespace-name> --user=<user-name> --cluster=<cluster-name>
# Switch context
kubectl config use-context <context-name>
# Deleting a Kubernetes Context
kubectl config delete-context <context-name>
```

```sh
kubectl cluster-info
```
### debug and diagnose cluster problems, use 'kubectl cluster-info dump'
```sh
kubectl set image deploy/<deploy name> <container name>=<new image name>
```
### To chage the docker client to docker server running in minikube
```sh
minikube docker-env
& minikube -p minikube docker-env --shell powershell | Invoke-Expression
```
### TO delete all not used container, image, network and build cache
```
docker system prune -a
```
### Create secret
```sh
kubectl create secret generic pgpassword --from-literal PGPASSWORD=password123
```
### Ingress
- Ref 
    - *https://www.joyfulbikeshedding.com/blog/2018-03-26-studying-the-kubernetes-ingress-system.html*
    - *https://kubernetes.io/docs/concepts/services-networking/ingress/*

### Create Nginx Controller on minikube
- *https://kubernetes.github.io/ingress-nginx/*

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/
```
- provider/cloud/deploy.yaml
```sh
minikube addons enable ingress
```


## Rollout
```sh
# Check status
kubectl rollout status deployment/my-first-deployment

# Check History
kubectl rollout history deployment/<Deployment-Name>
kubectl rollout history deployment/my-first-deployment --revision=<revision number>

# Rollback to previous version
kubectl rollout undo deployment/my-first-deployment
kubectl rollout undo deployment/my-first-deployment --to-revision=3

# Rolling Restarts of Application
#Rolling restarts will kill the existing pods and recreate new pods in a rolling fashion
kubectl rollout restart deployment/<Deployment-Name>
kubectl rollout restart deployment/my-first-deployment

# Pause the Rollout

kubectl rollout pause deployment/<Deployment-Name>
kubectl rollout pause deployment/my-first-deployment

# Update deployment
kubectl set image deployment/my-first-deployment kubenginx=stacksimplify/kubenginx:4.0.0 --record=true

# Resume the Deployment
kubectl rollout resume deployment/my-first-deployment
```

## Expose deployment (Create Service)
```sh
kubectl expose deployment <Deployment-Name>  --type=NodePort --port=80 --target-port=80 --name=<Service-Name-To-Be-Created>

kubectl expose deployment my-first-deployment  --type=NodePort --port=80 --target-port=80 --name=my-first-service
```

## Create Namespace
```sh
kubectl get ns
kubectl get all -n kube-system
kubectl create ns prod
```

# Minikube
## To get minikube ip
```sh
minikube ip
```


kubectl get po -l app=web

1. replicas
```sh
kubectl scale --replicas=20 deployment/<Deployment-Name>
kubectl scale --replicas=20 deployment/my-first-deployment
```
2. image
```sh
kubectl set image deployment/<Deployment-Name> <Container-Name>=<Container-Image> --record=true
```
3. Edit Deployment
```sh
kubectl edit deployment/<Deployment-Name> --record=true
```
4. resources
```sh
kubectl set resources deployment/my-first-deployment -c=kubenginx --limits=cpu=20m,memory=30Mi
```