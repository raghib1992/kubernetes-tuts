1. create configmap for mongo manifest file

2. Create secret for mongodb manifest file

3. create deployment and service for mongodb

4. create deployment and service for webapp

5. Nginx Controller

## Ref: https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/


## a. clone ingress controller manifest file
```
git clone https://github.com/kubernetes/ingress-nginx.git
```
## b. as per environment use dir
### As I install on aws
```
cd deploy/static/provider
cd aws
```
## c. deploy nginix ingress controller
```
kubectl apply -f deploy.yaml
```

## d. check the ingress svc
```
kubectl get ingress svc -n ingress-nginx
```
## e. test ext.IP
```
curl <ext ip>
```

6. create ingree manifest file

or

7. install ingress-controller in minikube

### automatically start kubernetes nginx implementation of ingress controller 
```
minikube addons enable ingress
```
### to verify 
```
kubectl get pods -n ingress-nginx
```

8. create ingress manifest file

********************************************8
git clone https://github.com/nginxinc/kubernetes-ingress.git

process Ref: https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/

cd kubernetes-ingress/deployments

3. create ns and sa account for ingress controller from manifest file in common

kubectl apply -f common/ns-and-sa.yaml

4. Create asecret with a TLS certificate and a key for thr default server oin nginx

kubectl apply -f common/default-server-secret.yaml

5. Create a config map for customizing NGINX configuration (read more about customization) here

kubectl apply -f common/nginx-config.yaml

### Note Ingress controler starts with the "-enable-custom-resources"


6. (optional) to limit resoursec requirement for nginx contorller

kubectl apply -f common/custom-resource-definitions.yaml


7. Configure RBAC

kubectl apply -f rbac/rbac.yaml

8. Deploy Ingress controller as DaemonSet

kubectl apply -f daemon-set/nginx-ingress.yaml

9. verify

kubectl get ns

kubectl get all -n nginx-ingress