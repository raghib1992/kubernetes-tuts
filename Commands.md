kubectl cluster-info
debug and diagnose cluster problems, use 'kubectl cluster-info dump'
kubectl set image deploy/<deploy name> <container name>=<new image name>
# To chage the docker client to docker server running in minikube
```
minikube docker-env
& minikube -p minikube docker-env --shell powershell | Invoke-Expression
```
# TO delete all not used container, image, network and build cache
```
docker system prune -a
```
# Create secret
kubectl create secret generic pgpassword --from-literal PGPASSWORD=password123

# Ingress
Ref https://www.joyfulbikeshedding.com/blog/2018-03-26-studying-the-kubernetes-ingress-system.html
    https://kubernetes.io/docs/concepts/services-networking/ingress/

## Create Nginx Controller on minikube
https://kubernetes.github.io/ingress-nginx/


kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml
minikube addons enable ingress

### To get minikube ip
minikube ip

kubectl get po -l app=web