# image
```
image: docker.io/library/nginx
```
### docker.io=registry, gcr.io=google repository
### library=user/account
### nginx=image/repository
## pass credential on docker runtime on worker node
```
kubectl create secret docker-registry regcred \
    --docker-server=private-registry.io \
    --docker-username=registry-user \
    --docker-passowrd=password@1 \
    --docker-email=a@a.com
```
## pull image from private repo
```
spec:
    containers:
    - name: private-app
      image: private-repository/apps/internal-app
    imagePullSecrets:
    - name: regcred
```
