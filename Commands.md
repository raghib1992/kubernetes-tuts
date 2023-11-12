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


### To get minikube ip
minikube ip

kubectl get po -l app=web