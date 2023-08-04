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